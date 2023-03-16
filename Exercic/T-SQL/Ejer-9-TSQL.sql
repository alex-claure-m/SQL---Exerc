USE[GD2015C1]
GO

/*
9)

Crear el/los objetos de base de datos que ante alguna modificación de un ítem de factura de un artículo con
 composición realice el movimiento de sus correspondientes componentes


 -- ANTE ALGUNA MODIFICACION => UPDATE .. PERO PRIMERO DEBO ACLARARLE QUE ES UN ALTER (DESPUES)
 -- a la tabla ITEM FACTURA . de un articulo con COMPISICION


 JODIDOOOO!!!
*/












 -- ======= OTRA FORMA ============
 /*

 ACLARACION: Como el enunciado dice "ante alguna modificacion" asumo que tengo que validar
este caso solo para UPDATE y que lo unico que puedo modificar de un item factura es la 
cantidad vendida de ese producto (item_cantidad), por lo tanto una vez modificado ese
campo, el trigger deberia ir a la tabla stock y modificar el stock disponible de los
componentes de ese producto. Como hay stocks negativos en la BD no valido que este tengo 
que ser mayor a 0, lo unico que valido es que no supere el limite de stock. El trigger
solo se activa si hay actualizaciones en la columna item_cantidad 
*/

IF OBJECT_ID('PR_ACTUALIZAR_COMPONENTES_ITEM_FACTURA') IS NOT NULL
	DROP PROCEDURE PR_ACTUALIZAR_COMPONENTES_ITEM_FACTURA
GO

CREATE PROCEDURE PR_ACTUALIZAR_COMPONENTES_ITEM_FACTURA (@NUMERO CHAR(8), @TIPO CHAR(1), @SUCURSAL CHAR(4), 
@PRODUCTO CHAR(8), @DIFERENCIA DECIMAL(12,2), @RESULTADO INT OUTPUT)
AS
BEGIN
	IF EXISTS (SELECT * FROM Composicion WHERE comp_producto = @PRODUCTO)
	BEGIN
		DECLARE @COMPONENTE CHAR(8)
		DECLARE @CANTIDAD DECIMAL(12,2)
		
		SET @RESULTADO = 1
		
		DECLARE C_ITEM_FACTURA_PR CURSOR FOR
		SELECT comp_componente, comp_cantidad 
		FROM Composicion 
		WHERE comp_producto = @PRODUCTO 
		
		OPEN C_ITEM_FACTURA_PR
		FETCH NEXT FROM C_ITEM_FACTURA_PR INTO @COMPONENTE, @CANTIDAD
		
		BEGIN TRANSACTION
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @LIMITE DECIMAL(12,2)	
			DECLARE @DEPOSITO CHAR(2)
			DECLARE @STOCK_ACTUAL DECIMAL(12,2)
			DECLARE @STOCK_RESULTANTE DECIMAL(12,2)
				
			SELECT TOP 1
			@STOCK_ACTUAL = stoc_cantidad,
			@LIMITE = ISNULL(stoc_stock_maximo, 0),
			@DEPOSITO = stoc_deposito
			FROM STOCK
			WHERE stoc_producto = @COMPONENTE
			ORDER BY stoc_cantidad ASC

			SET @STOCK_RESULTANTE = @STOCK_ACTUAL +  @DIFERENCIA * @CANTIDAD
		 		 
			IF @STOCK_RESULTANTE <= @LIMITE
			BEGIN
				UPDATE STOCK SET stoc_cantidad = @STOCK_RESULTANTE
				WHERE stoc_producto = @COMPONENTE
				AND stoc_deposito = @DEPOSITO
			END
			ELSE
			BEGIN
				SET @RESULTADO = 0
				RAISERROR('EL ITEM FACTURA CON NUMERO: %s, TIPO: %s, SUCURSAL: %s, PRODUCTO: %s NO CUMPLE CON LOS LIMITES DE STOCK', 16, 1, @NUMERO, @TIPO, @SUCURSAL, @PRODUCTO)
				BREAK				
			END
		FETCH NEXT FROM C_ITEM_FACTURA_PR INTO @COMPONENTE, @CANTIDAD
		END

		IF @RESULTADO = 1
			COMMIT TRANSACTION
		ELSE
			ROLLBACK TRANSACTION

		CLOSE C_ITEM_FACTURA_PR
		DEALLOCATE C_ITEM_FACTURA_PR
	END
	
	ELSE
		RAISERROR('EL PRODUCTO %s NO ES COMPUESTO', 16, 1, @PRODUCTO)
END
GO

IF OBJECT_ID('TR_MOVER_COMPONENTES') IS NOT NULL
	DROP TRIGGER TR_MOVER_COMPONENTES
GO

CREATE TRIGGER TR_MOVER_COMPONENTES
ON Item_Factura INSTEAD OF UPDATE
AS
BEGIN
	IF UPDATE(item_cantidad)
	BEGIN
		DECLARE @NUMERO CHAR(8)
		DECLARE @TIPO CHAR(1)
		DECLARE @SUCURSAL CHAR(4)
		DECLARE @PRODUCTO CHAR(8)
		DECLARE @DIFERENCIA DECIMAL(12,2)
		DECLARE @RESULTADO INT
		
		DECLARE C_ITEM_FACTURA CURSOR FOR
		SELECT
		inserted.item_numero, 
		inserted.item_tipo,
		inserted.item_sucursal,
		inserted.item_producto,
		deleted.item_cantidad - inserted.item_cantidad 	  
		FROM inserted 
		JOIN deleted ON  
		inserted.item_tipo + inserted.item_sucursal + 
		inserted.item_numero + inserted.item_producto = 
		deleted.item_tipo + deleted.item_sucursal +
		deleted.item_numero + deleted.item_producto
	
		OPEN C_ITEM_FACTURA
	
		FETCH NEXT FROM C_ITEM_FACTURA INTO @NUMERO, @TIPO, @SUCURSAL, 
		@PRODUCTO, @DIFERENCIA

		WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC PR_ACTUALIZAR_COMPONENTES_ITEM_FACTURA @NUMERO, @TIPO, @SUCURSAL,
			@PRODUCTO, @DIFERENCIA, @RESULTADO OUTPUT

			IF @RESULTADO = 1
			BEGIN
				UPDATE Item_Factura SET item_cantidad = item_cantidad - @DIFERENCIA
				WHERE item_numero = @NUMERO
				AND item_sucursal = @SUCURSAL
				AND item_tipo = @TIPO
				AND item_producto = @PRODUCTO
			END

			FETCH NEXT FROM C_ITEM_FACTURA INTO @NUMERO, @TIPO, @SUCURSAL, 
			@PRODUCTO, @DIFERENCIA
		END

		CLOSE C_ITEM_FACTURA
		DEALLOCATE C_ITEM_FACTURA
	END
END
GO

--PRUEBA

-- Si el producto del item_factura no es un producto compuesto el trigger
-- mostrara un aviso por pantalla, por ejemplo el producto '00001415' no es
-- compuesto

UPDATE Item_Factura SET item_cantidad = 10
WHERE item_producto = '00001415'
AND item_numero = '00092441'
AND item_sucursal = '0003'
AND item_tipo = 'A'

-- Busco un producto que sea compuesto como por ejemplo el producto con codigo '00001707'
-- para verificarlo ejecuto la siguiente instruccion y observo que esta
-- compuesto por 1 unidad del producto '00001491' y 2 unidades del producto '00014003'

SELECT *
FROM Composicion
WHERE comp_producto = '00001707' 

-- Ahora agarro un item factura de prueba con ese producto y se puede ver que la cantidad 
-- vendida fue de 10 unidades

SELECT *
FROM Item_Factura
WHERE item_producto = '00001707'
AND item_numero = '00068711'
AND item_sucursal = '0003'
AND item_tipo = 'A'

-- Agarro los depositos que tenga menos cantidad de esos productos, en
-- este caso  para el producto '00001491' es el deposito 16 y tiene 
-- una cantidad de 2 unidades y para el producto '00014003' es el deposito
-- 03 y tiene una cantidad de 14 unidades

SELECT TOP 1 *
FROM STOCK
WHERE stoc_producto = '00001491'
ORDER BY stoc_cantidad ASC

SELECT TOP 1 *
FROM STOCK
WHERE stoc_producto = '00014003'
ORDER BY stoc_cantidad ASC

-- Antes de hacer el update en item factura actualizo el stock maximo para 
-- el producto '00001419' ya que actualmente tiene valor NULL por lo tanto si no 
-- ejecutamos esta instruccion no va a querer hacer el update

UPDATE STOCK SET stoc_stock_maximo = 100
WHERE stoc_producto = '00001491'
AND stoc_deposito = '16'

-- Actualizo la cantidad vendida en vez de ser 10 ahora es 8, es decir
-- tengo que agregar al stock disponible 2 unidades de '00001491'
-- y 4 unidades de '00014003'

UPDATE Item_Factura SET item_cantidad = 8
WHERE item_producto = '00001707'
AND item_numero = '00068711'
AND item_sucursal = '0003'
AND item_tipo = 'A'

-- Despues de realizar el update deberia quedar para el producto '00001491' 
-- una cantidad de 4 (2 + 2 * 1) unidades  y para el producto '00014003' es el deposito
-- 03 y tiene una cantidad de 18 (14 + 2 * 2) unidades

SELECT TOP 1 *
FROM STOCK
WHERE stoc_producto = '00001491'
AND stoc_deposito = '16'

SELECT TOP 1 *
FROM STOCK
WHERE stoc_producto = '00014003'
AND stoc_deposito = '03'

-- Finalmente vemos que el item factura quedo modificado ahora figura una cantidad
-- vendida de 8 unidades 

SELECT *
FROM Item_Factura
WHERE item_producto = '00001707'
AND item_numero = '00068711'
AND item_sucursal = '0003'
AND item_tipo = 'A'

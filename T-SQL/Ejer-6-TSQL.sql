USE[GD2015C1]
GO

/*
6)

Realizar un procedimiento que si en alguna factura se facturaron componentes que conforman un
combo determinado  (o sea que juntos componen otro producto de mayor nivel), en cuyo caso deberá
reemplazar las filas correspondientes a dichos productos por una sola fila 
con el producto que componen con la cantidad de dicho producto que corresponda
*/

/*
-- hacer un procedure donde si en ALGUNA FACTURA
	-- se facturaron COMPONENTES que conforma COMBO DETERMINADO
		QUE ES ESO? => que juntos componene otro producto de MAYOR NIVEL
			Y ESTE REEMPLAZARA a las filas de ESOS PRODUCTOS
				agregandole la cantidad de producto que lo componen
*/
IF OBJECT_ID(N'compuesto_en_factura', 'N') IS NOT NULL
  DROP PROCEDURE compuesto_en_factura
GO

CREATE PROCEDURE compuesto_en_factura (@productoCodigo CHAR(8), @componente CHAR(8), @nroFactura CHAR(8))













/*
ACLARACION: Intente hacerlo para que funcione con varios niveles de composicion
pero se me hizo muy complejo asi que asumi que un producto a lo sumo estara compuesto
por 2 productos simples (es decir, estos no son compuestos).
*/

IF OBJECT_ID('PR_UNIFICAR_PRODUCTOS') IS NOT NULL
	DROP PROCEDURE PR_UNIFICAR_PRODUCTOS
GO

CREATE PROCEDURE PR_UNIFICAR_PRODUCTOS
AS
BEGIN
	DECLARE @PRODUCTO CHAR(8)
	DECLARE @COMPONENTE CHAR(8)
	DECLARE @TIPO CHAR(1)
	DECLARE @SUCURSAL CHAR(4)
	DECLARE @NUMERO CHAR(8)
	DECLARE @CANTIDAD_VENDIDA DECIMAL(12,2)
	DECLARE @PRECIO_PRODUCTO DECIMAL(12,2)
	DECLARE @CANTIDAD_COMPONENTE DECIMAL(12,2)

	DECLARE C_COMPONENTE CURSOR FOR
	SELECT item_tipo, item_sucursal, item_numero,
	item_producto, item_cantidad, comp_cantidad,
	comp_producto, prod_precio
	FROM Item_Factura
	JOIN Composicion ON item_producto = comp_componente
	JOIN Producto ON comp_producto = prod_codigo
	AND item_cantidad % comp_cantidad = 0
	
	OPEN C_COMPONENTE

	FETCH NEXT FROM C_COMPONENTE INTO @TIPO, @SUCURSAL, @NUMERO,
	@COMPONENTE, @CANTIDAD_VENDIDA, @CANTIDAD_COMPONENTE,
	@PRODUCTO, @PRECIO_PRODUCTO

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @COMPONENTE2 CHAR(8)
		DECLARE @CANTIDAD DECIMAL(12,2)

		SET @CANTIDAD = @CANTIDAD_VENDIDA / @CANTIDAD_COMPONENTE

		SET @COMPONENTE2 = 
		(SELECT item_producto
		FROM Item_Factura
		JOIN Composicion ON item_producto = comp_componente
		WHERE item_tipo = @TIPO 
		AND item_sucursal = @SUCURSAL 
		AND item_numero = @NUMERO 
		AND item_producto != @COMPONENTE 
		AND (item_cantidad / comp_cantidad) = @CANTIDAD)

		IF @COMPONENTE IS NOT NULL
		AND @COMPONENTE2 IS NOT NULL
		BEGIN
			DELETE FROM Item_Factura 
			WHERE item_tipo = @TIPO
			AND item_sucursal = @SUCURSAL
			AND item_numero = @NUMERO
			AND item_producto = @COMPONENTE

			DELETE FROM Item_Factura 
			WHERE item_tipo = @TIPO
			AND item_sucursal = @SUCURSAL
			AND item_numero = @NUMERO
			AND item_producto = @COMPONENTE2
		
			INSERT INTO Item_Factura 
			VALUES (@TIPO, @SUCURSAL, @NUMERO, 
			@PRODUCTO, @CANTIDAD, @PRECIO_PRODUCTO)
		END

	FETCH NEXT FROM C_COMPONENTE INTO @TIPO, @SUCURSAL, @NUMERO,
	@COMPONENTE, @CANTIDAD_VENDIDA, @CANTIDAD_COMPONENTE,
	@PRODUCTO, @PRECIO_PRODUCTO
	
	END
	
	CLOSE C_COMPONENTE
	DEALLOCATE C_COMPONENTE
END
GO

-- PRUEBA

-- Inserto un producto de prueba un compuesto por dos productos e inserto sus
-- correspondientes items factura

INSERT INTO Producto VALUES ('99999999', 'PROD1', 15, '001', '0001', 1)
INSERT INTO Producto VALUES ('99999998', 'COMP1', 10, '001', '0001', 1)
INSERT INTO Producto VALUES ('99999997', 'COMP2', 10, '001', '0001', 1)
INSERT INTO Composicion VALUES (1, '99999999', '99999998')
INSERT INTO Composicion VALUES (2, '99999999', '99999997')
INSERT INTO Factura VALUES ('A', '0003', '99999999', GETDATE(), 1, 0, 0, NULL)
INSERT INTO Item_Factura VALUES ('A', '0003', '99999999', '99999998', 2, 10)
INSERT INTO Item_Factura VALUES ('A', '0003', '99999999', '99999997', 4, 20)

-- Me fijo los items factura para asegurarme que fueron insertados

SELECT * FROM Item_Factura 
WHERE item_tipo = 'A' AND
item_sucursal = '0003' AND
item_numero = '99999999' 

-- Ahora ejecuto ejecuto el SP

EXEC PR_UNIFICAR_PRODUCTOS

-- Me fijo que se hayan eliminado las dos filas de sus componentes

SELECT * FROM Item_Factura 
WHERE item_tipo = 'A' AND
item_sucursal = '0003' AND
item_numero = '99999999' AND
item_producto = '99999998'

SELECT * FROM Item_Factura 
WHERE item_tipo = 'A' AND
item_sucursal = '0003' AND
item_numero = '99999997' AND
item_producto = '99999996'

-- Finalmente me fijo que para el producto 99999999 se haya insertado un item factura 
-- con cantidad 2

SELECT * FROM Item_Factura 
WHERE item_tipo = 'A' AND
item_sucursal = '0003' AND
item_numero = '99999999' AND
item_producto = '99999999'

-- Elimino los inserts de prueba

ALTER TABLE Producto DISABLE TRIGGER ALL

DELETE FROM Item_Factura WHERE item_tipo = 'A' AND item_numero = '99999999'
AND item_sucursal = '0003' AND item_producto = '99999999'

DELETE FROM Factura WHERE fact_tipo = 'A' AND fact_numero = '99999999'
AND fact_sucursal = '0003'

DELETE FROM Composicion WHERE comp_producto = '99999999' AND comp_componente = '99999998'
DELETE FROM Composicion WHERE comp_producto = '99999999' AND comp_componente = '99999997'

DELETE FROM Producto WHERE prod_codigo = '99999999'
DELETE FROM Producto WHERE prod_codigo = '99999998'
DELETE FROM Producto WHERE prod_codigo = '99999997'

ALTER TABLE Producto ENABLE TRIGGER ALL
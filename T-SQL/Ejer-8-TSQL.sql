USE[GD2015C1]
GO

/*
7)
Realizar un procedimiento que complete la tabla Diferencias de precios, para los productos facturados que tengan 
composición y en los cuales el precio de facturación sea diferente al precio del cálculo de los precios unitarios por 
cantidad de sus componentes, se aclara que un producto que compone a otro, también puede estar compuesto por otros 
y así sucesivamente, la tabla se debe crear y está formada por las siguientes columnas:


TABLA DE DIFERENCIAS 
------------------------------------------------------------------------------------
|  Código	|  Detalle  |    Cantidad     |  Precio generado  |  Precio facturado  |  
------------------------------------------------------------------------------------
|  Código	|  Detalle	|  Cantidad de    |  Precio que se    |  Precio del        |
|  del		|  del      |  productos que  |  se compone a 	  |  producto		   | 
|  articulo |  articulo	|  conforman el   |  traves de sus    |					   |
|           |           |  combo          |  componentes      |					   |
------------------------------------------------------------------------------------
*/

/*
-- completar la tabla DIFERENCIAS
	-- y que tiene que tener esta tabla? 
		los productos facturados que tengan composiscion
		-- donde los precios de facturacion sea DISTINTO al precio unitario x cantidad de sus componentes
	-- UN PRODUCTO COMPONE A OTRO y puede estar compuesto X OTROS
*/

IF OBJECT_ID('Diferencias', 'U') IS NOT NULL
	DROP TABLE Diferencias
GO

CREATE TABLE Diferencias(
	codigo CHAR(8),
	detalle CHAR(50),
	cantidad DECIMAL(12,2),
	precioGenerado DECIMAL(12,2),
	precioFacturado DECIMAL(12,2)
)
IF OBJECT_ID('Ejer_8_TSQL','P') IS NOT NULL
	DROP PROCEDURE Ejer_8_TSQL
GO

CREATE PROCEDURE Ejer_8_TSQL
AS
BEGIN
-- USARE POR MEDIO DE CURSOR
-- CUANDO USO CURSOR no hace falta SETEAR estos valores a medida que instancio
-- ya que lo puedo hacer todo al final con:
-- INSERT INTO tablaDiferencias Values(PARAMETROS) NEXT FROM cursor INTO (parametros del del declare)
	DECLARE @elCodigo CHAR(8)
	DECLARE @elDetalle CHAR(50)
	DECLARE @laCantidad DECIMAL(12,2)
	DECLARE @elPrecioGenerado DECIMAL(12,2)
	DECLARE @elPrecioFacturado DECIMAL(12,2)
	DECLARE cursor_diferencia CURSOR
		FOR SELECT ifac.item_producto,
					p.prod_detalle,
					(SELECT COUNT(c.comp_producto) FROM Composicion c
						INNER JOIN Producto p1 ON c.comp_producto = p1.prod_codigo),
					-- NO ME SIRVE USAR SUM ACA POR QUE tendria que hacer JOIN fuera del FROM 
					-- me conviene hacer un subselect sum..etc etc 
					(SELECT SUM(p.prod_precio * c.comp_cantidad) FROM Producto P
						INNER JOIN Composicion c on c.comp_producto = p.prod_codigo),
					ifac.item_precio

		FROM Item_Factura ifac
		INNER JOIN Producto p ON p.prod_codigo = ifac.item_producto
		-- pero recordemos que dice que UN PRODUCTO QUE TENGA COMPOSICION
		-- le aclaro que el item_producto que estoy buscando ESTE en la tabla COMPOSICION
		WHERE ifac.item_producto IN (
												SELECT comp_producto
												FROM Composicion )
		GROUP BY ifac.item_producto, p.prod_detalle, ifac.item_precio
		
		-- abro el cursor y le doy un fetch next con los parametros 
		OPEN  cursor_diferencia
		FETCH NEXT FROM cursor_diferencia
		INTO @elCodigo, @elDetalle, @laCantidad, @elPrecioGenerado, @elPrecioFacturado

		WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO Diferencias -- INSERTAME A LA TABLA DIFERENCIAS
				VALUES (@elCodigo,@elDetalle,@laCantidad,@elPrecioGenerado,@elPrecioFacturado)
				FETCH NEXT FROM cursor_diferencia
				INTO @elCodigo,@elDetalle,@laCantidad,@elPrecioGenerado,@elPrecioFacturado
			END
			CLOSE cursor_diferencia
			DEALLOCATE cursor_diferencia
	END
GO
		





		-- OTRA FORMA DE REALIZARLO , SOLO QUE EN VEZ DE CURSOR, LO HACE UN INPUT A LA TABLA
		-- Y ADEMAS UASNDO FUNCIONES PARA CALCULAR EL PRODUCTO COMPUESTO


IF OBJECT_ID('DIFERENCIAS') IS NOT NULL
	DROP TABLE DIFERENCIAS
GO

CREATE TABLE DIFERENCIAS ( 
	dif_codigo char(8),
	dif_detalle char(50),
	dif_cantidad NUMERIC(6,0),
	dif_precio_generado DECIMAL(12,2),
	dif_precio_facturado DECIMAL(12,2),
)
GO

IF OBJECT_ID('FX_PRODUCTO_COMPUESTO_PRECIO') IS NOT NULL
	DROP FUNCTION FX_PRODUCTO_COMPUESTO_PRECIO
GO

CREATE FUNCTION FX_PRODUCTO_COMPUESTO_PRECIO(@PRODUCTO CHAR(8))
	RETURNS DECIMAL(12,2)
AS
BEGIN
	DECLARE @PRECIO DECIMAL(12,2)
	
	SET @PRECIO =
	(SELECT SUM(DBO.FX_PRODUCTO_COMPUESTO_PRECIO(comp_componente) * comp_cantidad) 
	FROM Composicion
	WHERE comp_producto = @PRODUCTO)

	IF @PRECIO IS NULL
		SET @PRECIO = 
		(SELECT prod_precio 
		FROM Producto 
		WHERE prod_codigo = @PRODUCTO)
	
	RETURN @PRECIO
END
GO

IF OBJECT_ID('PR_COMPLETAR_DIFERENCIAS') IS NOT NULL
	DROP PROCEDURE PR_COMPLETAR_DIFERENCIAS
GO

CREATE PROCEDURE PR_COMPLETAR_DIFERENCIAS
AS
BEGIN
	INSERT INTO DIFERENCIAS
	SELECT 
	P1.prod_codigo, 
	P1.prod_detalle, 
	COUNT(DISTINCT comp_componente),
	DBO.FX_PRODUCTO_COMPUESTO_PRECIO(prod_codigo),
	P1.prod_precio
	FROM Producto P1
	JOIN Composicion ON P1.prod_codigo = comp_producto
	GROUP BY prod_codigo, prod_detalle, prod_precio
END
GO

--PRUEBA

-- Elijo un producto compuesto como por ejemplo el 00001707 y veo que tiene
-- un precio facturado de 27.20

SELECT *
FROM Producto
WHERE prod_codigo = '00001707'

-- El producto 00001707 esta compuesto por dos 2 productos, 1 unidad del 00001491 y 
-- 2 unidades del 00014003 

SELECT * 
FROM Composicion
JOIN Producto ON comp_componente = prod_codigo
WHERE comp_producto = '00001707'

-- Como los dos productos que componen al 00001707 no son compuestos solo hay que
-- sumar sus costos para obtener el costo del producto 00001707, haciendo la cuenta
-- me da que el costo de 00001707 es de 27.62 ya que el costo del producto 00001491 es
-- de 15.92 (15.92 * 1) y el costo del producto 00014003 es de 11.7 (5.85 * 2).
-- Ejecuto el SP para completar la tabla de DIFERENCIAS

EXEC PR_COMPLETAR_DIFERENCIAS

-- Por lo tanto en la tabla DIFERENCIAS en la columna de productos que lo componen 
-- deberia figurar un 2 para el producto 00001707, un precio generado de 27.62 y un
-- precio facturado de 27.20

SELECT *
FROM DIFERENCIAS
WHERE dif_codigo = '00001707'

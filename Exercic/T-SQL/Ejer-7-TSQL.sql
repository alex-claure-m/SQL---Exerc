USE[GD2015C1]
GO
/*
Hacer un procedimiento que dadas dos fechas complete la tabla Ventas. Debe
insertar una línea por cada artículo con los movimientos de stock generados por 
las ventas entre esas fechas. La tabla se encuentra creada y vacía.



TABLA DE VENTAS 
------------------------------------------------------------------------------------------------------------
|  Código	|  Detalle  |  Cant. Mov.  |  Precio de Venta  |  Renglon  |           Ganancia              |  
------------------------------------------------------------------------------------------------------------
|  Código	|  Detalle	|  Cantidad de |    Precio  	   |  Nro. de  |  Precio de venta * Cantidad     |
|  del		|  del      |  movimientos |    promedio 	   |  linea de |  -							     |
|  articulo |  articulo	|  de ventas   |    de venta	   |  la tabla |  Precio de producto * Cantidad  |
------------------------------------------------------------------------------------------------------------
*/


/*
tengo 2 fechas , debo completar una tabla 
	-- insert una linea por cada ARTICULO con los movimientos de stock generados x las ventas entre eas fechas.
*/

IF OBJECT_ID('Ventas', 'U') is not null
	DROP TABLE Ventas
GO
CREATE TABLE Ventas (
	codigo CHAR(8),
	detalle CHAR(50),
	cantidad_movimientos INT,
	precio_venta DECIMAL(12,2),
	renglon INT IDENTITY PRIMARY KEY,
	ganancia DECIMAL(12,2)
)

IF OBJECT_ID('Ejer_7_TSQL', 'P') is not null
	DROP PROCEDURE Ejer_7_TSQL
GO


CREATE PROCEDURE Ejer_7_TSQL (@fecha1 smalldatetime, @fecha2 smalldatetime)
AS 
BEGIN
	DECLARE @elCodigo CHAR(8)
	DECLARE @elDetalle CHAR(50)
	DECLARE @laCant_movimientos INT
	DECLARE @elPrecio_venta DECIMAL(12,2)
	DECLARE @elRenglon INT
	DECLARE @laGanancia DECIMAL(12,2)

	DECLARE cursor_articulos CURSOR -- son cursores que usaremos para recorrer la fila de las tablas
	-- el recorrido del cursor puede ser acompañado con FETCH que depende de como lo uses
	-- copiara la informacion del cual el cursor este parado
		FOR SELECT p.prod_codigo,
					p.prod_detalle,
					sum(ifac.item_cantidad),
					avg(ifac.item_precio),
					SUM(ifac.item_cantidad * ifac.item_precio) - SUM(ifac.item_cantidad * p.prod_precio)
		FROM Producto p
		INNER JOIN Item_Factura ifac ON p.prod_codigo = ifac.item_producto
		INNER JOIN Factura f ON f.fact_sucursal+f.fact_tipo+f.fact_numero = ifac.item_sucursal+ifac.item_tipo+ifac.item_numero
		WHERE f.fact_fecha BETWEEN @fecha1 AND @fecha2
		GROUP BY  p.prod_codigo, p.prod_detalle


		OPEN cursor_articulos -- una vez declarado e instanciado el SELECT  que hara que recorra ABRO el cursor y
		SET @elRenglon = 0 -- seteo en renglon = 0, para que de aca sea su autoincremental

		FETCH NEXT FROM cursor_articulos -- el fech me va a tomar la proxima linea del cursor ..DONDE
		INTO @elCodigo,@elDetalle,@laCant_movimiento,@elPrecio_venta,@laGanancia


		WHILE @@FETCH_STATUS = 0 -- mientras siga existiendo info a cual apuntar

		BEGIN
			INSERT INTO Ventas VALUES (@elCodigo,@elDetalle,@laCant_movimientos,@elPrecio_venta,@laGanancia)
			FETCH NEXT FROM cursor_articulos
			INTO @elCodigo,@elDetalle,@laCant_movimientos,@elPrecio_venta,@laGanancia

			END
		CLOSE cursor_articulos -- cierro el cursor
		DEALLOCATE cursor_articulos -- elimino el cache de cursor
	END
GO










-- PRUEBA

-- Para el ejemplo veo cuantas veces se vendio y el monto de venta total para el
-- producto 00001415 entre las fechas 01/01/2012 y 01/06/2012

SELECT item_producto, 
COUNT(*) AS 'VECES QUE SE VENDIO',
SUM(item_cantidad * item_precio) AS 'MONTO TOTAL VENDIDO'
FROM Item_Factura
JOIN Factura ON item_numero + item_sucursal + item_tipo =
fact_numero + fact_sucursal + fact_tipo
WHERE item_producto = '00001415' AND
fact_fecha BETWEEN '2012-01-01' AND '2012-06-01' 
GROUP BY item_producto

-- La consulta anterior devolvio que se vendio 30 veces el producto 00001415 y el monto
-- total de venta fue de 436.82 ahora veo de cuanto fue el costo de venta total

SELECT item_producto,
SUM(item_cantidad * prod_precio) AS 'COSTO DE VENTA TOTAL'
FROM Item_Factura
JOIN Producto ON item_producto = prod_codigo
JOIN Factura ON item_numero + item_sucursal + item_tipo =
fact_numero + fact_sucursal + fact_tipo
WHERE item_producto = '00001415' AND
fact_fecha BETWEEN '2012-01-01' AND '2012-06-01' 
GROUP BY item_producto

-- Ejecuto el SP para que complete la tabla VENTAS

EXEC PR_COMPLETAR_VENTAS '2012-01-01', '2012-06-01' 

-- De las consultas anteriores obtuve que el monto de venta total fue de 436.82 y
-- que el costo de venta total fue de 366.30 por lo tanto
-- la ganancia total es de 70.52 (436.82 - 366.30) y el producto se vendio 30 veces.
-- Por lo tanto compruebo si esos valores figuran en la tabla VENTAS

SELECT * 
FROM VENTAS
WHERE venta_codigo = '00001415'

-- Borro la tabla de VENTAS

IF OBJECT_ID('VENTAS') IS NOT NULL
	DROP TABLE VENTAS
GO
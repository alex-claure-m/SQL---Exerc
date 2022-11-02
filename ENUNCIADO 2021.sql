USE[GD2015C1]
GO
/*
Realizar una consulta SQL que retorne: 
	A�o 
	Cantidad de productos compuestos vendidos en el A�o 
	Cantidad de facturas realizadas en el A�o 
	Monto total facturado en el A�o 
	Monto total facturado en el A�o anterior.
Considerar:
	Aquellos A�os donde la cantidad de unidades vendidas de todos los art�culos sea mayor a 1000.
	Ordenar el resultado por cantidad vendida en el a�o
NOTA: No se permite el uso de sub-selects en el FROM ni funciones definidas por el usuario para este punto.
*/

SELECT year(F.fact_fecha) as [A�O]
	,(SELECT COUNT(*) FROM Producto p
		INNER JOIN Composicion c ON c.comp_producto = p.prod_codigo
		INNER JOIN Item_Factura ifac ON ifac.item_producto = p.prod_codigo
		INNER JOIN Factura f1 ON ifac.item_numero+ifac.item_sucursal+ifac.item_tipo = f1.fact_numero+f.fact_sucursal+f.fact_tipo
		WHERE YEAR(f1.fact_fecha) = year(f.fact_fecha)) as [cantidad de productos vendidos en el a�o]
	, COUNT (distinct f.fact_sucursal+F.fact_tipo+F.fact_numero) as [cantidad facturas realizadas]
	, (SELECT SUM(f2.fact_total) FROM factura f2
		WHERE year(f2.fact_fecha) =year(f.fact_fecha)) as [monto total por a�o]
	, (SELECT SUM(f2.fact_total) FROM factura f2
		WHERE year(f2.fact_fecha) =year(f.fact_fecha)-1) 
	FROM Factura f
	INNER JOIN Item_Factura ifac1 ON ifac1.item_numero = f.fact_numero AND ifac1.item_sucursal = f.fact_sucursal and ifac1.item_tipo = f.fact_tipo
	GROUP BY YEAR(f.fact_fecha)
	HAVING SUM(ifac1.item_cantidad) >1000
	ORDER BY sum(IFAC1.item_cantidad) desc



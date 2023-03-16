USE [GD2015C1]
GO

/*
7)
Generar una consulta que muestre para cada artículo código, detalle, mayor precio 
menor precio y % de la diferencia de precios (respecto del menor Ej.: menor precio = 
10, mayor precio =12 => mostrar 20 %). Mostrar solo aquellos artículos que posean 
stock
*/

SELECT p.prod_codigo as [Codigo], p.prod_detalle as [Detalle], MAX(ifac.item_precio) as [Mayor precio],
	MIN(ifac.item_precio) as [Menor Precio], (MAX(ifac.item_precio) - MIN(ifac.item_precio)) / MIN(ifac.item_precio)  * 100 as [diferenciaPorcentual] FROM Producto p
	INNER JOIN Item_Factura ifac ON p.prod_codigo = ifac.item_producto
	INNER JOIN STOCK s ON p.prod_codigo = s.stoc_producto
GROUP BY p.prod_codigo, p.prod_detalle
HAVING SUM (s.stoc_cantidad)>0
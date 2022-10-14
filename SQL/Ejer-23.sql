USE[GD2015C1]
GO

/*
23)
 Realizar una consulta SQL que para cada año muestre :
	 Año
	 El producto con composición más vendido para ese año.
	 Cantidad de productos que componen directamente al producto más vendido
	 La cantidad de facturas en las cuales aparece ese producto.
	El código de cliente que más compro ese producto.
	El porcentaje que representa la venta de ese producto respecto al total de venta del año.
El resultado deberá ser ordenado por el total vendido por año en forma descendente.

*/
/* NO LA ESTOY PENSANDO BIEN... MIRARLO LUEGO!!! */
SELECT year(f.fact_fecha) as [anio]
	--, (SELECT COUNT (*) FROM Producto p INNER JOIN Item_Factura ifac ON ifac.item_producto = p.prod_codigo) as [cantidad productos] -- cantidad de productos!
	, (SELECT TOP 1 c.comp_producto FROM Composicion c
		INNER JOIN Producto p ON p.prod_codigo = c.comp_producto
		INNER JOIN Item_Factura ifac ON p.prod_codigo = ifac.item_producto) as [Producto con mas composicion VENDIDA]
	, (SELECT COUNT(*) FROM Composicion c 
		INNER JOIN Producto p ON c.comp_producto = p.prod_codigo
		INNER JOIN Producto productoCompuesto ON productoCompuesto.prod_codigo = c.comp_componente) as [cantidad productos que componen]
	, (SELECT COUNT(*) FROM Factura f1 -- debido para ahorrar inner joins haco esto que me resulta mas faicl
		INNER JOIN Item_Factura ifac1 ON f1.fact_tipo+f1.fact_sucursal+f1.fact_numero = ifac1.item_tipo+ifac1.item_sucursal+ifac1.item_numero) as [cantidad facturas para ese producto]
	, (SELECT TOP 1 f.fact_cliente FROM Factura f) as [CLIENTE QUE COMPRO EL PRODUCTO]
FROM Factura f
	INNER JOIN Item_Factura ifac ON ifac.item_sucursal = f.fact_sucursal AND ifac.item_tipo = f.fact_tipo AND ifac.item_numero = f.fact_numero
	-- esta parte es para reAclarar que estamos hablando de productos que fueron vendidos y para que hayan sido vendidos entonces debe pasar por
	--  items_productos ...
GROUP BY year(f.fact_fecha) 
ORDER BY SUM(ifac.item_cantidad) DESC


------------------------------ OTRAS FORMAS DE RESOLUCION -----------------------------------------------

SELECT  YEAR(F.fact_fecha) 'Año',
		I.item_producto 'Producto mas vendido',
		(SELECT COUNT(*) FROM Composicion WHERE comp_producto = I.item_producto) 'Cant. Componentes',
		COUNT(DISTINCT F.fact_tipo + F.fact_sucursal + F.fact_numero) 'Facturas',
		(SELECT TOP 1 fact_cliente
		FROM Factura JOIN Item_Factura
			ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
		WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha) AND item_producto = I.item_producto
		GROUP BY fact_cliente
		ORDER BY SUM(item_cantidad) DESC) 'Cliente mas Compras',
		SUM(ISNULL(I.item_cantidad, 0)) /
			(SELECT SUM(item_cantidad)
			FROM Factura JOIN Item_Factura
				ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
			WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha))*100 'Porcentaje'
FROM Factura F JOIN Item_Factura I
    ON (F.fact_tipo + F.fact_sucursal + F.fact_numero = I.item_tipo + I.item_sucursal + I.item_numero)
WHERE  I.item_producto = (SELECT TOP 1 item_producto
							   FROM Item_Factura
							   JOIN Composicion
							     ON item_producto = comp_producto
							   JOIN Factura
							     ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
							 WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha)
							 GROUP BY item_producto
							 ORDER BY SUM(item_cantidad) DESC)
GROUP BY YEAR(F.fact_fecha), I.item_producto
ORDER BY SUM(I.item_cantidad) DESC




SELECT YEAR(f.fact_fecha) AS [ANIO]
	, ifac.item_cantidad AS [CANTIDAD PRODUCTOS]
	, (SELECT COUNT(*) FROM Composicion c
			JOIN Producto p ON p.prod_codigo = c.comp_producto
			JOIN Producto productoComponente ON productoComponente.prod_codigo = c.comp_componente
			) AS [PRODUCTOS QUE ESTAN COMPUESTOS]
	, (SELECT COUNT(f.fact_numero+f.fact_tipo+f.fact_sucursal) FROM Factura f) as [ cantidad facturas]
	, (SELECT TOP 1 f.fact_cliente FROM Factura f) as [CLIENTE QUE COMPRO EL PRODUCTO]
	
	FROM Factura f
		JOIN Item_Factura ifac ON ifac.item_sucursal = f.fact_sucursal AND ifac.item_tipo = f.fact_tipo AND ifac.item_numero = f.fact_numero
	GROUP BY YEAR(f.fact_fecha), ifac.item_cantidad
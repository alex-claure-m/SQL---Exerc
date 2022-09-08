USE [GD2015C1]
GO

/*
-5)
Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de 
stock que se realizaron para ese artículo en el año 2012 (egresan los productos que 
fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011.
*/


SELECT p.prod_codigo as [Codigo Articulo], p.prod_detalle as [Detalle], SUM(ifac.item_cantidad) as [Cantidad Total] FROM Producto p
--	INNER JOIN STOCK s ON p.prod_codigo = s.stoc_producto .....NO TIENE NADA QUE VER CON LA TABLA STOCK
	INNER JOIN Item_Factura ifac ON ifac.item_producto = p.prod_codigo
	INNER JOIN Factura f ON f.fact_sucursal = ifac.item_sucursal AND f.fact_tipo = ifac.item_tipo AND f.fact_numero = ifac.item_numero
WHERE YEAR(f.fact_fecha) = 2012
GROUP BY p.prod_codigo, p.prod_detalle
HAVING SUM(ifac.item_cantidad) >
	(SELECT SUM(ifac2.item_cantidad) FROM Item_Factura ifac2 
		INNER JOIN Factura f2 ON ifac2.item_sucursal = f2.fact_sucursal AND f2.fact_sucursal = ifac2.item_sucursal AND f2.fact_numero = ifac2.item_numero
	WHERE YEAR(f2.fact_fecha) = 2011 AND ifac2.item_producto = p.prod_codigo)
-- falto agregar que para comparar el año 2011 , debe ser el mismo producto 
USE [GD2015C1]
GO

/*
12
Mostrar nombre de producto, cantidad de clientes distintos que lo compraron importe,
promedio pagado por el producto, cantidad de depósitos en los cuales hay stock del
producto y stock actual del producto en todos los depósitos. Se deberán mostrar
aquellos productos que hayan tenido operaciones en el año 2012 y los datos deberán
ordenarse de mayor a menor por monto vendido del producto.
*/

SELECT p.prod_codigo codProducto, p.prod_detalle, count (distinct c.clie_codigo) clientesCompraroProducto, avg(item_precio) importePromedio, 
	(SELECT COUNT(DISTINCT s.stoc_deposito) FROM STOCK s WHERE p.prod_codigo = s.stoc_producto AND ISNULL(s.stoc_cantidad,0)>0) AS [depositos con stock], -- cantidad de depositos con stock
	(SELECT SUM(s.stoc_cantidad) FROM STOCK s WHERE p.prod_codigo = s.stoc_producto) -- cantidad de stock de producto
	FROM Producto p
	JOIN Item_Factura ifac ON ifac.item_producto = p.prod_codigo
	JOIN Factura f ON ifac.item_tipo = f.fact_tipo AND ifac.item_sucursal = f.fact_sucursal AND ifac.item_numero = f.fact_numero
	JOIN Cliente c ON c.clie_codigo = f.fact_cliente
	WHERE YEAR(f.fact_fecha) = '2012'
GROUP BY p.prod_codigo,p.prod_detalle


SELECT * FROM Producto
USE [GD2015C1]
GO

/*
11)
Realizar una consulta que retorne el detalle de la familia, la cantidad diferentes de
productos vendidos y el monto de dichas ventas sin impuestos. Los datos se deberán 
ordenar de mayor a menor, por la familia que más productos diferentes vendidos tenga, 
solo se deberán mostrar las familias que tengan una venta superior a 20000 pesos para 
el año 2012.
*/

SELECT fam.fami_detalle as [detalle de familia], COUNT(DISTINCT p.prod_codigo) as [Productos distinto]
	, SUM(ifac.item_precio * ifac.item_cantidad) as [suma ventas sin impuesto] FROM Producto p
	-- la suma de producto x cantidad en item.factura deberia ser igual a que si tomo factura.total
	inner join Familia fam ON p.prod_familia = fam.fami_id
	inner join Item_Factura ifac ON p.prod_codigo = ifac.item_producto
	inner join Factura f on ifac.item_sucursal = f.fact_sucursal and ifac.item_tipo = f.fact_tipo and f.fact_numero = ifac.item_numero
	WHERE year (f.fact_fecha) = 2012
	group by fami_detalle
	--solo se deberán mostrar las familias que tengan una venta superior a 20000 pesos  
	having sum (ifac.item_precio * ifac.item_cantidad) > 20000
	order by 3 DESC

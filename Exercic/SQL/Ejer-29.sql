USE [GD2015C1]
GO
/*
Se solicita que realice una estadística de venta por producto para el año 2011, solo para los productos
que pertenezcan a las familias que tengan más de 20 productos asignados a ellas, la cual deberá devolver las siguientes columnas:
a. Código de producto
b. Descripción del producto
c. Cantidad vendida
d. Cantidad de facturas en la que esta ese producto
e. Monto total facturado de ese producto
Solo se deberá mostrar un producto por fila en función a los considerandos establecidos antes.El resultado deberá ser ordenado por el la cantidad vendida de mayor a menor.*/SELECT p.prod_codigo as [codigo de producto]	, p.prod_detalle as [descripcion del prodcuto]	, SUM(ifac.item_cantidad) as [cantidad vendida]	, count( distinct f.fact_sucursal+f.fact_tipo+f.fact_numero) as [cantidad de facturas ]	, sum (f.fact_total) as [monto total]	 FROM Producto p	 INNER JOIN Item_Factura ifac on P.prod_codigo = ifac.item_producto	 INNER JOIN Factura f ON f.fact_sucursal+f.fact_tipo+f.fact_numero = ifac.item_sucursal+ifac.item_tipo+ifac.item_numero	 INNER JOIN Familia fam ON fam.fami_id = p.prod_familia	 WHERE YEAR(f.fact_fecha) = 2011	 GROUP BY p.prod_codigo , p.prod_detalle, fam.fami_id	 -- el having es por que NECESITO SABER LOS PRODUCTOS QUE PERTENEZCAN A FAMILIAS EN QUE TENGA + DE 20 PRODUCTOS 	 HAVING ( 
			SELECT count( distinct p1.prod_familia )
			FROM Producto p1
			INNER JOIN Familia fam1 ON fami_id = prod_familia	
			WHERE fam1.fami_id = fam.fami_id

			GROUP BY fam1.fami_id
			) > 20
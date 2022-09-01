USE [GD2015C1]
GO


/*
-2)
Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por 
cantidad vendida.
*/
/* la gracia aca es que tengo el año 2012 y eso lo tiene la tabla FACTURA
pero yo necesito la cantidad que estara en ITEM_FACTURA que se relacionara con el producto*/

SELECT p.prod_codigo as [Codigo de Producto], p.prod_detalle as [DETALLE DEL PRODUCTO], sum(itemf.item_cantidad) as [Cantidad total Vendida]
 FROM Producto p 
 INNER JOIN Item_Factura itemf ON p.prod_codigo = itemf.item_producto 
 INNER JOIN factura f ON f.fact_sucursal = itemf.item_sucursal AND f.fact_tipo = itemf.item_tipo AND f.fact_numero = itemf.item_numero
 WHERE YEAR(f.fact_fecha) = 2012
 GROUP BY p.prod_codigo, p.prod_detalle
 ORDER BY 3 ASC

/*cuando yo le pido que agrupe por item_cantidad
me va a repetir datos debido a que lo que yo use en el SELECT (sum(item_factura)) es una sumatoria
entonces yendo al GROUP BY item_facura .. me va a volver a repetir info para reagrupar*/

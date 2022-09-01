USE [GD2015C1]
GO

/*
-3)
Realizar una consulta que muestre código de producto, nombre de producto y el stock 
total, sin importar en que deposito se encuentre, los datos deben ser ordenados por 
nombre del artículo de menor a mayor
*/

SELECT p.prod_codigo as [Codigo Producto], p.prod_detalle as [Nombre Producto], SUM(s.stoc_cantidad) as [STOCK TOTAL]
	 FROM Producto p
	INNER JOIN STOCK s ON s.stoc_producto = p.prod_codigo
GROUP BY p.prod_codigo, p.prod_detalle
ORDER BY 2 ASC


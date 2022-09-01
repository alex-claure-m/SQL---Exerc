USE [GD2015C1]
GO

/*
--4)
Realizar una consulta que muestre para todos los art�culos c�digo, detalle y cantidad de 
art�culos que lo componen. Mostrar solo aquellos art�culos para los cuales el stock 
promedio por dep�sito sea mayor a 100.
*/

SELECT p.prod_codigo as [CODIGO PRODUCTO], p.prod_detalle as [DELTALLE PRODUCTO]
	  FROM Producto p
	 LEFT JOIN Composicion c ON c.comp_producto = p.prod_codigo
	 INNER JOIN STOCK s ON s.stoc_producto = p.prod_codigo
	 GROUP BY p.prod_codigo, p.prod_detalle
	 HAVING AVG(s.stoc_cantidad) > 100

/*
aclara que necesito articulos en los cuales el promedio sea > 100
claramente esto lo debo obtener luego de haberlos matcheado y agrupado
*/
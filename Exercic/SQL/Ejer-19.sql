USE [GD2015C1]
GO

/*
19)
En virtud de una recategorizacion de productos referida a la familia de los mismos se 
solicita que desarrolle una consulta sql que retorne para todos los productos:
	 Codigo de producto
	 Detalle del producto
	 Codigo de la familia del producto
	 Detalle de la familia actual del producto
	 Codigo de la familia sugerido para el producto
	 Detalla de la familia sugerido para el producto
La familia sugerida para un producto es la que poseen la mayoria de los productos cuyo 
detalle coinciden en los primeros 5 caracteres.

En caso que 2 o mas familias pudieran ser sugeridas se debera seleccionar la de menor 
codigo. Solo se deben mostrar los productos para los cuales la familia actual sea 
diferente a la sugerida
Los resultados deben ser ordenados por detalle de producto de manera ascendente
*/

SELECT p.prod_codigo as [codigo de producto]
	, p.prod_detalle as [detalle del producto]
	, fam.fami_id as [codigo de la familia]
	, fam.fami_detalle as [detalle de la familia]
	, (SELECT TOP 1 fam1.fami_id from Familia fam1
		INNER JOIN producto p1 ON p1.prod_familia = fam1.fami_detalle
		WHERE SUBSTRING(p.prod_detalle,1,5) = SUBSTRING(p1.prod_detalle,1,5) -- filtro de los 1eros 5 caracteres (QUE TIENE QUE SER IGUAL al del subselect y del FROM)
		GROUP BY fam1.fami_id
		ORDER BY COUNT(*) ASC ) as [ID familia sugerida] -- EL ORDENAMIENTO SEGUN LA CANTIDAD ASCENDENTE DE ESTO!
	 FROM Producto p
	 INNER JOIN Familia fam ON p.prod_familia = fam.fami_id
	 GROUP BY P.prod_codigo, P.prod_detalle,fam.fami_detalle, fam.fami_id
	 ORDER BY 2 asc -- DEBE ESTAR ORDENADO POR EL DETALLE ASCENDENTE
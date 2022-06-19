USE [GD2015C1]
GO

/*
19
En virtud de una recategorizacion de productos referida a la familia de los mismos  se
solicita que desarrolle una consulta sql que retorne para todos los productos:
 
 Codigo de producto
 Detalle del producto
 Codigo de la familia del producto
 Detalle de la familia actual del producto
 Codigo de la familia sugerido para el producto
 Detalla de la familia sugerido para el producto
 
La familia sugerida para un producto es la que poseen la mayoria de los productos cuyo
detalle coinciden en los primeros 5 caracteres. 
En caso que 2 o mas familias pudieran ser sugeridas se debera seleccionar la de menor
codigo.  Solo se deben mostrar los productos para los cuales la familia actual sea
diferente a la sugerida 
Los resultados deben ser ordenados por detalle de producto de manera ascendente 
*/

SELECT p1.prod_codigo as [codigo del producto]
	,p1.prod_detalle as [detalle del producto]
	,fam.fami_id as [FAMILIA DEL PRODUCTO]
	,fam.fami_detalle as [detalle de la familia del producto]
	, (SELECT TOP 1 pro.prod_familia FROM Producto pro -- seleccion de la Familia de menor CODIGO
		WHERE SUBSTRING(pro.prod_detalle,1,5) = SUBSTRING(p1.prod_detalle,1,5) -- filtro de los 1eros 5 caracteres
		GROUP BY pro.prod_familia
		ORDER BY COUNT(*) ASC ) as [ID familia sugerida] -- el ordenamiento de de forma ASCENDENTE
		-- falta:  Detalla de la familia sugerido para el producto
	FROM Producto p1
		JOIN Familia fam ON p1.prod_familia = fam.fami_id
GROUP BY p1.prod_codigo, p1.prod_detalle,fam.fami_id,fami_detalle
ORDER BY p1.prod_detalle ASC
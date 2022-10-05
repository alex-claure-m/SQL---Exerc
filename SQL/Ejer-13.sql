USE[GD2015C1]
GO
/*
13)
Realizar una consulta que retorne para cada producto que posea composición nombre 
del producto, precio del producto, precio de la sumatoria de los precios por la cantidad 
de los productos que lo componen. Solo se deberán mostrar los productos que estén 
compuestos por más de 2 productos y deben ser ordenados de mayor a menor por 
cantidad de productos que lo componen.
*/


SELECT com.comp_producto as [CODIGO DEL PRODUCTO]
	 , p.prod_detalle as [NOMBRE DEL PRODUCTO]
	 , SUM (componenteProducto.prod_precio * com.comp_cantidad) AS [PRECIO DE LA CANTIDAD DE PRODUCTOS QUE SE COMPONEN]FROM Composicion com
 JOIN Producto p ON p.prod_codigo = com.comp_producto
 JOIN Producto componenteProducto ON com.comp_componente = componenteProducto.prod_codigo
 GROUP BY com.comp_producto, p.prod_detalle
 HAVING SUM (com.comp_cantidad) > 2
 ORDER BY 3 DESC


SELECT * FROM Composicion


--SEGUN EL PROFE

SELECT compuesto.prod_detalle, compuesto.prod_precio, CAST(SUM(componente.prod_precio*c.comp_cantidad) AS decimal(12,2)) AS 'Precio Total'
FROM Composicion c JOIN Producto compuesto ON c.comp_producto=compuesto.prod_codigo
					JOIN Producto componente ON c.comp_componente=componente.prod_codigo
GROUP BY compuesto.prod_detalle, compuesto.prod_precio
HAVING SUM(c.comp_cantidad)>2
ORDER BY SUM(c.comp_cantidad) DESC

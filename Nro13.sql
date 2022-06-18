USE [GD2015C1]
GO
/*
13
Realizar una consulta que retorne para cada producto que posea composición 
nombre del producto, precio del producto, precio de la sumatoria de los precios por
la cantidad de los productos que lo componen. Solo se deberán mostrar los
productos que estén compuestos por más de 2 productos y deben ser ordenados de
mayor a menor por cantidad de productos que lo componen.
*/

SELECT p.prod_codigo idProducto,p.prod_detalle, p.prod_precio, sum(p2.prod_precio * c.comp_cantidad) as [Precio Total Compuesto]  
FROM Producto p
	JOIN Composicion c ON p.prod_codigo = c.comp_producto
	JOIN Producto p2 ON p2.prod_codigo = c.comp_componente -- el componente_componente contiene el codigo del producto2
GROUP BY p.prod_codigo,p.prod_detalle,p.prod_precio
HAVING COUNT(c.comp_componente) > 2
ORDER BY COUNT(c.comp_componente) DESC

SELECT * FROM Composicion


USE[GD2015C1]
GO

/*
15)
Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos 
(en la misma factura) más de 500 veces. El resultado debe mostrar el código y 
descripción de cada uno de los productos y la cantidad de veces que fueron vendidos 
juntos. El resultado debe estar ordenado por la cantidad de veces que se vendieron 
juntos dichos productos. Los distintos pares no deben retornarse más de una vez.
Ejemplo de lo que retornaría la consulta:


PROD1 DETALLE1			PROD2		DETALLE2				VECES
1731 MARLBORO KS		1718		PHILIPS MORRIS KS		507
1718 PHILIPS MORRIS KS	1705		PHILIPS MORRIS BOX 10	562
*/


SELECT ifac.item_producto as [codigo producto]
	, p1.prod_detalle [detalle producto]
	, ifac2.item_producto as [Codigo producto 2]
	, p2.prod_detalle as [detalle del producto]
	, COUNT(*) as [cantidad de veces compradas ] FROM Item_Factura ifac
	INNER JOIN Item_Factura ifac2 ON ifac.item_tipo = ifac2.item_tipo AND ifac.item_numero = ifac2.item_numero AND ifac.item_sucursal = ifac2.item_sucursal
	INNER JOIN Producto p1 ON ifac.item_producto = p1.prod_codigo
	inner join Producto p2 on ifac2.item_producto = p2.prod_codigo
	-- medio tosco esta parte pero recapitulemos, es una forma de resolver. como se penso?
	-- debo seleccionar los pares de productos en los cuales se hayan vendido juntos
	-- para eso hago un join entre itemFactura 1 e ItemFactura 2, para corrobar que ambos fueron vendidos 
	-- corroboro de que es producto este en itemFactura
 WHERE ifac.item_producto > ifac2.item_producto 
 -- aca debo analizar
 GROUP BY ifac.item_producto, p1.prod_detalle, ifac2.item_producto, p2.prod_detalle
 HAVING COUNT(*) > 500 -- que la cantidad de veces compradas sea > 500
 ORDER BY COUNT(*) DESC -- de mayor a menor
 

 -- OTRA FORMA DE RESOLUCION -- MIRARLA LUEGO

 -- lo podria hacer por mismo producto, p1,p2 o que haya un item_codigo y suquery de los productos
SELECT p.prod_codigo, p.prod_detalle FROM Producto p 
	JOIN Item_Factura ifac ON p.prod_codigo = ifac.item_producto

SELECT ifac1.item_producto codigoProducto
	, (SELECT p.prod_detalle FROM Producto p WHERE ifac1.item_producto = p.prod_codigo) AS [PRODUCTO 1] -- producto 1 distinto
	, (SELECT p.prod_detalle FROM Producto p WHERE ifac2.item_producto = p.prod_codigo) AS [PRODUCTO 2] -- producto 2 disntinto
	, COUNT (*) AS [Cantidad de veces venidas]
	FROM Item_Factura ifac1, Item_Factura ifac2
WHERE ifac1.item_numero = ifac2.item_numero AND ifac1.item_sucursal = ifac2.item_sucursal AND ifac1.item_tipo = ifac2.item_tipo 
		AND ifac1.item_producto != ifac2.item_producto -- que no repita
GROUP BY ifac1.item_producto, ifac2.item_producto
HAVING COUNT(*) > 500
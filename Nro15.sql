USE [GD2015C1]
GO
/*
15
Escriba una consulta que retorne los pares de productos que hayan sido vendidos
juntos (en la misma factura) más de 500 veces. El resultado debe mostrar el código
y descripción de cada uno de los productos y la cantidad de veces que fueron
vendidos juntos. El resultado debe estar ordenado por la cantidad de veces que se
vendieron juntos dichos productos. Los distintos pares no deben retornarse más de
una vez. 

Ejemplo de lo que retornaría la consulta: 
 
--------------------------------------------------------------------------------------
|  PROD1     |  DETALLE1            |  PROD2     |  DETALLE2               |  VECES  |
-------------------------------------------------------------------------------------|
|  00001731  |  MARLBORO KS         |  00001718  |  Linterna con pilas     |  507    |
|  00001718  |  Linterna con pilas  |  00001705  |  PHILIPS MORRIS BOX 10  |  562    |
--------------------------------------------------------------------------------------
*/
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


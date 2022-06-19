USE [GD2015C1]
GO

/*
18
Escriba una consulta que retorne una estadística de ventas para todos los rubros. 

La consulta debe retornar:

DETALLE_RUBRO: Detalle del rubro
VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
PROD1: Código del producto más vendido de dicho rubro
PROD2: Código del segundo producto más vendido de dicho rubro
CLIENTE: Código del cliente que compro más productos del rubro en los últimos
30 días
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar
ordenada por cantidad de productos diferentes vendidos del rubro.
*/

SELECT r.rubr_detalle as [RUBRO]
	,SUM(ifac.item_cantidad * ifac.item_precio) as [SUMA DE VENTAS]
	,(SELECT TOP 1 p1.prod_codigo FROM Producto p1 
		JOIN Item_Factura ifac1 ON ifac1.item_producto = p1.prod_codigo
		JOIN Rubro r1 ON r1.rubr_id = p1.prod_rubro -- matcheame el rubro con el pruducto del rubro
		--WHERE r.rubr_id = p1.prod_rubro
		GROUP BY p1.prod_codigo
		ORDER BY SUM(ifac1.item_cantidad) DESC ) AS [PRODUCTO 1] -- por la cantidad mas alta
	, (SELECT TOP 1 p1.prod_codigo FROM Producto p1 
		JOIN Item_Factura ifac1 ON ifac1.item_producto = p1.prod_codigo
		JOIN Rubro r1 ON r1.rubr_id = p1.prod_rubro -- matcheame el rubro con el pruducto del rubro
		WHERE p1.prod_codigo <> (SELECT TOP 1 p1.prod_codigo FROM Producto p1 
								JOIN Item_Factura ifac1 ON ifac1.item_producto = p1.prod_codigo
								JOIN Rubro r1 ON r1.rubr_id = p1.prod_rubro
								GROUP BY p1.prod_codigo
								ORDER BY SUM(ifac1.item_cantidad) DESC)
		GROUP BY p1.prod_codigo
		ORDER BY SUM(ifac1.item_cantidad) DESC ) AS [PRODUCTO 2] -- por la cantidad mas alta
	-- FALTA CLIENTE
FROM Rubro r
	JOIN Producto p ON p.prod_rubro = r.rubr_id
	JOIN Item_Factura ifac ON ifac.item_producto = p.prod_codigo
GROUP by r.rubr_detalle


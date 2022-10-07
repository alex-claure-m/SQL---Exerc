USE[GD2015C1]
GO

	-- ES EXCELENTE ESTE PARA HACER TANTO AL TOP1 - COMO AL SIGUIENTE
/*
18)

Escriba una consulta que retorne una estadística de ventas para todos los rubros.
La consulta debe retornar:
	DETALLE_RUBRO: Detalle del rubro
	VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
	PROD1: Código del producto más vendido de dicho rubro
	PROD2: Código del segundo producto más vendido de dicho rubro
	CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30 días



La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada 
por cantidad de productos diferentes vendidos del rubro
*/

SELECT r.rubr_id as [id rubro], r.rubr_detalle as [detalle del rubro]
	, SUM(ifac.item_cantidad * ifac.item_cantidad) as [Sumatoria de las Ventas]
	, (SELECT TOP 1 (p1.prod_codigo) FROM Producto p1
		INNER JOIN Item_Factura ifac1 ON p1.prod_codigo = ifac1.item_producto -- con esto le digo que el producto que mas se vendio este en item_fac
		INNER JOIN Rubro r1 ON p1.prod_rubro = r1.rubr_id
		GROUP BY p1.prod_codigo
		-- EL CHISTE DE ACA ES QUE CUANDO TENGO QUE BUSCAR UN PRODUCTO, ESE PRODUCTO DEBE ESTAR ADEMAS EN EL RUBRO
		-- YA QUE EL PROBLEMA PRINCIPAL HABLA DE QUE NECESITO DAR EL DETALLE DEL RUBRO ==> ESE PRODUCTO DEBE ESTAR MATCHEADO CON RUBRO
		ORDER BY SUM(ifac1.item_cantidad) DESC 
	)  AS [PRODUCTO 1]
	, (SELECT TOP 1 (p1.prod_codigo) FROM Producto p1
		INNER JOIN Item_Factura ifac1 ON p1.prod_codigo = ifac1.item_producto -- con esto le digo que el producto que mas se vendio este en item_fac
		INNER JOIN Rubro r1 ON p1.prod_rubro = r1.rubr_id
		WHERE p1.prod_codigo <> (SELECT TOP 1 p1.prod_codigo FROM Producto p1 -- aca le digo que debe ser distinto al top 1 de arriba
		-- ENTONCES ME VA A TOMAR COMO EL SIGUIENTE AL TOP
								JOIN Item_Factura ifac1 ON ifac1.item_producto = p1.prod_codigo
								JOIN Rubro r1 ON r1.rubr_id = p1.prod_rubro
								GROUP BY p1.prod_codigo
								ORDER BY SUM(ifac1.item_cantidad) DESC)
		GROUP BY p1.prod_codigo
		ORDER BY SUM(ifac1.item_cantidad) DESC 
	)  AS [PRODUCTO 2]
	, (SELECT TOP 1 C.clie_codigo FROM Cliente C
		INNER JOIN factura f1 ON c.clie_codigo = f1.fact_cliente
		INNER JOIN Item_Factura ifac2 ON f1.fact_numero = ifac2.item_numero AND f1.fact_sucursal = ifac2.item_sucursal AND f1.fact_tipo = ifac2.item_tipo
		INNER JOIN Producto pr ON ifac2.item_producto = pr.prod_codigo
		INNER JOIN Rubro rr ON pr.prod_rubro = rr.rubr_id
		 ) as [Cliente] -- que compro  mas productos del rubro en los ultimos 30 dias -- falta eso!!
	FROM Producto p
	INNER JOIN Item_Factura ifac ON p.prod_codigo = ifac.item_producto
	INNER JOIN Rubro r ON r.rubr_id = p.prod_rubro
	GROUP BY r.rubr_id, r.rubr_detalle


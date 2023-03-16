USE[GD2015C1]
GO

/*
27)
Escriba una consulta sql que retorne una estadística basada en la facturacion por año y  envase devolviendo las siguientes columnas:
	 Año
	 Codigo de envase
	 Detalle del envase
	 Cantidad de productos que tienen ese envase
	 Cantidad de productos facturados de ese envase
	 Producto mas vendido de ese envase
	 Monto total de venta de ese envase en ese año
	 Porcentaje de la venta de ese envase respecto al total vendido de ese año

Los datos deberan ser ordenados por año y dentro del año por el envase con más facturación de mayor a menor
*/

SELECT year(f.fact_fecha) as [anio]
	,  e.enva_detalle as [detalle del envase]
	, SUM (ifac.item_cantidad)
--	 , (SELECT COUNT (*) FROM Producto p WHERE p.prod_envase = e.enva_codigo) AS [CANTIDAD PRODUCTOS EN ESE ENVASE] me parece medio redundante poner un where
-- sabiendo que afuera del subselect estaba un inner join quje ademas podria jo matchear con un where ... duda a consultar!
	, (
		SELECT TOP 1 item_producto
		FROM Producto
			INNER JOIN Item_Factura
				ON item_producto = prod_codigo
			INNER JOIN Factura
				ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
		WHERE prod_envase = E.enva_codigo AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) DESC
		)
		-- MIRAR ULTIMOS 2 REQUISITOS 
	 FROM Factura f
	 INNER JOIN Item_Factura ifac ON f.fact_numero+f.fact_tipo+f.fact_sucursal = ifac.item_numero+ifac.item_tipo+ifac.item_sucursal
	 INNER JOIN Producto p ON ifac.item_producto = p.prod_codigo
	 INNER JOIN Envases e ON p.prod_envase = e.enva_codigo
GROUP BY year(f.fact_fecha) , e.enva_detalle, e.enva_codigo
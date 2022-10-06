USE[GD2015C1]
GO

/*
17)
Escriba una consulta que retorne una estadística de ventas por año y mes para cada
producto.
La consulta debe retornar:
	PERIODO: Año y mes de la estadística con el formato YYYYMM
	PROD: Código de producto
	DETALLE: Detalle del producto
	CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo
	VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del periodo pero del año anterior
	CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el  periodo

La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada 
por periodo y código de producto
*/

SELECT STR(year(f.fact_fecha)) + STR (MONTH(f.fact_fecha)) AS [PERIODO]
	,P.prod_codigo AS [CODIGO DE PRODUCTO]
	,P.prod_detalle AS [DETALLE DEL PRODUCTO]
	,SUM(ifac.item_cantidad) as [CANTIDAD VENDIDA] -- cantidad vendida del producto
	,ISNULL((SELECT TOP 1 SUM(ifac2.item_cantidad) FROM Item_Factura ifac2 
		INNER JOIN factura f2 ON f2.fact_sucursal = ifac2.item_sucursal AND f2.fact_tipo = ifac2.item_tipo AND f2.fact_numero = ifac2.item_numero
		WHERE YEAR(f2.fact_fecha) = (YEAR(f2.fact_fecha) - 1) AND MONTH(f2.fact_fecha) = MONTH(f.fact_fecha) AND p.prod_codigo = ifac2.item_producto
	),0) as [VENTA DEL AÑO ANTERIOR EN EL MISMO CICLO] -- ACLARA QUE NO DEBE DEVOLVER NULL, entonces le coloco de antemano ISNULL, SI ES => = 0
	, COUNT(f.fact_numero) as [cantidad de facturas vendidas]
	 FROM Producto p
	INNER JOIN Item_Factura ifac ON p.prod_codigo = ifac.item_producto
	INNER JOIN Factura f ON ifac.item_numero = f.fact_numero AND ifac.item_tipo = f.fact_tipo AND ifac.item_sucursal = f.fact_sucursal
GROUP BY YEAR(fact_fecha), MONTH(fact_fecha),p.prod_codigo,p.prod_detalle

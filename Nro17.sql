/*
17
Escriba una consulta que retorne una estadística de ventas por año y mes para cada
producto. 

La consulta debe retornar: 

PERIODO: Año y mes de la estadística con el formato YYYYMM
PROD: Código de producto
DETALLE: Detalle del producto
CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo
VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del
periodo pero del año anterior
CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el
periodo

La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar
ordenada por periodo y código de producto.
*/

SELECT STR(YEAR(f.fact_fecha)) + STR(MONTH(f.fact_fecha)) AS [Periodo]
	, p.prod_codigo as [CODIGO PRODUCTO]
	, p.prod_detalle as [DETALLE PRODUCTO]
	, SUM(ifac.item_cantidad) as [cantidad vendida]
	, ISNULL((SELECT SUM(ifac.item_cantidad) FROM Item_Factura ifac 
		JOIN factura f ON ifac.item_tipo = f.fact_tipo AND ifac.item_sucursal = f.fact_sucursal AND ifac.item_numero = f.fact_numero
		WHERE YEAR(f.fact_fecha)= (YEAR(f.fact_fecha)-1) AND MONTH(f.fact_fecha) = MONTH(f.fact_fecha) AND p.prod_codigo = ifac.item_producto),0) 
	AS [VENTAS DEL ANIO ANTERIOR] -- EL isnull ESTA PARA QUE NO TE APAREZCA EL NULL , forzame a que me de un 0 u otro valor que le ponga
	, COUNT (f.fact_numero) as [CANTIDAD DE FACTURA]
	FROM Producto p 
	JOIN Item_Factura ifac ON ifac.item_producto = p.prod_codigo
	JOIN Factura f ON f.fact_tipo = ifac.item_tipo AND f.fact_sucursal = ifac.item_sucursal AND ifac.item_numero = f.fact_numero
GROUP BY YEAR(fact_fecha), MONTH(fact_fecha),p.prod_codigo,p.prod_detalle



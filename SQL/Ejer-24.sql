USE[GD2015C1]
GO

/*
24)
. Escriba una consulta que considerando solamente las facturas correspondientes a los dos vendedores con mayores comisiones, 
	retorne los productos con composición  facturados al menos en cinco facturas,

La consulta debe retornar las siguientes columnas:
	Código de Producto
	Nombre del Producto
	Unidades facturadas
El resultado deberá ser ordenado por las unidades facturadas descendente.
*/
-- aclara que deben ser los 2 vendedores con mayores comisiones.

SELECT p.prod_codigo as [codigo de producto]
	, p.prod_detalle as [nombre de producto]
	, SUM(ifac.item_cantidad) as [cantidad productos] -- no hacia falta hacer un select enorme , con tener la sumatoria sacado de item_producto alcanzaba
	--, (SELECT COUNT(*) FROM Factura f	
	--	INNER JOIN Item_Factura ifac ON f.fact_tipo + f.fact_sucursal + f.fact_numero = ifac.item_tipo + ifac.item_sucursal + ifac.item_tipo
	--	INNER JOIN Producto p ON p.prod_codigo = ifac.item_producto) as [unidades facturadas]
 FROM Producto p 
 	INNER JOIN Composicion c ON p.prod_codigo = c.comp_producto
 	INNER JOIN Item_Factura ifac ON p.prod_codigo = ifac.item_producto
 	INNER JOIN factura f ON f.fact_tipo + f.fact_sucursal + f.fact_numero = ifac.item_tipo + ifac.item_sucursal + ifac.item_numero
	WHERE f.fact_vendedor IN (SELECT TOP 2 empl_codigo FROM Empleado ORDER BY empl_comision DESC)
	-- aclara que deben ser facturas de los 2 vendedores con mayores comisiones
	-- entonces el vendedor debe estar dentro de un subselect que dice : tops 2 de empleados ordeandos por comision
 GROUP BY p.prod_codigo, p.prod_detalle
 HAVING COUNT(*) >= 5 -- aca le digo que  debe ser mayor a 5 productos facturados
 ORDER BY 3 DESC


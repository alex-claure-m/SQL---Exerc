USE [GD2015C1]
GO

/*
28)

Escriba una consulta sql que retorne una estad�stica por A�o y Vendedor que retorne las siguientes columnas:
	 A�o.
	 Codigo de Vendedor
	 Detalle del Vendedor
	 Cantidad de facturas que realiz� en ese a�o
	 Cantidad de clientes a los cuales les vendi� en ese a�o.
	 Cantidad de productos facturados con composici�n en ese a�o
	 Cantidad de productos facturados sin composicion en ese a�o.
	 Monto total vendido por ese vendedor en ese a�o
Los datos deberan ser ordenados por a�o y dentro del a�o por el vendedor que haya vendido mas productos diferentes de mayor a menor.
*/

SELECT YEAR(f.fact_fecha) as [Anio]
	, f.fact_vendedor as [codigo de vendedor]/*el codigo del vendedor*/
	, e.empl_nombre as [detalle vendedor]
	, COUNT(distinct f.fact_numero+f.fact_sucursal+f.fact_tipo) as [cantidad facturas realizadas]
	, count(distinct f.fact_cliente) as [cliente que se vendio]
	, (select count(p.prod_codigo) FROM Producto p
		INNER JOIN Composicion c ON p.prod_codigo = c.comp_producto
		INNER JOIN Item_Factura ifac ON ifac.item_producto = p.prod_codigo -- productos FACTURADOS
		INNER JOIN Factura f2 ON f2.fact_numero+f2.fact_sucursal+f2.fact_tipo = ifac.item_numero+ifac.item_sucursal+ifac.item_tipo
		WHERE year(f2.fact_fecha) = YEAR(f.fact_fecha) AND f.fact_vendedor = f2.fact_vendedor) as [producto con composicion facturados]
	, (select count(p2.prod_codigo) FROM Producto p2
		INNER JOIN Item_Factura ifac2 ON ifac2.item_producto = p2.prod_codigo
		INNER JOIN Factura f3 ON f3.fact_numero+f3.fact_tipo+f3.fact_sucursal = ifac2.item_numero+ifac2.item_tipo+ifac2.item_sucursal
		WHERE p2.prod_codigo NOT IN (select c2.comp_producto from Composicion c2)) as [cantidad propductos sin compoisicion en ese a�o]
	, sum(f.fact_total) as [monto total]	 
	 FROM Factura f
	 INNER JOIN Empleado e ON e.empl_codigo = f.fact_vendedor
	 GROUP BY e.empl_nombre, f.fact_vendedor , year(f.fact_fecha)
	 ORDER BY 1 DESC, (  -- es el ordenamiento de cantidad de productos que fueron vendidos en ese A�O de mayor a menor!!!
					SELECT COUNT(DISTINCT prod_codigo)
					FROM Producto
						INNER JOIN Item_Factura
							ON item_producto = prod_codigo
						INNER JOIN Factura
							ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
					WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha) AND fact_vendedor = F.fact_vendedor
					) DESC

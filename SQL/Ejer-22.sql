USE[GD2015C1]
GO

/*
22)

Escriba una consulta sql que retorne una estadistica de venta para todos los rubros por 
trimestre contabilizando todos los años. Se mostraran como maximo 4 filas por rubro (1 
por cada trimestre).
Se deben mostrar 4 columnas:
	Detalle del rubro
	Numero de trimestre del año (1 a 4)
	Cantidad de facturas emitidas en el trimestre en las que se haya vendido al menos un producto del rubro
	Cantidad de productos diferentes del rubro vendidos en el trimestre 

El resultado debe ser ordenado alfabeticamente por el detalle del rubro y dentro de cada 
rubro primero el trimestre en el que mas facturas se emitieron.
No se deberan mostrar aquellos rubros y trimestres para los cuales las facturas emitiadas 
no superen las 100.
En ningun momento se tendran en cuenta los productos compuestos para esta 
estadistica.
*/
SELECT r.rubr_detalle as [detalle del rubro]
	,DATEPART(QUARTER, f.fact_fecha) as [trimestre] -- con esta funcion T-sql le digo que me divida la fecha en 4 partes 
	,COUNT( f.fact_sucursal + f.fact_tipo + f.fact_numero) as [facturas vendidas] 
	-- usarlo solo en esta parte debido a que es mucho mas facil que hacer otro subselect con inner join
	,COUNT(DISTINCT p.prod_codigo) as [cantidad de productos de rubro vendidos en el trimestre]
FROM Rubro r
	 INNER JOIN Producto p ON r.rubr_id = p.prod_rubro
	 INNER JOIN Item_Factura ifac ON p.prod_codigo = ifac.item_producto
	 INNER JOIN Factura f ON ifac.item_numero = f.fact_numero AND ifac.item_sucursal = f.fact_sucursal AND ifac.item_tipo = f.fact_tipo
WHERE P.prod_codigo NOT IN (SELECT c.comp_producto FROM Composicion c) -- que no tome en cuenta que el producto tambien este en productos compuestos
GROUP BY r.rubr_detalle , DATEPART(QUARTER, fact_fecha) -- aca le digo que me ordene por trimestre! y detalle del rubro
HAVING COUNT (DISTINCT  f.fact_sucursal + f.fact_tipo + f.fact_numero ) > 100 
-- RECORDA QUE FACTURA TIENE 3 PK, cuando se habla algo puntual relacionado a factura, tiene que estar presente estas 3 PK.
ORDER BY 1,3

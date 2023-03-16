USE[GD2015C1]
GO

/*
14)
Escriba una consulta que retorne una estadística de ventas por cliente. Los campos que 
debe retornar son:

-Código del cliente
-Cantidad de veces que compro en el último año
-Promedio por compra en el último año
-Cantidad de productos diferentes que compro en el último año
-Monto de la mayor compra que realizo en el último año
Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en 
el último año.
No se deberán visualizar NULLs en ninguna columna
*/


SELECT c.clie_codigo as [Codigo de Cliente]
	,  (SELECT count(*) FROM Factura f
		WHERE c.clie_codigo = f.fact_cliente
		)as [Cliente que compro cositas] -- cantidad de veces que compro se le puede redefinir como esto
	, AVG (f.fact_total) as [promedio de compras]
	, COUNT(distinct ifac.item_producto) as [productos distintos]
		FROM Cliente c
	JOIN Factura f ON f.fact_cliente =c.clie_codigo
	JOIN Item_Factura ifac ON ifac.item_sucursal = f.fact_sucursal AND ifac.item_numero = f.fact_numero AND ifac.item_tipo = f.fact_tipo
WHERE YEAR(f.fact_fecha) = (SELECT TOP 1 YEAR(f.fact_fecha) from Factura f ORDER BY f.fact_fecha DESC )
-- el chiste del : Monto de la mayor compra que realizo en el último año
-- o -Cantidad de productos diferentes que compro en el último año
-- es decirle => tomame la MAYOR FECHA DESCENDIENTE


GROUP BY c.clie_codigo
/*
14
Escriba una consulta que retorne una estad�stica de ventas por cliente. Los campos
que debe retornar son: 

C�digo del cliente
Cantidad de veces que compro en el �ltimo a�o
Promedio por compra en el �ltimo a�o
Cantidad de productos diferentes que compro en el �ltimo a�o
Monto de la mayor compra que realizo en el �ltimo a�o 
*/

SELECT c.clie_codigo
	,COUNT(DISTINCT F.fact_tipo + F.fact_sucursal + F.fact_numero) AS [Cantidad de veces que compro en el ultimo a�o]
	, AVG(f.fact_total) AS [promedio de compra]
	, COUNT (DISTINCT ifac.item_producto) AS [cantidad de productos difenrentes]
	--, (SELECT TOP 1 f.fact_total FROM Factura f WHERE f.fact_cliente = c.clie_codigo AND YEAR(f.fact_fecha) =
	--	SELECT TOP 1 YEAR(f2.) FROM Factura f2)
	-- no llego a realizar el monto de la mayor compra en el ultimo a�o
	FROM Cliente c -- la compra de cada cliente se ve en la FACTURA
JOIN Factura f ON c.clie_codigo = f.fact_cliente
JOIN Item_Factura ifac ON ifac.item_sucursal = f.fact_sucursal AND ifac.item_numero = f.fact_numero AND ifac.item_tipo = f.fact_tipo
WHERE YEAR(F.fact_fecha) = (SELECT TOP 1 YEAR(f.fact_fecha) from Factura f ORDER BY f.fact_fecha DESC )
GROUP BY c.clie_codigo


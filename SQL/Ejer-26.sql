USE[GD2015C1]
GO

/*
26)
Escriba una consulta sql que retorne un ranking de empleados devolviendo las 
siguientes columnas:
	 Empleado
	 Depósitos que tiene a cargo
	 Monto total facturado en el año corriente
	 Codigo de Cliente al que mas le vendió
	 Producto más vendido
	 Porcentaje de la venta de ese empleado sobre el total vendido ese año. -- falto este
Los datos deberan ser ordenados por venta del empleado de mayor a menor
*/

SELECT e.empl_codigo as [codigo de empleado]
	, (SELECT COUNT(DISTINCT d.depo_codigo) FROM DEPOSITO d WHERE d.depo_encargado = e.empl_codigo) AS [deposito a cargo]
	, (SELECT SUM(f1.fact_total) FROM Factura F1 WHERE  f1.fact_vendedor = e.empl_codigo AND YEAR(f.fact_fecha) = YEAR(f1.fact_fecha)) as [suma total de la factura]
	, (SELECT TOP 1 f1.fact_cliente FROM Factura f1 WHERE f1.fact_vendedor = e.empl_codigo AND YEAR(f.fact_fecha) = YEAR(f1.fact_fecha)) AS [CLIENTE AL QUE MAS SE VENDIO]
	, (SELECT TOP 1 ifac.item_producto FROM Item_Factura ifac INNER JOIN Factura f ON ifac.item_sucursal+ifac.item_tipo+ifac.item_numero = f.fact_sucursal+f.fact_tipo+f.fact_numero 
		WHERE f.fact_vendedor = e.empl_codigo ) as [PRODUCTO + VENDIDO]
	 FROM Empleado e
	 INNER JOIN Factura f ON e.empl_codigo = f.fact_vendedor
GROUP BY e.empl_codigo , YEAR(F.fact_fecha)
ORDER BY 1, 3 DESC


----------------------------------------------------------------------------------------------------------------



SELECT * FROM Empleado e

SELECT * FROM Factura

SELECT fact_vendedor 'Código Empleado',
		(SELECT COUNT(DISTINCT depo_codigo) FROM DEPOSITO WHERE depo_encargado = fact_vendedor) 'Depositos a Cargo',
		SUM(ISNULL(fact_total, 0)) 'Monto total',
		(SELECT TOP 1 fact_cliente
		FROM Factura
		WHERE fact_vendedor = F.fact_vendedor AND YEAR(fact_fecha) = 2012
		GROUP BY fact_cliente
		ORDER BY SUM(ISNULL(fact_total, 0)) DESC) 'Cliente mas ventas',
		(SELECT TOP 1 item_producto
		FROM Factura JOIN Item_Factura
			ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
		WHERE fact_vendedor = F.fact_vendedor AND
			YEAR(fact_fecha) = 2012
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) DESC) 'Producto mas vendido',
		(SUM(ISNULL(fact_total, 0)) / 
			(SELECT SUM(ISNULL(fact_total, 0))
			FROM Factura
			WHERE YEAR(fact_fecha) = 2012)) * 100 'Porcentaje'
FROM Factura F
WHERE YEAR(fact_fecha) = 2012
GROUP BY fact_vendedor
ORDER BY 3 DESC







SELECT E.empl_codigo
	,COUNT(DISTINCT D.depo_codigo) [Cant Depositos que tiene a cargo]
	,(
		SELECT SUM(fact_total)
		FROM Factura
		WHERE fact_vendedor = E.empl_codigo AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
		
		) AS [Monto total facturado en el año corriente]
	,(							
		SELECT TOP 1 fact_cliente
		FROM Factura
		WHERE fact_vendedor = E.empl_codigo AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
		GROUP BY fact_cliente
		ORDER BY SUM(fact_total) DESC
	) AS [Codigo Cliente al que mas vendio]
	,(
		SELECT TOP 1 item_producto
		FROM Item_Factura
			INNER JOIN Factura
				ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
		WHERE fact_vendedor = E.empl_codigo AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) DESC
	) AS [Producto mas vendido]
	,((
		SELECT SUM(fact_total)
		FROM Factura
		WHERE fact_vendedor = E.empl_codigo AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
	)
	 *100) / (
				SELECT SUM(fact_total)
				FROM Factura
				WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha)
				) AS [Porcentaje vendido por el empleado sobre el total anual]

FROM EMPLEADO E
	LEFT OUTER JOIN DEPOSITO D
		ON D.depo_encargado = E.empl_codigo
	LEFT OUTER JOIN Factura F
		ON F.fact_vendedor = E.empl_codigo
WHERE YEAR(F.fact_fecha) = 2012--YEAR(GETDATE())
GROUP BY E.empl_codigo, YEAR(F.fact_fecha)
ORDER BY 3 DESC
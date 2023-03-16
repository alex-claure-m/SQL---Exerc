USE[GD2015C1]
GO

/*
25)
Realizar una consulta SQL que para cada año y familia muestre :
a. Año
b. El código de la familia más vendida en ese año.
c. Cantidad de Rubros que componen esa familia.
d. Cantidad de productos que componen directamente al producto más vendido de esa familia. -- NO LO TOME EN CUENTA. DIFICIL
e. La cantidad de facturas en las cuales aparecen productos pertenecientes a esa familia. 
f. El código de cliente que más compro productos de esa familia.
g. El porcentaje que representa la venta de esa familia respecto al total de venta del año.
El resultado deberá ser ordenado por el total vendido por año y familia en forma 
descendente.
*/

SELECT f.fact_cliente from Factura f

SELECT YEAR(f.fact_fecha) as [Anio]
	, p.prod_familia as [codigo de familia] 
	, (SELECT COUNT(DISTINCT p1.prod_rubro) FROM Producto p1 WHERE p.prod_familia = p1.prod_familia) as [cantidad de rubros] 
	-- PENSEMOS => DEBEMOS TENER ESTO EN CUENTA . SE DICE LA CANTIDAD DE RUBROS QUE COMPONE A ESA FAMILIA. ENTONCES
	-- debemos decir que el producto.familia debe ser igual a un p1.producto.familia en un SUBSELECT
	-- , (SELECT COUNT(*) FROM Composicion c )   ==> no estaria entendiendo como replantear esta parte!
	, COUNT(DISTINCT fact_tipo + fact_sucursal + fact_numero) AS [factura para ESE PRODUCTO]
	, (SELECT TOP 1 f1.fact_cliente FROM Factura f1
		INNER JOIN Item_Factura ifac ON f1.fact_tipo + f1.fact_sucursal + f1.fact_numero = ifac.item_tipo + ifac.item_sucursal + ifac.item_numero
		INNER JOIN Producto p1 ON ifac.item_producto = p1.prod_codigo) as [cliente que mas compro] -- este para mi estsa bien!
	, (SELECT SUM(f.fact_total) FROM Factura f1 WHERE year(f1.fact_fecha) = year(f.fact_fecha)) AS [porcentaje] -- ALTA DUDA DE COMO OBTENER PORCENTAJE
	FROM Factura f
	INNER JOIN Item_Factura ifac ON ifac.item_sucursal + ifac.item_tipo + ifac.item_numero = f.fact_sucursal + f.fact_tipo + f.fact_sucursal
	INNER JOIN Producto p ON p.prod_codigo = ifac.item_producto
	GROUP BY year(f.fact_fecha), p.prod_familia















SELECT YEAR(fact_fecha) 'Año',
		prod_familia 'Cod. Familia',
		(SELECT fami_detalle FROM Familia WHERE fami_id = prod_familia) 'Familia', --EXTRA
		(SELECT COUNT(DISTINCT prod_rubro) FROM Producto WHERE prod_familia = p1.prod_familia) 'Cant. Rubros',
		(SELECT COUNT(*) FROM Composicion WHERE comp_producto =
			(SELECT TOP 1 prod_codigo
			FROM Factura JOIN Item_Factura ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
						 JOIN Producto     ON item_producto = prod_codigo
			WHERE YEAR(fact_fecha) = YEAR(f1.fact_fecha) AND prod_familia = p1.prod_familia
			GROUP BY prod_codigo
			ORDER BY SUM(item_cantidad) DESC)) 'Cant. Componentes',
		COUNT(DISTINCT fact_tipo + fact_sucursal + fact_numero) 'Cant. Facturas',
		(SELECT TOP 1 fact_cliente
		FROM Factura
		JOIN Item_Factura ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
			JOIN Producto  ON item_producto = prod_codigo
		WHERE YEAR(fact_fecha) = YEAR(f1.fact_fecha) AND prod_familia = p1.prod_familia
		GROUP BY fact_cliente
		ORDER BY SUM(item_cantidad) DESC	) 'Cliente mas Compras',
		(SUM(item_cantidad * item_precio) /
		(SELECT SUM(fact_total) FROM Factura WHERE YEAR(fact_fecha) = YEAR(f1.fact_fecha))) * 100 'Porcentaje'
FROM Factura f1 JOIN Item_Factura ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
				JOIN Producto p1  ON item_producto = prod_codigo
WHERE prod_familia = (SELECT TOP 1 prod_familia
						FROM Factura JOIN Item_Factura ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
									 JOIN Producto     ON item_producto = prod_codigo
						WHERE YEAR(fact_fecha) = YEAR(f1.fact_fecha)
						GROUP BY prod_familia
						ORDER BY SUM(item_cantidad) DESC)
GROUP BY YEAR(fact_fecha), prod_familia
ORDER BY SUM(item_cantidad)




-- ----------------------------------------------- 





SELECT YEAR(F.fact_fecha) AS [AÑO]
	,FAM.fami_id
	,COUNT(DISTINCT P.prod_rubro) AS [CANTIDAD DE RUBROS QUE COMPONEN LA FAMILIA (SUBDIVIDO ANUALMENTE)]
	,CASE 
		WHEN(
				(
		SELECT TOP 1 prod_codigo
		FROM Producto
			INNER JOIN Item_Factura
				ON item_producto = prod_codigo
			INNER JOIN Factura
				ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
		WHERE prod_familia = FAM.fami_id AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
		GROUP BY prod_codigo
		ORDER BY SUM(item_cantidad) DESC
		) IN (
		
				SELECT comp_producto
				FROM Composicion
			)
		)
		THEN (
				SELECT COUNT(*)
				FROM Composicion
				WHERE comp_producto = (
										SELECT TOP 1 prod_codigo
										FROM Producto
											INNER JOIN Item_Factura
												ON item_producto = prod_codigo
											INNER JOIN Factura
												ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
										WHERE prod_familia = FAM.fami_id AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
										GROUP BY prod_codigo
										ORDER BY SUM(item_cantidad) DESC
										)
		)
		ELSE 1
	END AS [CANT DE PROD QUE CONFORMAN EL MAS VENDIDO]
	,COUNT(DISTINCT F.fact_tipo+F.fact_numero+F.fact_sucursal) AS [CANT FACTURAS EN LOS QUE APARECEN PRODS DE LA FAMI]
	,(
		SELECT TOP 1 fact_cliente
		FROM Factura
			INNER JOIN Item_Factura
				ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
			INNER JOIN Producto	
				ON prod_codigo = item_producto
		WHERE prod_familia = FAM.fami_id AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
		GROUP BY fact_cliente
		ORDER BY SUM(item_cantidad) DESC
		) AS [CLIENTE QUE MAS COMPRO DE LA FAMILIA]
	,(SUM(IFACT.item_cantidad*IFACT.item_precio) *100) / (
													SELECT SUM(item_cantidad * item_precio)
													FROM Factura
														INNER JOIN Item_Factura
															ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
														INNER JOIN Producto	
															ON prod_codigo = item_producto
													WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha)
													) AS [PORCENTAJE VENDIDO POR FAMILIA VS TOTAL ANUAL]
FROM FAMILIA FAM
	INNER JOIN Producto P
		ON P.prod_familia = FAM.fami_id
	INNER JOIN Rubro R
		ON R.rubr_id = P.prod_rubro
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON  F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_tipo = IFACT.item_tipo

WHERE FAM.fami_id = (
						SELECT TOP 1 prod_familia
						FROM Producto
							INNER JOIN Item_Factura
								ON item_producto = prod_codigo
							INNER JOIN Factura
								ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
						GROUP BY prod_familia
						ORDER BY SUM(item_cantidad) DESC
						)

GROUP BY YEAR(F.fact_fecha),FAM.fami_id
ORDER BY SUM(IFACT.item_cantidad*IFACT.item_precio) DESC, 2

/*
SELECT fact_cliente, SUM(item_cantidad)
FROM Producto
	INNER JOIN Item_Factura
		ON item_producto = prod_codigo
	INNER JOIN Factura
		ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
WHERE prod_familia = '997' AND YEAR(fact_fecha) = 2010
GROUP BY fact_cliente
ORDER BY 2 DESC
*/
/*
SELECT prod_familia, YEAR(fact_fecha), SUM(item_cantidad)
						FROM Producto
							INNER JOIN Item_Factura
								ON item_producto = prod_codigo
							INNER JOIN Factura
								ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
						GROUP BY prod_familia,YEAR(fact_fecha)
						ORDER BY 2,SUM(item_cantidad) DESC

SELECT prod_rubro,YEAR(fact_fecha) 
FROM Producto
	INNER JOIN Item_Factura
		ON item_producto = prod_codigo
	INNER JOIN Factura
		ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo where prod_familia = '997'
GROUP BY prod_rubro,YEAR(fact_fecha) 
ORDER BY 2,1
*/
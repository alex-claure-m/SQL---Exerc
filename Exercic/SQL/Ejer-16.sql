USE[GD2015C1]
GO

/*
16)

Con el fin de lanzar una nueva campaña comercial para los clientes que menos compran 
en la empresa, se pide una consulta SQL que retorne aquellos clientes cuyas ventas son 
inferiores a 1/3 del promedio de ventas del producto que más se vendió en el 2012.
Además mostrar
1. Nombre del Cliente
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
3. Código de producto que mayor venta tuvo en el 2012 (en caso de existir más de 1, 
mostrar solamente el de menor código) para ese cliente.

Aclaraciones:
	*La composición es de 2 niveles, es decir, un producto compuesto solo se compone de 
	productos no compuestos.
	
*/

/* ******************************* VERSION MIA **************************************** */

SELECT c.clie_codigo as [codigo de cliente], c.clie_razon_social as [nombre del cliente]
	,ISNULL(SUM(ifac.item_cantidad),0) as [cantidad de unidades totales vendidas]
	,(SELECT TOP 1 p2.prod_codigo FROM  Producto p2 -- pide  el codigo del produto para LA mayor ventar del 2012
				INNER JOIN Item_Factura ifac2 ON p2.prod_codigo = ifac2.item_producto
				INNER JOIN Factura f2 ON ifac2.item_tipo= f2.fact_tipo AND f2.fact_sucursal = ifac2.item_sucursal AND f2.fact_numero = ifac2.item_numero
			WHERE year(f2.fact_fecha)=2012 and f2.fact_cliente = c.clie_codigo -- para que el producto cumpla que deba ser del cliente
			-- creo que la idea es obtener el producto ya que si tomo solo los productos que "se vendieron" no tomo en consideracion si es producto en si
			-- osae para que matchee mejor 
			-- por eso en el select top1 ifac2.etc etc ..va el producto en si y luego joineo con ifac2
			GROUP BY p2.prod_codigo
			ORDER BY SUM(ifac2.item_cantidad) DESC , p2.prod_codigo
	  ) AS [ PRODUCTO CON MAYOR VENTA EN 2012 PARA EL CLIENTE]
		FROM  Cliente c
	INNER JOIN Factura f ON f.fact_cliente = c.clie_codigo
	INNER JOIN Item_Factura ifac ON f.fact_numero = ifac.item_numero AND f.fact_sucursal = ifac.item_sucursal AND f.fact_tipo = ifac.item_tipo
	WHERE year(f.fact_fecha) = 2012
	GROUP BY c.clie_codigo,c.clie_razon_social
	HAVING SUM(ifac.item_cantidad) < (SELECT TOP 1 AVG(ifac.item_precio * ifac.item_cantidad) FROM Item_Factura ifac
	JOIN Factura f ON  ifac.item_numero = f.fact_numero AND ifac.item_tipo = f.fact_tipo AND f.fact_sucursal = ifac.item_sucursal) / 3

/* ********************************************** VERSION 2 ************************************ */
SELECT c.clie_codigo as [CODIGO CLIENTE], c.clie_razon_social as [NOMBRE DEL CLIENTE]
, COUNT (ifac.item_cantidad) as [CANTIDAD DE PRODUCTOS VENDIDOS]
, (SELECT TOP 1 ifac.item_producto FROM Item_Factura ifac 
	JOIN factura f ON ifac.item_sucursal = f.fact_sucursal AND ifac.item_tipo = f.fact_tipo AND ifac.item_numero = f.fact_numero
	WHERE c.clie_codigo = f.fact_cliente AND YEAR(f.fact_fecha) = '2012'
	GROUP BY ifac.item_producto
	ORDER BY  1 ASC
	) AS [PRODUCTO MAS VENDIDO EN EL 2012]
FROM Cliente c
JOIN Factura f ON f.fact_cliente = c.clie_codigo
JOIN Item_Factura ifac ON ifac.item_tipo = f.fact_tipo AND ifac.item_sucursal = f.fact_sucursal AND ifac.item_numero = f.fact_numero
WHERE YEAR(f.fact_fecha) = '2012' AND (f.fact_total) < (SELECT TOP 1 AVG(ifac.item_precio * ifac.item_cantidad) FROM Item_Factura ifac
	JOIN Factura f ON  ifac.item_numero = f.fact_numero AND ifac.item_tipo = f.fact_tipo AND f.fact_sucursal = ifac.item_sucursal)/ 3
GROUP BY c.clie_codigo , c.clie_razon_social
	

/* ********************************************* VERSION PROFESOR ********************************* */
SELECT c.clie_razon_social AS 'Nombre', ISNULL(SUM(i.item_cantidad),0) AS 'Cantidad de unidades vendidas',
ISNULL((SELECT TOP 1 p2.prod_codigo
FROM Producto p2 INNER JOIN Item_Factura i2 ON p2.prod_codigo=i2.item_producto
                INNER JOIN Factura f2 ON f2.fact_tipo=i2.item_tipo AND f2.fact_sucursal=i2.item_sucursal AND f2.fact_numero=i2.item_numero
WHERE YEAR(f2.fact_fecha)=2012 AND f2.fact_cliente=c.clie_codigo
GROUP BY f2.fact_cliente, p2.prod_codigo
ORDER BY SUM(i2.item_cantidad) desc, p2.prod_codigo asc),0) AS 'Producto mas vendido para ese cliente'


FROM Cliente c INNER JOIN Factura f ON c.clie_codigo=f.fact_cliente
               INNER JOIN Item_Factura i ON f.fact_tipo = i.item_tipo AND f.fact_sucursal=i.item_sucursal AND f.fact_numero=i.item_numero
WHERE YEAR(f.fact_fecha)=2012
GROUP BY c.clie_codigo, c.clie_razon_social, c.clie_domicilio

HAVING SUM(i.item_cantidad) <
 (SELECT TOP 1 AVG(i1.item_cantidad) /3 AS 'Promedio de Ventas'
FROM Producto p1 INNER JOIN Item_Factura i1 ON p1.prod_codigo=i1.item_producto
                 INNER JOIN Factura f1 ON f1.fact_tipo = i1.item_tipo 
				 AND f1.fact_sucursal=i1.item_sucursal AND f1.fact_numero=i1.item_numero
		WHERE YEAR(f1.fact_fecha)=2012
		GROUP BY p1.prod_codigo
		ORDER BY AVG(i1.item_cantidad) desc
)
ORDER BY c.clie_domicilio asc


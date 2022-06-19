USE [GD2015C1]
GO

/*
16
Con el fin de lanzar una nueva campaña comercial para los clientes que menos
compran en la empresa, se pide una consulta SQL que retorne aquellos clientes
cuyas ventas son inferiores a 1/3 del promedio de ventas del/los producto/s que más
se vendieron en el 2012.

Además mostrar

1. Nombre del Cliente 
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
3. Código de producto que mayor venta tuvo en el 2012 (en caso de existir más de 1,
mostrar solamente el de menor código) para ese cliente.

Aclaraciones:

La composición es de 2 niveles, es decir, un producto compuesto solo se compone
de productos no compuestos.
Los clientes deben ser ordenados por código de provincia ascendente. 
*/
-- ES RE COMPLEJO -- hasta ahora calcule para los del 2012

SELECT c.clie_codigo as [CODIGO CLIENTE], c.clie_razon_social as [NOMBRE DEL CLIENTE]
, COUNT (ifac.item_cantidad) as [CANTIDAD DE PRODUCTOS VENDIDOs]
, (SELECT TOP 1 ifac.item_producto FROM Item_Factura ifac 
	JOIN factura f ON ifac.item_sucursal = f.fact_sucursal AND ifac.item_tipo = f.fact_tipo AND ifac.item_numero = f.fact_numero
	WHERE c.clie_codigo = f.fact_cliente AND YEAR(f.fact_fecha) = '2012'
	GROUP BY ifac.item_producto
	ORDER BY  1 ASC
	) AS [PRODUCTO MAS VENDIDO EN EL 2012]
FROM Cliente c
JOIN Factura f ON f.fact_cliente = c.clie_codigo
JOIN Item_Factura ifac ON ifac.item_tipo = f.fact_tipo AND ifac.item_sucursal = f.fact_sucursal AND ifac.item_numero = f.fact_numero
WHERE YEAR(f.fact_fecha) = '2012'
GROUP BY c.clie_codigo , c.clie_razon_social

-- completando los requisitos
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
-- bueno, son 2 condiciones que la fecha sea del 2012 y que la factura total sea < al promedio (sobre 3) del producto que mas se vendio
-- en el año 2012
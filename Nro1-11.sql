USE [GD2015C1]
GO
/*
Mostrar el código, razón social de todos los clientes cuyo límite de crédito sea mayor o
igual a $ 1000 ordenado por código de cliente.
*/
SELECT c.clie_codigo, c.clie_razon_social FROM GD2015C1.dbo.Cliente c WHERE c.clie_limite_credito >= 1000
GROUP BY c.clie_codigo, c.clie_razon_social
ORDER BY c.clie_codigo

/*
Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por
cantidad vendida
*/
SELECT p.prod_codigo, p.prod_detalle FROM GD2015C1.dbo.Producto p 
	JOIN Item_Factura ifactura ON p.prod_codigo = ifactura.item_producto
	JOIN Factura f ON f.fact_sucursal = ifactura.item_sucursal -- NECESITO PARA FILTRAR LA FECHA
WHERE YEAR(f.fact_fecha) = '2012'	-- FILTRO POR FECHA - AÑO
GROUP BY p.prod_codigo, p.prod_detalle
	
select * from dbo.Factura
select * from dbo.Producto where prod_codigo = '00000109'
select * from dbo.Item_Factura where item_producto = '00000109'

/*
Realizar una consulta que muestre código de producto, nombre de producto y el stock
total, sin importar en que deposito se encuentre, los datos deben ser ordenados por
nombre del artículo de menor a mayor.
*/
SELECT p.prod_codigo, p.prod_detalle, sum (s.stoc_cantidad) cantidad from Producto p 
	JOIN STOCK s ON s.stoc_producto = p.prod_codigo
GROUP BY p.prod_codigo, p.prod_detalle
ORDER BY 2 ASC

/*
4
Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de
artículos que lo componen. Mostrar solo aquellos artículos para los cuales el stock
promedio por depósito sea mayor a 100.
*/
SELECT p.prod_codigo,p.prod_detalle, count (distinct c.comp_componente) FROM Producto p
	LEFT JOIN Composicion c ON p.prod_codigo = c.comp_producto
	JOIN STOCK s ON s.stoc_producto = p.prod_codigo
GROUP BY p.prod_codigo, p.prod_detalle
HAVING AVG(s.stoc_cantidad) > 100


select * from Composicion



/*
5
Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de
stock que se realizaron para ese artículo en el año 2012 (egresan los productos que
fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011.
*/

-- necesito primero ver que productos se vendieron y para eso esta el JOIN Item_factura y Producto
-- a su vez ITEM FACTURA DEBE JOINEAR con la factura que tendra la fecha
select p.prod_codigo, p.prod_detalle, sum (ifac.item_cantidad) cantidadComprada from Producto p
	JOIN Item_Factura ifac ON p.prod_codigo = ifac.item_producto -- ya que necesito saber cuantos se vendio y el item factura tiene esto
	JOIN Factura f ON f.fact_numero = ifac.item_numero and f.fact_tipo = ifac.item_tipo and f.fact_sucursal = ifac.item_sucursal
	-- tiene que joinear por que son PK de la tabla FACTURA y FK de la tabla item_factura
WHERE year(f.fact_fecha) = 2012
GROUP BY p.prod_codigo,p.prod_detalle
-- ahora, como sigue el chiste? aca digo los productos de 2012, PERO NECESITO COMPARAR CON EL 2011 en el sentido de: quien vendio mas?
HAVING SUM (ifac.item_cantidad) > 
	(SELECT SUM (ifac2.item_cantidad) from Item_Factura ifac2
		JOIN Factura f2 ON f2.fact_tipo = ifac2.item_tipo and f2.fact_numero = ifac2.item_numero and f2.fact_sucursal = ifac2.item_sucursal
	WHERE YEAR(f2.fact_fecha) = 2011 and ifac2.item_producto = p.prod_codigo
	)
ORDER BY p.prod_codigo

/*
6
Mostrar para todos los rubros de artículos código, detalle, cantidad de artículos de ese
rubro y stock total de ese rubro de artículos. Solo tener en cuenta aquellos artículos que
tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’.
*/

-- ===== esta mal por que es de rubro ===========
SELECT p.prod_codigo,p.prod_detalle, p.prod_rubro FROM Producto p 
	RIGHT JOIN STOCK s ON s.stoc_producto = p.prod_codigo
	JOIN Rubro r ON p.prod_detalle = r.rubr_detalle
-- =====================================

SELECT 
	rubr_detalle AS 'Rubro', 
	COUNT(DISTINCT prod_codigo) AS 'Articulos',
	SUM(stoc_cantidad) AS 'Stock total'
	FROM Rubro
	-- hasta aca lo que se hizo fue que necesito el detalle del rubro, CONTAR los articulos de ese rubro y EL STOCK TOTAL del rubro 
		JOIN Producto ON rubr_id = prod_rubro
		JOIN STOCK ON prod_codigo = stoc_producto
	-- joineo el rubro_id con el producto del rubro
	-- joineo el codigo del producto con el stock
WHERE (SELECT SUM(stoc_cantidad) FROM STOCK WHERE stoc_producto = prod_codigo) >
	(SELECT stoc_cantidad FROM STOCK WHERE stoc_producto = '00000000' AND stoc_deposito = '00')
GROUP BY rubr_id, rubr_detalle

/*
-- 7
Generar una consulta que muestre para cada artículo código, detalle, mayor precio
menor precio y % de la diferencia de precios (respecto del menor Ej.: menor precio =
10, mayor precio =12 => mostrar 20 %). Mostrar solo aquellos artículos que posean
stock.
*/
 -- ============== no se resuelve asi debido a que debo poner el mayor precio o menor precio segun el stock - MAL -
SELECT p.prod_codigo , p.prod_detalle , max(p.prod_precio) precioMayor, min(p.prod_precio) precioMenor FROM Producto p
	JOIN STOCK st ON st.stoc_producto = p.prod_codigo
WHERE st.stoc_cantidad > 0
GROUP BY p.prod_codigo,p.prod_detalle
 -- ========================================================
SELECT p.prod_codigo, p.prod_detalle, max(it.item_precio) precioMayor, min(it.item_precio) precioMenor,
		(MAX(it.item_precio) - MIN(it.item_precio)) / MIN(it.item_precio)  * 100 diferenciaPorcentual
		FROM Producto p 
	JOIN Item_Factura it ON it.item_producto = p.prod_codigo
	JOIN STOCK s on p.prod_codigo = s.stoc_producto
GROUP BY p.prod_codigo, p.prod_detalle
HAVING SUM (s.stoc_cantidad) > 0 -- aca le digo que la cantidad de stock debe ser positivo

/*
8
Mostrar para el o los artículos que tengan stock en todos los depósitos, nombre del
artículo, stock del depósito que más stock tiene.
*/
SELECT p.prod_codigo, p.prod_detalle, max (s.stoc_cantidad) cantidadProductos FROM Producto p
	JOIN STOCK s ON p.prod_codigo = s.stoc_producto
WHERE s.stoc_cantidad > 0
GROUP BY P.prod_codigo, P.prod_detalle
HAVING COUNT(DISTINCT stoc_deposito) = (SELECT COUNT(d.depo_codigo) FROM DEPOSITO d)


/*
9
Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del
mismo y la cantidad de depósitos que ambos tienen asignados.
*/
SELECT e.empl_jefe codigoJefe, e.empl_nombre , e.empl_codigo empleado,
	(SELECT COUNT(*) FROM DEPOSITO WHERE depo_encargado = e.empl_jefe) AS 'Depositos jefe', --  CUENTO LOS DEPOSITOS QUE TIENE EL JEFE
	(SELECT COUNT(*) FROM DEPOSITO WHERE depo_encargado = e.empl_codigo) AS 'Depositos empleado' -- CUENTO LOS DEPOSITOS QUE TIENE EL EMPLEAD
	FROM Empleado e


/*
10
Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos
vendidos en la historia. Además mostrar de esos productos, quien fue el cliente que
mayor compra realizo.
*/


-- VERSION 2
select * from 
( -- mostrame todos aquellos ...
SELECT top 10 prod_codigo, prod_detalle, sum(i.item_cantidad) as cantidad, fact_cliente  from Producto c join Item_Factura i
-- 10 primeros productos, detalles, cantidad, cliente que HA comprado 
		on c.prod_codigo =i.item_producto
		join Factura f
		on  i.item_sucursal = f.fact_sucursal and
			i.item_tipo= f.fact_tipo and
			i.item_numero= f.fact_numero
-- agrupalos por codigo producto, fecha, cliente
	group by prod_codigo, prod_detalle,fact_fecha,fact_cliente
-- ordenamelo por el año de forma descendente (osea de mayor a menor)
	order by YEAR(f.fact_fecha) desc
) t1
UNION 
select * from 
( -- mostrame los 10 primeros productos en los que un cliente ha comprado
SELECT top 10 prod_codigo, prod_detalle, sum(i.item_cantidad) as cantidad, fact_cliente  from Producto c join Item_Factura i
		on c.prod_codigo =i.item_producto
		join Factura f
		on  i.item_sucursal = f.fact_sucursal and
			i.item_tipo= f.fact_tipo and
			i.item_numero= f.fact_numero
-- agrupamelo por codigo, detalle , fecha, cliente
	group by prod_codigo, prod_detalle,fact_fecha,fact_cliente
-- ordenamelo por año de forma ascendente (de mayor a menor)
	order by YEAR(f.fact_fecha) asc
)t2

-- mi version para comprenderlo 
/*
10
Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos
vendidos en la historia. Además mostrar de esos productos, quien fue el cliente que
mayor compra realizo.
*/
SELECT p.prod_codigo, p.prod_detalle ,
	(SELECT TOP 1 f.fact_cliente FROM Factura f
		JOIN Item_Factura ifac ON f.fact_tipo = ifac.item_tipo AND f.fact_sucursal = ifac.item_sucursal AND f.fact_numero = ifac.item_numero
		WHERE p.prod_codigo = ifac.item_producto
		GROUP BY f.fact_cliente
		ORDER BY SUM(ifac.item_cantidad) DESC-- ordename por la suma de la cantidad de productos
-- le digo que me traiga al CLIENTE que COMPRO un PRODUCTO
	) AS cliente
FROM Producto p
	JOIN Item_Factura ifac ON ifac.item_producto = p.prod_codigo
-- DEL 1ER SELECT . donde producto debe matchear con el item_producto para traerme los datos precisos x eso el JOIN
WHERE  p.prod_codigo IN (SELECT TOP 10 item_producto FROM Item_Factura GROUP BY item_producto ORDER BY SUM(item_cantidad) DESC)
-- ACA AL WHERE LE DIGO QUE me traiga los 10 productos en los cuales la suma de su cantidad es de forma DESCENDIENTE
OR
	  p.prod_codigo IN (SELECT TOP 10 item_producto FROM Item_Factura GROUP BY item_producto ORDER BY SUM(item_cantidad) ASC)
GROUP BY p.prod_codigo, p.prod_detalle


/*
11
Realizar una consulta que retorne el detalle de la familia, la cantidad diferentes de
productos vendidos y el monto de dichas ventas sin impuestos. Los datos se deberán
ordenar de mayor a menor, por la familia que más productos diferentes vendidos tenga,
solo se deberán mostrar las familias que tengan una venta superior a 20000 pesos para
el año 2012.
*/

SELECT fa.fami_id idFmialia, fa.fami_detalle,COUNT (DISTINCT p.prod_codigo) cantidadDiferentesProductos, sum(ifac.item_precio * ifac.item_cantidad ) sumaTotal FROM Familia fa 
	JOIN Producto p ON p.prod_familia = fa.fami_id
	JOIN Item_Factura ifac ON p.prod_codigo = ifac.item_producto
	JOIN Factura f ON f.fact_tipo = ifac.item_tipo AND f.fact_sucursal = ifac.item_sucursal AND f.fact_numero = ifac.item_numero
WHERE year(f.fact_fecha) = '2012'
GROUP BY fa.fami_id, fa.fami_detalle
HAVING SUM (ifac.item_precio * ifac.item_cantidad ) > 20000
ORDER BY 2 DESC






SELECT * FROM Factura 


select * from STOCK





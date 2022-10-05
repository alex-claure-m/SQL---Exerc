USE [GD2015C1]
GO

/*
10
Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos 
vendidos en la historia. Además mostrar de esos productos, quien fue el cliente que 
mayor compra realizo.
*/

SELECT * FROM 
	(SELECT top 10 p.prod_codigo as [codigo producto]
	, p.prod_detalle as [detalle del producto], sum(ifac.item_cantidad) as [cantidad comprada]
	, f.fact_fecha as [fecha], f.fact_cliente as [cliente] FROM Producto p
	INNER JOIN Item_Factura ifac on ifac.item_producto = p.prod_codigo
	INNER JOIN factura f ON f.fact_sucursal = ifac.item_sucursal and f.fact_tipo = ifac.item_tipo and f.fact_numero = ifac.item_numero
	group by p.prod_codigo,p.prod_detalle, f.fact_fecha,f.fact_cliente
	order by YEAR(f.fact_fecha) desc
	) t2
-- vamos a comentar como esta hecho este codigo:
/*hay 2 formas de resolverlo, con UNION y con WHERE con OR - veremos primero UNION*/
/*lo que yo le digo aca es: seleccioname los primeros 10 en los cuales tenga :
   - producto codigo , codigo detalle y LA SUMATORIA DE CANTIDAD COMPRADA
   - que este ordenado por año de fecha Descendiente*/
--osea que estoy diciendole que me devuelva los 10 primeros de forma descendente(en año)
UNION 
select * from 
( -- mostrame los 10 primeros productos en los que un cliente ha comprado
SELECT top 10 p.prod_codigo as [codigo producto]
	, p.prod_detalle as [detalle producto]
	, sum(ifac.item_cantidad) as [cantidad comprada]
	, f.fact_cliente as [codigo de cliente] from Producto p 
	inner join Item_Factura ifac
		on p.prod_codigo =ifac.item_producto
	inner join Factura f
		on  ifac.item_sucursal = f.fact_sucursal and
			ifac.item_tipo= f.fact_tipo and
			ifac.item_numero= f.fact_numero
-- agrupamelo por codigo, detalle , fecha, cliente
	group by p.prod_codigo, p.prod_detalle,f.fact_fecha,f.fact_cliente
-- ordenamelo por año de forma ascendente (de mayor a menor)
	order by YEAR(f.fact_fecha) asc
)t3


/* ********************************** FORMA: WHERE - OR *************************************** */

SELECT p.prod_codigo, p.prod_detalle ,
-- y seleccioname AL CLIENTE que haya tenido la mayor compra (pero que no lo muestre)
	(SELECT TOP 1 f.fact_cliente FROM Factura f
		JOIN Item_Factura ifac ON f.fact_tipo = ifac.item_tipo AND f.fact_sucursal = ifac.item_sucursal AND f.fact_numero = ifac.item_numero
		WHERE p.prod_codigo = ifac.item_producto
		GROUP BY f.fact_cliente
		ORDER BY SUM(ifac.item_cantidad) DESC-- ordename por la suma de la cantidad de productos
-- le digo que me traiga AL CLIENTE que COMPRO un PRODUCTO DE MAYOR A MENOR (x eso el DESC)
	) AS cliente
FROM Producto p
	JOIN Item_Factura ifac ON ifac.item_producto = p.prod_codigo
-- DEL 1ER SELECT . donde producto debe matchear con el item_producto para traerme los datos precisos x eso el JOIN
WHERE  p.prod_codigo IN (SELECT TOP 10 item_producto FROM Item_Factura GROUP BY item_producto ORDER BY SUM(item_cantidad) DESC)
-- ACA AL WHERE LE DIGO QUE me traiga los 10 productos en los cuales la suma de su cantidad es de forma DESCENDIENTE
OR
	  p.prod_codigo IN (SELECT TOP 10 item_producto FROM Item_Factura GROUP BY item_producto ORDER BY SUM(item_cantidad) ASC)
GROUP BY p.prod_codigo, p.prod_detalle


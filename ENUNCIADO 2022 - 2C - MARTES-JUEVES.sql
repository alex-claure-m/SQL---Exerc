USE[GD2015C1]
go

/*
REALIZAR UNA CONSULTA SQL QUE PERMITA SABER SI UN CLIENTE COMPRO UN PRODUCTO EN TODOS LSO MESES DEL 2012

ADEMAS MOSTRAR PARA EL 2012
- EL CLIENTE
- LA RAZON SOCIAL DEL CLIENTE
- EL PRODUCTO COMPRADO
- EL NOMBRE DEL PRODUCTO
- CANTIDAD DE PRODUCTOS DISTINTOS COMPRADOS POR EL CLIENTE
- CANTIDAD DE PRODUCTOS CON COMPOSICION COMPRADOS POR EL CLIENTE

EL RESULTADO DEBERA SER ORDENADO PONIENDO PRIMERO AQUELLOS CLIENTES QUE COMPRARON MAS DE 10 PRODUCTOS DISTINTOS EN EL 2012
*/

SELECT 
	c.clie_codigo as [Cliente]
	, c.clie_razon_social as [Razon social]
	, p.prod_codigo as [producto comprado]
	, p.prod_detalle as [nombre del prodcuto]
	, (	SELECT (COUNT(distinct ifac1.item_producto)) FROM Item_Factura ifac1
		inner join Factura f1 ON f1.fact_numero+f1.fact_sucursal+f1.fact_tipo = ifac1.item_numero+ifac1.item_sucursal+ifac1.item_tipo
		WHERE YEAR(f1.fact_fecha) = '2012' AND f1.fact_cliente = c.clie_codigo) as [cantidad de productos distintos]
	-- TIENE SENTIDO QUE VAYA POR IFAC1.ITEM_PRODUCTO, debido a que son PRODUCTOS QUE SE COMPRO, no tiene sentido ponerle a esa instancia
	-- P1.producto_codigo , por que ese producto no es sabemos si fue comprado
	, (SELECT COUNT(ifac2.item_producto) FROM Item_Factura ifac2
		JOIN Factura f2 ON ifac2.item_numero+ifac2.item_sucursal+ifac2.item_tipo = f2.fact_numero+f2.fact_sucursal+f2.fact_tipo
		WHERE YEAR(f2.fact_fecha) = '2012' AND f2.fact_cliente = c.clie_codigo
		AND EXISTS(SELECT 1 FROM Composicion com WHERE com.comp_producto = ifac2.item_producto)) as [cantidad productos con composicion que compro]
	FROM Cliente c
	INNER JOIN Factura f ON f.fact_cliente = c.clie_codigo
	INNER JOIN Item_Factura ifac ON ifac.item_numero+ifac.item_sucursal+ifac.item_tipo = f.fact_numero+f.fact_sucursal+f.fact_tipo
	INNER JOIN Producto p ON ifac.item_producto = p.prod_codigo
	WHERE YEAR(f.fact_fecha) = '2012'
	group by c.clie_codigo, c.clie_razon_social, p.prod_codigo, p.prod_detalle
	-- NECESITO AHORA QUE SE ANALIZE POR LOS 12 MESES 
	-- luego de haber OBTENIDO QUIEN COMPRO EN 2012 digo:
	-- AHORA FILTRAME DE NUEVO PARA 
	-- PARA TODOS AQUELLOS QUE COMPRARON EN 2012 => TIENE QUE HABERSE COMPRADO ( O QUE HAYA DATOS) en todos los 12 meses
	-- ORDENAMELOS DE MAYOR A MENOR, SEGUN QUIEN HAYA COMPRADO MAS EN ESE AÑO
	having
	count( distinct month(fact_fecha)) = 12   --Cuento que la cantidad de meses en los que compro el producto sean igual a 12
	order by  --Al ordenar por el calculo de productos distintos en forma descentente, indefectiblemente quedaran primeros los clientes que compraron màs de 10 productos distintos en el 2012
		(select count(distinct item_producto) 
				from Item_Factura
				join factura on fact_numero = item_numero and fact_sucursal = item_sucursal and fact_tipo = item_tipo
				where year(fact_fecha) = '2012' and fact_cliente = c.clie_codigo) desc


/*2*/

/*
IMPLEMENTAR UNA REGLA DE NEGOCIO DE VALIDACION EN LINEA QUE PERMITA IMPLEMENTAR UNA LOGICA DE CONTROL
DE PRECIOS EN VENTAS. SE DEBERA PODER SELECCIONAR UNA LISTA DE RUBROS Y AQUELLOS PRODUCTOS DE LOS RUBROS QUE SEAN
SELECCIONADOS NO PODRAN AUMENTAR POR MES MAS DE 2%. EN CASO DE QUE NO SE TENGA REFERENCIA DEL MES ANTERIOR NO VALIDAR DICHA REGLA
*/




USE[GD2015C1]
GO

/*
REALIZAR UNA CONSULTA SQL QUE PERMITA SABER LOS CLIENTES QUE COMPRARON TODOS LOS RUBROS DISPONILBES DEL SISTEMA EN EL 2012

DE LOS CLIENTES, MOSTRAR PARA EL 2012
- CODIGO DEL CLIENTE
- CODIGO DEL PRODUCTO QUE EN CANTIDADES MAS COMPRO
- EL NOMBRE DEL PRODUCTO DEL PUNTO 3
- CANTIDAD DE PRODUCTOS DISTINTOS COMPRADOS POR EL CLIENTE
- CANTIDAD DE PRODUCTOS CON COMPOSICION COMPRADOS X EL CLIENTE

EL RESULTADO DBERA SER ORDENADO POR RAZON SOCIAL DEL CLIENTE ALFABETICAMENTE PRIMERO Y LUEGO, LOS CLIENTES QUE COMPRARON
ENTRE UN 20% Y 30% DEL TOTAL FACTURADO EN 2012 PRIMERO, LUEGO, LOS RESTANTES..

*/

SELECT c.clie_codigo as [codigo del cliente] 
	, (SELECT TOP 1 (ifac1.item_producto) FROM Item_Factura ifac1
		INNER JOIN Factura f1 ON ifac1.item_numero+ifac1.item_sucursal+ifac1.item_tipo = f1.fact_numero+f1.fact_sucursal+f1.fact_tipo
		WHERE YEAR(F1.fact_fecha) = '2012' AND f1.fact_cliente = c.clie_codigo) as [CODIGO PRODUCTO DONDE MAS COMPRO]
	, --p.prod_detalle as [NOMBRE del producto]
		(SELECT TOP 1 (p1.prod_detalle) FROM Producto p1
			INNER JOIN Item_Factura ifac4 ON ifac4.item_producto = p1.prod_codigo
			INNER JOIN Factura f4 ON ifac4.item_numero+ifac4.item_sucursal+ifac4.item_tipo = f4.fact_numero+f4.fact_sucursal+f4.fact_tipo
			WHERE YEAR(f4.fact_fecha) = '2012' AND f4.fact_cliente = c.clie_codigo) as [NOMBRE DEL PRODUCTO]
			-- si no tuviese que insertarle la fecha del 2012, el JOIN de factura no iba
	, (SELECT COUNT(DISTINCT ifac2.item_producto) FROM Item_Factura ifac2
		INNER JOIN Factura f2 ON f2.fact_numero+f2.fact_sucursal+f2.fact_tipo = ifac2.item_numero+ifac2.item_sucursal+ifac2.item_tipo
		WHERE f2.fact_cliente = c.clie_codigo AND YEAR(f2.fact_fecha) = '2012')
	, (SELECT COUNT(ifac3.item_producto) FROM Item_Factura ifac3
		INNER JOIN Factura f3 ON ifac3.item_numero+ifac3.item_sucursal+ifac3.item_tipo = f3.fact_numero+f3.fact_sucursal+f3.fact_tipo
		WHERE ifac3.item_producto IN (select c.comp_producto from Composicion c) AND f3.fact_cliente = c.clie_codigo)
	FROM Cliente c
	INNER JOIN Factura f ON f.fact_cliente = c.clie_codigo
	INNER JOIN Item_Factura ifac ON ifac.item_numero+ifac.item_sucursal+ifac.item_tipo = f.fact_numero+f.fact_sucursal+f.fact_tipo
	INNER JOIN Producto p ON ifac.item_producto = p.prod_codigo
	WHERE YEAR(f.fact_fecha) = '2012'
	GROUP BY c.clie_codigo
	HAVING COUNT(DISTINCT prod_rubro) = (SELECT COUNT(*) FROM Rubro)




/*
2)
IMPLEMENTAR UNA REGLA DE NEGOCIO EN LINEA QUE PERMITA REALIZAR UNA VENTA (SOLO INSERCION) PERMITA COMPONER
LOS PRODUCTOS DESCOMPUESTOS, ES DECIR, SES GUARDAN EN LA FACTURA 2 HAMBURGUESA, 2 PAPAS, 2 GASEOSAS. SE DEBERA GUARDAR
EN LA FACTURA 2 (DOS) COMBO1. SI 1 COMBO1 equivale a: 1 hamb, 1 papa y 1 gaseosa
*/
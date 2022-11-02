USE [GD2015C1]
GO

/*
Escriba una consulta que retorne para todos los productos las siguientes columnas:
-Codigo de producto
-Detalle del producto
-Compuesto (Deberia mostrar S o N segun corresponda)
-Promedio historico de precios al que fue vendido (si nunca se vendio el promedio debe mostrarse como 0)
-Cantidad maxima que se vendio en un mes

El resultado debe ser ordenado por detalle de la familia del producto ascendente

*/

SELECT p.prod_codigo as [codigo de producto]
	, p.prod_detalle as [detalle del producto]
	, (CASE WHEN c.comp_producto is not null THEN 's' ELSE 'n' end) as [es compuesto?]
	, (SELECT ISNULL(AVG(ifac.item_precio),0) FROM Item_Factura ifac 
		WHERE ifac.item_producto = p.prod_codigo) as [promedio historico de precio en el que fue vendido ]
	, (SELECT TOP 1 sum(ifac1.item_cantidad) FROM Item_Factura ifac1
		INNER JOIN Factura f2 ON f2.fact_tipo+f2.fact_sucursal+f2.fact_numero =ifac1.item_tipo+ifac1.item_sucursal+ifac1.item_numero
		WHERE p.prod_codigo = ifac1.item_producto
		--INNER JOIN Producto p1 ON p1.prod_codigo = ifac1.item_producto
		--GROUP BY YEAR(f2.fact_fecha), MONTH(f2.fact_fecha)
		) as  [cantidad maxima en un mes]
	 FROM Producto p
	 INNER JOIN Composicion c ON c.comp_producto = p.prod_codigo
	 INNER JOIN Familia f ON f.fami_id = p.prod_familia
	 GROUP BY  P.prod_codigo,p.prod_detalle,f.fami_detalle,c.comp_producto
	 ORDER BY f.fami_detalle ASC 

-- EL LEFT JOIN IN COMPOSISION en vez de INNER





/*
2.
Cree el/los objetos de bases de datos necesarios para que automaticamente se cumpla la siguiente regla de negocio
"El encargado de un deposito debe pertenecer a un departamento cuya zona coincida con la zona del deposito que tiene a cargo"
A partir de la aplicacion de la creacion de stos objetos (los datos que ya existen que no la cumplen deben continuar como estan).
En la actualidad la regla NO se cumple. No se conoce la forma de acceso a los datos ni el procedimiento por el cual se emiten las mismas.
*/

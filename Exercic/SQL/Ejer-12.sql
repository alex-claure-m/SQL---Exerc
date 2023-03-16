USE[GD2015C1]
GO

/*
12)
Mostrar nombre de producto, cantidad de clientes distintos que lo compraron importe 
promedio pagado por el producto, cantidad de depósitos en los cuales hay stock del 
producto y stock actual del producto en todos los depósitos. Se deberán mostrar 
aquellos productos que hayan tenido operaciones en el año 2012 y los datos deberán 
ordenarse de mayor a menor por monto vendido del producto.
*/

SELECT p.prod_codigo as [codigo producto],p.prod_detalle as [detalle del producto]
	, COUNT(DISTINCT c.clie_codigo) as [codigo de cliente]
	, AVG(ifac.item_precio)  as [promedio del producto pagado]
	-- aclara que debo saber el promedio del producto pagado
	-- me hace referencia a que ya se compro, entonces debo consultarlo x la entidad item_factura
	-- o a lo sumo por la entidad factura
	, (SELECT COUNT(DISTINCT s.stoc_deposito) FROM STOCK s 
		-- debido a que hay mas de un valor en el deposito, el subselect no funcionara 
		-- entonces pensa.. necesito los depositos distintos en los cuales habra stock 
			WHERE s.stoc_producto = p.prod_codigo AND ISNULL(s.stoc_cantidad,0)>0
			) as [stock del producto en deposito]
		-- consulto de que exista deposito que contenga al producto (x ende tambien debe ser >0 )
	, (SELECT SUM(s.stoc_cantidad) FROM STOCK s WHERE p.prod_codigo = s.stoc_producto) 
		-- ademas en el subselect me pide que deba saber el stock actual del producto, para eso sumo
		-- la cantidad para los cuales el PRODUCTO_CODIGO sea = a STOC_producto
	FROM  Producto p
	inner join Item_Factura ifac on ifac.item_producto = p.prod_codigo
	INNER JOIN Factura f ON f.fact_sucursal = ifac.item_sucursal AND f.fact_tipo = ifac.item_tipo AND ifac.item_numero = f.fact_numero
	INNER JOIN Cliente c ON f.fact_cliente = c.clie_codigo
	WHERE year(f.fact_fecha) = '2012'
	GROUP BY p.prod_codigo, p.prod_detalle
	ORDER BY 2 DESC


select factura.fact_cliente from  Factura


SELECT item_precio FROM Item_Factura

select prod_precio FROM Producto

SELECT stoc_producto FROM STOCK

select prod_codigo FROM  Producto
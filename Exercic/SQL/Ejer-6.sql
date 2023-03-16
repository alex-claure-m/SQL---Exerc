USE [GD2015C1]
GO

/*
6)
Mostrar para todos los rubros de artículos código, detalle, cantidad de artículos de ese 
rubro y stock total de ese rubro de artículos. Solo tener en cuenta aquellos artículos que 
tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’.
*/

SELECT p.prod_codigo as [Codigo Articulo], r.rubr_detalle as [Detalle],
	COUNT (DISTINCT p.prod_codigo) as [cantidad de arituclos],
	SUM(s.stoc_cantidad) as [Stock Total] FROM Rubro r
		 JOIN Producto p ON r.rubr_id = p.prod_rubro
		 JOIN STOCK s ON s.stoc_producto = p.prod_codigo
		 -- este select es para decir : ey de toda la suma de la cantidad de stock debe ser MAYOR
		 -- al del articulo 00000000 DEL DEPOSITO 00
	WHERE (SELECT SUM(stoc_cantidad) FROM STOCK WHERE stoc_producto = prod_codigo) >
		(SELECT stoc_cantidad FROM STOCK  WHERE stoc_producto = '00000000' AND stoc_deposito = '00')
GROUP BY p.prod_codigo, r.rubr_detalle


USE [GD2015C1]
GO

/*
6)
Mostrar para todos los rubros de art�culos c�digo, detalle, cantidad de art�culos de ese 
rubro y stock total de ese rubro de art�culos. Solo tener en cuenta aquellos art�culos que 
tengan un stock mayor al del art�culo �00000000� en el dep�sito �00�.
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


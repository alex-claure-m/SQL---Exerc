USE [GD2015C1]
GO

/*
8)
Mostrar para el o los artículos que tengan stock en todos los depósitos, nombre del
artículo, stock del depósito que más stock tiene.
*/

select p.prod_detalle as [Detalle], MAX(s.stoc_cantidad) as [Cantidad Productos]  FROM Producto p
	INNER JOIN STOCK s ON p.prod_codigo = s.stoc_producto
WHERE s.stoc_cantidad > 0 
GROUP BY p.prod_detalle
HAVING COUNT(DISTINCT stoc_deposito) = (SELECT COUNT(d.depo_codigo) FROM DEPOSITO d)
/*ESTA BIEN QUE NO DEVUELVA NADA*/


/* este no lo capto cuando dice que tengo que buscar el/los articulos de deposito que + STOCK tiene*/

-- HECHO POR EL PROFE
select p.prod_codigo, p.prod_detalle, max(s.stoc_cantidad) fromproducto p inner join stock s on p.prod_codigo = s.stoc_producto where s.stoc_cantidad > 0group by p.prod_codigo, p.prod_detalle  having count(*) = (select count(distinct s2.stoc_deposito) from stock s2)

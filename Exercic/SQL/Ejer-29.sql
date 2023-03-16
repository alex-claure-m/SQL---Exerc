USE [GD2015C1]
GO
/*
Se solicita que realice una estad�stica de venta por producto para el a�o 2011, solo para los productos
que pertenezcan a las familias que tengan m�s de 20 productos asignados a ellas, la cual deber� devolver las siguientes columnas:
a. C�digo de producto
b. Descripci�n del producto
c. Cantidad vendida
d. Cantidad de facturas en la que esta ese producto
e. Monto total facturado de ese producto
Solo se deber� mostrar un producto por fila en funci�n a los considerandos establecidos antes.
			SELECT count( distinct p1.prod_familia )
			FROM Producto p1
			INNER JOIN Familia fam1 ON fami_id = prod_familia	
			WHERE fam1.fami_id = fam.fami_id

			GROUP BY fam1.fami_id
			) > 20
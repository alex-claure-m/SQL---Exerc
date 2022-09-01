USE [GD2015C1]
GO

/*
-1)
Mostrar el código, razón social de todos los clientes cuyo límite de crédito sea mayor o 
igual a $ 1000 ordenado por código de cliente
*/

SELECT c.clie_codigo as [Codigo de cliente], c.clie_razon_social as [Razon Social] FROM Cliente c
	WHERE c.clie_limite_credito > 1000
	ORDER BY 1 ASC
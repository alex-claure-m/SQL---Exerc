USE [GD2015C1]
GO

/*
ENUNCIADO 2022-1C - 12-07-22

ARMAR UNA CONSULTA SQL QUE MUESTRE AQUEL/AQUELLOS clientes que en 2 años consecutivos(de existir),
fueron los mejores compradores, es decir, los que en un monto total facturado anual fue el maximo


*/
-- DEBO CONSULTAR AQUELLOS CLIENTES EN LOS CUALES FUERON 2 VECES CONSECUTIVAMENTE MEJOR COMPRADOR
SELECT c.clie_codigo as [codigo cliente]
	,c.clie_razon_social as [ razon social cliente]
	 FROM Cliente c
	 INNER JOIN Factura f ON c.clie_codigo = f.fact_cliente
	 GROUP BY c.clie_codigo, c.clie_razon_social, YEAR(F.fact_fecha)
	 HAVING c.clie_codigo = ( SELECT TOP 1 f1.fact_cliente FROM Factura f1
								WHERE YEAR(f.fact_fecha) = YEAR(f1.fact_fecha)
								GROUP BY f1.fact_cliente
								ORDER BY SUM(f1.fact_total) DESC -- EL TOP DEL CLIENTE CON MAYOR FACTURA
								)
			AND	c.clie_codigo =  (
								SELECT TOP 1 f3.fact_cliente
								FROM Factura f3
								WHERE YEAR(f3.fact_fecha) = YEAR(f.fact_fecha) + 1
								GROUP BY f3.fact_cliente
								ORDER BY SUM(f3.fact_total) DESC
							-- Y QUE ADEMAS SEA 2 VECES CONSECUTIVAMENTE EL MEJOR !
							)
-- recorda que el HAVING SE APLICA LUEGO DE QUE SE HAYA ARMADO LA CONSULTA 




/*

TSQL

AGREGAR EL/LOS OBJETOS NECESARIOS PARA QUE SI UN CLIENTE COMPRA UN PRODUCTO COMPUESTO A UN PRECIO MENOR QUE LA SUMA
DE LOS PRECIOS DE SUS COMPONENTES SE REGISTRE LA FECHA, QUE CLIENTE , QUE PRODUCTOS Y A QUE PRECIO SE REALIZO LA COMPRA
NO SE DEBERA PERMITIR QUE DICHO PRECIO SEA MENOR A LA MITAD DE LA SUMA DE LOS COMPONENTES 
*/


CREATE TRIGGER dbo.registroCompra 
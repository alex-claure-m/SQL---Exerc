-- Ejercicio 18 resolucion con 2 triggers
-- trigger sobre tabla clientes insert update controlando limite de credito contra facturacion mensual
-- trigger sobre la tabla facturas, si clientes es no null, ver que el total de facturacion del mes no supere limite de credito actual


CREATE TRIGGER tr_ejercicio18_clientes
ON Cliente
AFTER INSERT, UPDATE
AS
BEGIN 

IF EXISTS ( SELECT 1
			FROM Inserted c INNER JOIN
			Factura f ON c.clie_codigo = f.fact_cliente 
			WHERE YEAR(f.fact_fecha) = YEAR(GETDATE()) AND MONTH(f.fact_fecha) = MONTH(GETDATE())
			GROUP BY c.clie_codigo, c.clie_limite_credito 
			HAVING c.clie_limite_credito < SUM(fact_total))
			BEGIN
				ROLLBACK TRANSACTION
				RETURN
			END

END

CREATE TRIGGER tr_ejercicio18_facturas
ON Factura
AFTER INSERT, UPDATE
AS
BEGIN 

IF EXISTS ( SELECT 1
			FROM Cliente c INNER JOIN
			Factura f ON c.clie_codigo = f.fact_cliente 
			WHERE YEAR(f.fact_fecha) = YEAR(GETDATE()) AND MONTH(f.fact_fecha) = MONTH(GETDATE())
			AND f.fact_cliente IN (select fact_cliente FROM inserted)
			GROUP BY c.clie_codigo, c.clie_limite_credito 
			HAVING c.clie_limite_credito < SUM(fact_total))
			BEGIN
				ROLLBACK TRANSACTION
				RETURN
			END

END

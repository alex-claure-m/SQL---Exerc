USE[GD2015C1]
GO

/*
18)

Sabiendo que el limite de credito de un cliente es el monto maximo que se le puede facturar mensualmente, 
cree el/los objetos de base de datos necesarios para que dicha regla de negocio se cumpla automaticamente.
 No se conoce la forma de acceso a los datos ni el procedimiento por el cual se emiten las facturas


limite_credito = monto maximo QUE PUEDE FACTURAR mensualmente un cliente
-- este limite lo tiene la BASE CLIENTE

-- crear una regla de negocio para que se cumpla automaticamente



*/
-- trigger sobre tabla clientes insert update controlando limite de credito contra facturacion mensual
CREATE TRIGGER stsql_ejercicio18 ON Factura FOR INSERT
AS
BEGIN
-- es mas que nada consulta existencial de ver si existe algun cliente que "INSERTE" y ver que el limite de credito
-- no haya superado a lo facturado mensualmente
-- y como NO PIDE ANALIZAR TODO LOS MESES DEL AÑO
-- pide que se analize mensualmente -> acorde a los meses que estemos pasando y se ejecute el programa
-- por eso en el WHERE YEAR ()= YEAR(GETDATE) y MONTH() = MONTH(GETDATE)
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

-- trigger sobre la tabla facturas, si clientes es no null, ver que el total de facturacion del mes no supere limite de credito actual

-- aca lo que tambien hago es CONTROLAR el tema de la factura pero matcheando con el cliente!
CREATE TRIGGER tr_ejercicio18_facturas
ON Factura
AFTER INSERT, UPDATE
AS
BEGIN 

IF EXISTS ( SELECT 1
			FROM Cliente c INNER JOIN
			Factura f ON c.clie_codigo = f.fact_cliente 
			WHERE YEAR(f.fact_fecha) = YEAR(GETDATE()) AND MONTH(f.fact_fecha) = MONTH(GETDATE())
			AND f.fact_cliente IN (select fact_cliente FROM inserted) -- analizo si la fact_cliente esta en el inserted de arriba
			GROUP BY c.clie_codigo, c.clie_limite_credito  
			HAVING c.clie_limite_credito < SUM(fact_total)) 
			BEGIN
				ROLLBACK TRANSACTION
				RETURN
			END

END

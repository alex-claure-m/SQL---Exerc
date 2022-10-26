USE[GD2015C1]
GO

/*
4)
Cree el/los objetos de base de datos necesarios para actualizar la columna de empleado empl_comision con la
 sumatoria del total de lo vendido por ese empleado a lo largo del último año. Se deberá retornar el código del vendedor 
 que más vendió (en monto) a lo largo del último año.


-- debemos actualizar empl_comision
	con que se lo debe actualziar?
		con la sumatoria total de lo vendido por ese empleado durante el ultimo año}
-- debe retornar el codigo del vendedor que mas se vendio (como en monto??)
*/

IF OBJECT_ID (N'dbo.ejer4_tsql', N'FN') IS NOT NULL 
    DROP PROCEDURE dbo.ejer4_tsql;  
GO

CREATE PROCEDURE ejer4_tsql(@codigoEmpleadoConMasVentas NUMERIC(6,0) OUT)
AS
BEGIN -- ACA DEBO ACTUALIZAR LA COMISION DEL EMPLEADO QUE SERA LA SUMATORIA DE LO QUE VENDIO DURANTE EL ULTIMO AÑO
-- DURANTE EL ULTIMO AÑO, ESTA ES UNA FORMA DE CALCULARLO! DECIRLE al primer subselect : WHERE f-fact_fecha = TOP fecha f1 DESC
	UPDATE Empleado SET empl_comision = (SELECT SUM(f.fact_total) FROM Factura f
											WHERE YEAR(f.fact_fecha) = (SELECT TOP 1 year(f1.fact_fecha) FROM Factura f1
																		ORDER BY YEAR(f1.fact_fecha) DESC )
												AND empl_codigo = f.fact_vendedor
										) -- ademas debo aclararle que estemos hablando de que el vendedor sea el empleado

-- luego debo pasarle al @codigoEmpleadoConMasVentas , cual es el empleado , que sera el que updatee
	set @codigoEmpleadoConMasVentas = (SELECT TOP 1 empl_codigo
										 FROM Empleado
										 ORDER BY empl_comision DESC)
RETURN
END

-- COMO FUNCIONA EL STORE PROCEDURE!!!!

DECLARE @vendedor_que_mas_vendio numeric(6,0)
EXEC ejer4_tsql @codigoEmpleadoConMasVentas = @vendedor_que_mas_vendio OUT
SELECT @vendedor_que_mas_vendio AS [Vendedor que mas vendio]
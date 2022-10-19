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

IF OBJECT_ID (N'dbo.ej4_tsql', N'FN') IS NOT NULL 
    DROP PROCEDURE dbo.ej4_tsql;  
GO

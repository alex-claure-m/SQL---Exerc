USE[GD2015C1]
GO

/*
4)
Cree el/los objetos de base de datos necesarios para actualizar la columna de empleado empl_comision con la
 sumatoria del total de lo vendido por ese empleado a lo largo del �ltimo a�o. Se deber� retornar el c�digo del vendedor 
 que m�s vendi� (en monto) a lo largo del �ltimo a�o.


-- debemos actualizar empl_comision
	con que se lo debe actualziar?
		con la sumatoria total de lo vendido por ese empleado durante el ultimo a�o}
-- debe retornar el codigo del vendedor que mas se vendio (como en monto??)
*/

IF OBJECT_ID (N'dbo.ej4_tsql', N'FN') IS NOT NULL 
    DROP PROCEDURE dbo.ej4_tsql;  
GO

USE [GD2015C1]
GO
/*
9)
Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del
mismo y la cantidad de depósitos que ambos tienen asignados.
*/

SELECT e.empl_jefe as [JEFE], e.empl_nombre, e.empl_codigo,
	(SELECT COUNT(*) FROM DEPOSITO WHERE depo_encargado = e.empl_jefe) AS 'Depositos jefe', --  CUENTO LOS DEPOSITOS QUE TIENE EL JEFE
	(SELECT COUNT(*) FROM DEPOSITO WHERE depo_encargado = e.empl_codigo) AS 'Depositos empleado' -- CUENTO LOS DEPOSITOS QUE TIENE EL EMPLEAD
FROM Empleado e


-- SEGUN EL PROFE

select j.empl_codigo as codigojefe, e.empl_codigo as codigoempleado, e.empl_apellido as nombreempleado,(select count(*) from DEPOSITO d where d.depo_encargado = e.empl_codigo or d.depo_encargado = j.empl_codigo) as depositos from Empleado e inner join Empleado j on e.empl_jefe = j.empl_codigo

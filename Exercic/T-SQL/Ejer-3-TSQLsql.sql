USE [GD2015C1]
GO

/*
3)
Cree el/los objetos de base de datos necesarios para corregir la tabla empleado en caso que sea necesario.
 Se sabe que debería existir un único gerente general (debería ser el único empleado sin jefe).
 Si detecta que hay más de un empleado sin jefe deberá elegir entre ellos el gerente general, el cual será seleccionado por 
 mayor salario. Si hay más de uno se seleccionara el de mayor antigüedad en la empresa. 
Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla de un único empleado sin jefe (el gerente general)
y deberá retornar la cantidad de empleados que había sin jefe antes de la ejecución
*/

/*
debo crear un OBJETO para corregir algo de la tabla --> esto a priori sabremos que no sera una funcion que calcula algo
y a todo lo que no sea una funcion para hacer alguna resolucion aritmetica o que retorne algo puntual
SERA POR PROCEDURE!

- debe existir un UNICO GERENTE GENERAL Y QUE SEA ESTE UN EMPLEADO .. que no tenga JEFE
- si hay mas de un empleado SIN jefe 
	- se elegira el que tiene mayor salario
		- y si hay mas de uno que tiene el mismo salario
			- se seleccionara el de mayor antiguedad
- 
*/

IF OBJECT_ID (N'dbo.ej3_tsql', N'FN') IS NOT NULL 
    DROP PROCEDURE dbo.ej3_tsql;  
GO

/*
IN : A variable passed in this mode is of read only nature. This is to say, the value cannot be changed 
and its scope is restricted within the procedure. The procedure receives a value from this argument when 
the procedure is called.

OUT : In this mode, a variable is write only and can be passed back to the calling program.
 It cannot be read inside the procedure and needs to be assigned a value.
*/

CREATE PROCEDURE ejer3_TSQL (@cantidadEmpleados INTEGER OUT) -- OUT por que sera una variable que se rescribira
AS
BEGIN
	DECLARE @gerenteGeneral NUMERIC(6) -- es el codigo de empleado
	SET @gerenteGeneral = (SELECT TOP 1 e.empl_salario FROM Empleado e
							WHERE e.empl_jefe IS NULL -- NO DEBE TENER JEFE
							ORDER BY e.empl_salario DESC , e.empl_ingreso ASC -- filtro, ademas, por mayor antiguedad 
							)
	SET @cantidadEmpleados =( SELECT COUNT(*)
								FROM Empleado
								WHERE empl_jefe IS NULL )
	
	PRINT @cantidadEmpleados
END
GO

-- MIRAR OCMO SE EJECUTA UN STORE PROCEDURE

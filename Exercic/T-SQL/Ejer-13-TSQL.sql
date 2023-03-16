USE [GD2015C1]
GO

/*
13)

Cree el/los objetos de base de datos necesarios para implantar la siguiente regla
“Ningún jefe puede tener un salario mayor al 20% de las suma de los salarios de 
sus empleados totales (directos + indirectos)”. Se sabe que en la actualidad dicha 
regla se cumple y que la base de datos es accedida por n aplicaciones de 
diferentes tipos y tecnologías


crear los objetos NECESARIOS para IMPLANTAR ESTA REGLA:
	- "Ningún jefe puede tener un salario mayor al 20% de las suma de los salarios de sus empleados totales (directos + indirectos)
		- entonces que hacer?
			- actualizar el sueldo de los jefes y si supera el 20% debido a la suma de los salarios de sus empleados
				-- que salte el cartel!!
*/

-- ideal crear una funcion para obtener la suma de los salarios de los empleados
IF OBJECT_ID('FX_SALARIO_EMPLEADOS') IS NOT NULL
	DROP FUNCTION FX_SALARIO_EMPLEADOS
GO

-- DECLARO LA FUNCION
CREATE FUNCTION FX_SALARIO_EMPLEADOS(@EMPLEADO NUMERIC(6,0))
RETURNS DECIMAL(12,2)
AS
BEGIN
	DECLARE @SALARIO_EMPLEADOS DECIMAL(12,2) -- DECLARO UN ATRIBUTO DE SALARIO_DE_EMPLEADO
	
	SET @SALARIO_EMPLEADOS = 
	ISNULL((SELECT SUM(DBO.FX_SALARIO_EMPLEADOS(empl_codigo) + empl_salario) -- hago RECURSIVA LA FUNCION, para que me sume los salarios
	FROM Empleado
	WHERE empl_jefe = @EMPLEADO), 0) -- en donde el codigo del jefe sea del empleado que apse por parametro
	
	RETURN @SALARIO_EMPLEADOS -- me retorna el salario sumado!
END
GO


-- TODO ESTO SERIA LA FUNCION

-- AHORA EL TRIGGER PARA MODIFICAR/ ACTUALIZAR LAS TABLAS

IF OBJECT_ID('TR_CONTROLAR_SALARIO') IS NOT NULL
	DROP TRIGGER TR_CONTROLAR_SALARIO
GO

CREATE TRIGGER TR_CONTROLAR_SALARIO
ON Empleado
INSTEAD OF UPDATE --en lugar de UPDATEAR --
AS
BEGIN
	IF UPDATE(empl_salario) -- SI EL SALARIO FUE ACTUAZLIADO!!!
	BEGIN					
	-- DECLARO un EMPLEADO (CODIGO), EL SALARIO DE ESE EMPLEADO Y EL NUEVO SALARIO
		DECLARE @EMPLEADO NUMERIC(6,0) 
		DECLARE @SALARIO_EMPLEADO DECIMAL(12,2)
		DECLARE @NUEVO_SALARIO_EMPLEADO DECIMAL(12,2)

		DECLARE C_EMPLEADO CURSOR FOR  -- DECLARO EL CURSOR DONDE AL ACTUALZIARLO, SE LE DEBERA BORRAR DATOS ANTERIORES
		SELECT d.empl_codigo, d.empl_salario, i.empl_salario 
		FROM deleted d
		JOIN inserted i ON d.empl_codigo = i.empl_codigo -- JOINEO CON EL EMPLEADO
		
		OPEN C_EMPLEADO -- inicializo cursor
		
		FETCH NEXT FROM C_EMPLEADO INTO @EMPLEADO, @SALARIO_EMPLEADO, @NUEVO_SALARIO_EMPLEADO -- puntero al proximo Cursor (c_empleado)
		
		WHILE @@FETCH_STATUS = 0 -- mientras que el status de FETCH sea = 0 (que haya valores en el cursor)...
		BEGIN
			IF @NUEVO_SALARIO_EMPLEADO <= DBO.FX_SALARIO_EMPLEADOS(@EMPLEADO) * 0.2 OR 
	-- comparo si el nuevo salario del empelado es < a la funcion que calcula la sumatoria del salario (de esto , obtengo el 20%)
	-- o si no , que 
			(SELECT COUNT(*) FROM Empleado WHERE empl_jefe = @EMPLEADO) = 0
			BEGIN
				UPDATE Empleado -- actualizame la TABLA EMPLEADO
				SET empl_salario = @NUEVO_SALARIO_EMPLEADO -- donde el salario es = @nuevo_salario obtenido de la funcion 
				WHERE empl_codigo = @EMPLEADO 
			END
			ELSE
			BEGIN
				DECLARE @MENSAJE VARCHAR(10) = (SELECT CAST(@EMPLEADO AS VARCHAR(10)))
				RAISERROR('EL EMPLEADO %s NO PUEDE TENER UN SALARIO TAN ELEVADO RESPECTO DE SUS EMPLEADOS', 16, 1, @MENSAJE)
			END
		FETCH NEXT FROM C_EMPLEADO INTO @EMPLEADO, @SALARIO_EMPLEADO, @NUEVO_SALARIO_EMPLEADO
		END

		CLOSE C_EMPLEADO
		DEALLOCATE C_EMPLEADO
	END
END
GO 







/*ACLARACION: Solo contemple para el caso de UPDATES en la columna emp_salario por lo
tanto el trigger no tiene en cuenta si se modifica el jefe de un empleado y quizas
eso puede provocar que ese jefe este ganando mas del 20 % del total de los salarios de
sus empleados.
*/



--PRUEBA

-- Los unicos empleados que son jefes son el 1, 2 y el 3 y a la vez el 1 es jefe de 2 y 3
-- por lo tanto los empleados 2 y 3 no tienen empleados directos asi que me fijo cuanto
-- da la suma de los salarios de todos los empleados del 3 para probar la funcion

SELECT SUM(empl_salario) 
FROM Empleado
WHERE empl_jefe = 3

-- Como todos los empleados del 3 no tiene otros empleados la funcion deberia devolver 
-- 43700 que era la suma de los salarios de todos los empleados de 3

SELECT DBO.FX_SALARIO_EMPLEADOS(3)

-- Hago lo mismo para el empleado 2

SELECT SUM(empl_salario) 
FROM Empleado
WHERE empl_jefe = 1

-- Como todos los empleados del 2 no tiene otros empleados la funcion deberia devolver 
-- 3500 que era la suma de los salarios de todos los empleados de 2

SELECT DBO.FX_SALARIO_EMPLEADOS(2)

-- Por ultimo pruebo la funcion para el empleado 1 la cual deberia devolver la suma
-- de los salarios de los empleados 2 y 3 (da 25000) y a la vez la suma de los 
-- salarios de los empleados de estos dos ultimos por lo tanto la funcion deberia 
-- devolver 72200 (25000 + 43700 + 3500)

SELECT DBO.FX_SALARIO_EMPLEADOS(1)

-- Primero me fijo el salario de un empleado por ejemplo el del 3 y veo que cumple con la
-- condicion ya que 10000 es menor al 20% de 43700

SELECT * FROM Empleado
WHERE empl_codigo = 3

-- Para probar el trigger actualizo el salario del empleado 3 en uno que sea menor a
-- al 20% de la suma de los salarios de sus empleados (43700.00), es decir deberia
-- ser menor a 8740 (0.2 * 43700) y el trigger deberia dejarme hacer el cambio

UPDATE Empleado
SET empl_salario = 8740
WHERE empl_codigo = 3

-- Me fijo que se haya actualizado

SELECT * FROM Empleado
WHERE empl_codigo = 3

-- Ahora pruebo con una mayor a 8740 y el trigger no me deberia dejar

UPDATE Empleado
SET empl_salario = 8741
WHERE empl_codigo = 3

-- Me fijo que se haya actualizado

SELECT * FROM Empleado
WHERE empl_codigo = 3

-- Ahora pruebo con un empleado que no tenga empleados y el trigger me deberia dejar

UPDATE Empleado
SET empl_salario = 999999
WHERE empl_codigo = 6

-- Me fijo que se haya actualizado

SELECT * FROM Empleado
WHERE empl_codigo = 6

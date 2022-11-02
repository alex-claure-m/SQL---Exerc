USE[GD2015C1]
GO



 -- =========== mirar con atencion este punto!!!!!!!!!!!!!!!!! ========================



/*
11)

Cree el/los objetos de base de datos necesarios para que dado un código de empleado se retorne la cantidad de empleados
 que este tiene a su cargo (directa o indirectamente). Solo contar aquellos empleados (directos o indirectos) que 
 tengan un código mayor que su jefe directo.

tengo que crear un objeto OBJETC_ID donde dado un CODIGO DE EMPLEADO
	retorne CANTIDAD DE EMPLEADOS QUE TIENE A US CARGO
		sin tener en cuenta aquellos empleados que tenga CODIGO > A SU JEFE
*/


IF OBJECT_ID('FX_CANTIDAD_EMPLEADOS') IS NOT NULL
	DROP FUNCTION FX_CANTIDAD_EMPLEADOS
GO

CREATE FUNCTION FX_CANTIDAD_EMPLEADOS(@empleado NUMERIC(6,0))
	RETURNS INT
AS
BEGIN
	DECLARE @cantidad_empleados INT
	DECLARE @fecha_nacimiento_jefe smalldatetime

	SET @fecha_nacimiento_jefe = (SELECT E.empl_nacimiento FROM Empleado E WHERE @empleado = E.empl_nacimiento)

	SET @cantidad_empleados = (SELECT ISNULL(SUM(DBO.FX_CANTIDAD_EMPLEADOS(empl_codigo) + 1), 0) FROM Empleado
				WHERE empl_jefe = @empleado AND empl_nacimiento > @fecha_nacimiento_jefe)
	RETURN @cantidad_empleados
END
GO




-- =============== HECHO X EL PROFE ===================

CREATE PROCEDURE pr_ejercicio11Tsql(@codigo NUMERIC(6,0)) AS 
BEGIN


-- crear 1 tablas temporal con los empleados a su cargo
-- while mientras tenga datos de empleados a agregar
-- inserto en la tabla validando no duplicar
-- Finaliza el while
-- retorno un count de la tabla temporal

CREATE TABLE #empleadosCargo
	(codigo NUMERIC(6,0))

	DECLARE @nuevos INT

	INSERT INTO #empleadosCargo (codigo)
	SELECT empl_codigo FROM 
	Empleado E WHERE empl_jefe = @codigo

	SELECT @nuevos = COUNT(*) FROM #empleadosCargo

	WHILE @nuevos > 0
	BEGIN 

		INSERT INTO #empleadosCargo (codigo)
		SELECT empl_codigo FROM 
		Empleado E WHERE empl_jefe IN (SELECT codigo FROM #empleadosCargo)
		AND NOT EXISTS (SELECT 1 FROM #empleadosCargo T1 WHERE T1.codigo = E.empl_codigo)

		SET @nuevos = @@rowcount

	END

	SELECT @nuevos = COUNT(*) FROM #empleadosCargo

	Print @nuevos

END
















--PRUEBA

-- Hago un lista para ver los empleados directos y veo que los unicos empleados 
-- que son jefes son el empleado 1, 2 y 3. Primero voy a probar la funcion para
-- el empleado 1

SELECT empl_jefe, COUNT(*) AS 'Empleados directos'
FROM Empleado
WHERE empl_jefe IS NOT NULL
GROUP BY empl_jefe

-- Me fijo quienes son empleados directos del empleado 1 y a su vez son menores a el

SELECT * 
FROM Empleado
WHERE empl_jefe = 1
AND empl_nacimiento > '1978-01-01'

-- La consulta me devuelve que el unico que cumple con ambas condiciones es el 2
-- por lo tanto ahora veo los empleados directos y menores del 2 y los empleados 
--que me devuelva los voy a tener que sumar con los de la consulta anterior

SELECT * 
FROM Empleado
WHERE empl_jefe = 2
AND empl_nacimiento > '1979-01-05'

-- La consulta devolvio un solo empleado que es el 6. Por lo tanto hasta ahora el empleado 1
-- tiene un empleado directo que es el 2 y un indirecto que es el 6, ahora veo lo mismo para
-- el empleado 6

SELECT * 
FROM Empleado
WHERE empl_jefe = 6
AND empl_nacimiento > '1990-01-14'

-- Como no hay empleados que sean menores y directos del 6 entonces la funcion debera
-- devolver para el empleado 1 un valor igual a 2 que serian el empleado 2 (directo) y el
-- empleado 6 (indirecto del 1 y directo del 2). 

SELECT DBO.FX_CANTIDAD_EMPLEADOS(1)

-- Siguiendo esa logica para el empleado 2 la funcion deberia devolver uno que seria
-- solo el empleado directo 6

SELECT DBO.FX_CANTIDAD_EMPLEADOS(2)

-- Finalmente para el empleado 6 deberia devolver 0 ya que no tiene empleados

SELECT DBO.FX_CANTIDAD_EMPLEADOS(6)
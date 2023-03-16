USE[GD2015C1]
GO

/*
19)

Cree el/los objetos de base de datos necesarios para que se cumpla la siguiente regla de negocio automáticamente 
“Ningún jefe puede tener menos de 5 años de antigüedad y tampoco puede tener más del 50% del personal a su cargo 
(contando directos e indirectos) a excepción del gerente general”.
 Se sabe que en la actualidad la regla se cumple y existe un único gerente general.

 * NINGUN JEFE PUEDE TENER MENOS DE 5 AÑOS DE ANTIGUEDAD
 * tampoco puede tener + del 50% del persona a su cargo

UN TRIGGER? => DEBERE CONTROLAR QUE LOS JEFES NO DEBAN TENER < 5 AÑOS DE ANTIGUEDAD


*/












/*********************** FUNCION EMPLEADOS A CARGO ***********************/
IF EXISTS (SELECT name FROM sysobjects WHERE name='empleados_a_cargo' and type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
	DROP FUNCTION empleados_a_cargo
GO
CREATE FUNCTION empleados_a_cargo
(@jefe NUMERIC(6))
RETURNS INT
AS
BEGIN
	RETURN (SELECT ISNULL(SUM(dbo.empleados_a_cargo(empl_codigo) + 1), 0)
			FROM Empleado WHERE empl_jefe = @jefe)
END
GO

/*********************** FUNCION JEFE MAYOR ***********************/
IF EXISTS (SELECT name FROM sysobjects WHERE name='jefe_mayor' and type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
DROP FUNCTION jefe_mayor
GO
CREATE FUNCTION jefe_mayor
(@empleado NUMERIC(6))
RETURNS NUMERIC(6)
AS
BEGIN	
	RETURN (SELECT (CASE WHEN empl_jefe IS NULL THEN @empleado ELSE dbo.jefe_mayor(empl_jefe) END)
			FROM Empleado WHERE empl_codigo = @empleado)
END
GO

/******************** TRIGGER ******************************************/
IF EXISTS(SELECT name FROM sysobjects WHERE name='ej19')
DROP TRIGGER ej19
GO
CREATE TRIGGER ej19 ON Empleado FOR UPDATE, INSERT
AS
BEGIN
	IF (SELECT MAX(dbo.empleados_a_cargo(empl_codigo)) FROM inserted WHERE empl_jefe IS NOT NULL) > (SELECT COUNT(*) FROM Empleado)/2
	BEGIN
		RAISERROR('NO PUEDE HABER UN JEFE CON MAS DEL 50% DE LOS EMPLEADOS A CARGO',1,1)
		ROLLBACK TRANSACTION		
	END
	IF EXISTS (SELECT * FROM inserted WHERE year(empl_ingreso)+5 > year(getdate()) AND empl_codigo IN (SELECT empl_jefe FROM Empleado))
	BEGIN
		RAISERROR('NO PUEDE HABER UN JEFE CON MENOS DE 5 AÑOS DE ANTIGÜEDAD',1,1)
		ROLLBACK TRANSACTION		
	END
END
GO












CREATE TRIGGER dbo.ejercicio19 ON Empleado FOR INSERT,UPDATE
AS
BEGIN
	DECLARE @emplCod numeric (6,0),@emplJefe numeric (6,0)
	DECLARE cursor_inserted CURSOR FOR SELECT empl_codigo,empl_jefe
										FROM inserted
	OPEN cursor_inserted
	FETCH NEXT FROM cursor_inserted
	INTO @emplCod,@emplJefe
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF dbo.calculoDeAntiguedad(@emplCod) < 5
		BEGIN
			PRINT 'El empleado no puede tener menos de 5 años de antiguedad'
			ROLLBACK
		END

		ELSE IF dbo.cantidadDeSubordinados(@emplCod) > (
															SELECT COUNT(*)*0.5
															FROM Empleado
															)
				AND @emplJefe <> NULL
		BEGIN
			PRINT 'El empleado no puede tener mas del 50% del personal a su cargo'
			ROLLBACK
		END
	FETCH NEXT FROM cursor_inserted
	INTO @emplCod,@emplJefe
	END
	CLOSE cursor_inserted
	DEALLOCATE cursor_inserted
END
GO


ALTER FUNCTION dbo.calculoDeAntiguedad (@empleado numeric(6,0))
RETURNS int
AS
BEGIN
	DECLARE @todaysDate smalldatetime = GETDATE()
	DECLARE @antiguedad int = 0
	SET @antiguedad = DATEDIFF(year,(SELECT empl_ingreso
										FROM Empleado
										WHERE @empleado = empl_codigo
										),@todaysDate
								)
	RETURN @antiguedad
END
GO

CREATE FUNCTION dbo.cantidadDeSubordinados (@Jefe numeric(6,0))
RETURNS int

AS
BEGIN
	DECLARE @CantEmplACargo int = 0
	DECLARE @JefeAux numeric(6,0) = @Jefe
	DECLARE @CodEmplAux numeric(6,0)
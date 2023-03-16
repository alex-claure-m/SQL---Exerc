USE[GD2015C1]
GO

/*
20)
Crear el/los objeto/s necesarios para mantener actualizadas las comisiones del vendedor.
El cálculo de la comisión está dado por el 5% de la venta total efectuada por ese vendedor en ese mes,
más un 3% adicional en caso de que ese vendedor haya vendido por lo menos 50 productos distintos en el mes


- necesito matener actualizadas las comisiones del vendedor - TABLA EMPLEADOS
-- la comision esta dada por 
	- 5% de la venta TOTAL efectuada en el MES
	- +3% adicional en el caso si vendio 50 productos distitnso en ese mes
*/

CREATE TRIGGER stsql_ejercicio20 ON Factura -- por que factura?
for insert -- ES LO MISMO QUE AFTER INSERT
as 
begin
--
	DECLARE @comision DECIMAL(12,2)
	DECLARE @vendedor NUMERIC(6,0)
	DECLARE @fecha SMALLDATETIME

	DECLARE cursor_comision CURSOR FOR SELECT fact_fecha, fact_vendedor FROM inserted 

	OPEN cursor_comision
	FETCH NEXT FROM cursor_comision INTO @vendedor, @fecha -- el cursor debe apuntar al siguiente vendedor y fecha
	WHILE @@FETCH_STATUS = 0
	BEGIN
	SET @comision = (SELECT SUM(ifac.item_precio * ifac.item_cantidad) * (0.05 +
																			CASE WHEN COUNT(DISTINCT ifac.item_producto) > 50 THEN 0.03
																			ELSE 0
																			END
																			)
						 FROM Factura f 
						 INNER JOIN Item_Factura ifac ON f.fact_numero+f.fact_sucursal+f.fact_tipo = ifac.item_numero+ifac.item_sucursal+ifac.item_tipo
						 WHERE f.fact_vendedor = @vendedor AND YEAR(f.fact_fecha) = YEAR(@fecha) AND MONTH(f.fact_fecha) = MONTH(@fecha)
						 )
	UPDATE Empleado  SET empl_comision = @comision
	FETCH NEXT FROM cursor_comision INTO @vendedor,@fecha 
	END
	CLOSE cursor_comision
	DEALLOCATE cursor_comision
END
GO
USE[GD2015C1]
GO


/*
ENUNCIADO 2017

REALIZAR UNA CONSULTA SQL QUE RETORNE, PARA CADA PRODUCTO CON MAS DE 2 ARTICULOS DISTINTOS EN SU COMPOSICION LA SIGUIENTE INFORMACION

- DETALLE DEL PRODUCTIO
- RUBRO DEL PRODUCTO
- CANTIDAD DE VECES QUE FUE VENDIDO

EL RESULTADO SE DEBERA MOSTRAR ORDENADO POR LA CANTIDAD DE PRODUCTOS QUE LA COMPONEN
*/

SELECT p.prod_detalle as [detalle del producto]
	, r.rubr_detalle  [rubro del producto]
	, (SELECT COUNT(*) FROM Item_Factura ifac WHERE P.prod_codigo = IFAC.item_producto
		) AS [CANTIDAD DE VECES VENDIDA]
	 FROM Producto p
	 INNER JOIN Rubro r ON p.prod_rubro = r.rubr_id
	 WHERE p.prod_codigo IN  (select c.comp_producto from composicion c group by c.comp_producto having count(comp_componente) > 2) 
	 -- este es el chicle nuevo, en el cual el codigo del producto tiene que etar en la compisicion y que este compuesto x mas de 2 componentes
	 order by (select sum(comp_cantidad) from composicion where comp_producto = p.prod_codigo) desc
/*
2)
AGREGAR EL/LOS OBJETOS NECESARIOS PARA QUE SE PERMITA MANTENER LA SIGUIENTE RESTRICCION
- NUNCA UN JEFE VA A PODER TENER MAS DE 20 PERSONAS A CARGO Y MENOS DE 1 (PERSONA A CARGO?)
NOTA: CONSIDERAR SOLO 1 NIVEL DE LA RELACION EMPLEADO-JEFE
*/

/*
INSERTED ==>

La tabla insertada almacena copias de las filas nuevas o modificadas después de una instrucción INSERT o UPDATE.
Durante la ejecución de una declaración INSERT o UPDATE, las filas nuevas o modificadas en la tabla de activación
se copian en la tabla insertada. 
Las filas de la tabla insertada son copias de las filas nuevas o actualizadas de la tabla desencadenante.
*/


/*
DELETED ==>

La tabla eliminada almacena copias de las filas afectadas en la tabla de activación antes de que fueran modificadas
por una instrucción DELETE o UPDATE (la tabla de activación es la tabla en la que se ejecuta el activador DML).
Durante la ejecución de una declaración DELETE o UPDATE, las filas afectadas primero se copian de la tabla de activación
y se transfieren a la tabla eliminada.

*/

CREATE TRIGGER tr_empleados ON Empleado   -- por que EMPLEADO? por que aca contempla el de JEFE
AFTER INSERT, UPDATE, DELETE 
-- ES INSTEAD OF O AFTER? => COMO VOY A MODIFICAR(SI O SI) Y/O CARGAR( PARA FUTUROS INSERTS) ENTONCES ES INSERT UPDATE
AS 
	BEGIN TRANSACTION
		IF((SELECT COUNT(*) FROM inserted)>0)
			BEGIN
				IF(EXISTS(SELECT 1 FROM inserted WHERE (dbo.FN_CALCULAR_CANT_EMPLEADOS(empl_jefe)<1))
					BEGIN	
						RAISERROR('UN JEFE NO PUEDE TENER MENOS DE UN EMPLEADO A CARGO',16,1)
						ROLLBACK
						RETURN
					END
				IF(EXISTS(SELECT 1 FROM inserted WHERE dbo.FN_CALCULAR_CANT_EMPLEADOS(empl_jefe) > 20)
					BEGIN
						RAISERROR('UN JEFE NO PUEDE TENER UMAS DE 20 PERSONAS A CARGO',16,1)
						ROLLBACK
						RETURN
					END
			END
			-- ELSE- CUANDO ELIMINO A UN EMPLEADO
			-- BEGIN  ---> IRIA LO MISMO QUE IF EXISTS SELECT ..ETC ETC
		COMMIT TRANSACTION
	GO
		




create function FN_CALCULAR_CANT_EMPLEADOS (@empleado numeric(6,0))
returns int
as
	begin
		declare @cantidad int
		declare @emp_jefe numeric(6,0)
		declare @emp_codigo numeric(6,0)
				
		set @cantidad = 0;
				
		if NOT EXISTS(SELECT * FROM Empleado WHERE @empleado = empl_jefe)
		begin
			RETURN @cantidad
		end;		
				
		set @cantidad = (select count(*) from empleado where empl_jefe=@empleado and empl_codigo>@empleado)
		
		declare cEmp cursor for
		select empl_jefe, empl_codigo
		from Empleado 
		where empl_jefe = @empleado
		
		open cEmp
		fetch next from cEmp into @emp_jefe, @emp_codigo
		while @@FETCH_STATUS = 0
			begin
				set @cantidad = @cantidad + dbo.FN_CALCULAR_CANT_EMPLEADOS(@emp_codigo)
				fetch next from cEmp into @emp_jefe, @emp_codigo
			end
		close cEmp;
		deallocate cEmp;	
		return @cantidad;	
	end;
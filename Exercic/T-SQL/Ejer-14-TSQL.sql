USE[GD2015C1]
GO

/*
14)

Agregar el/los objetos necesarios para que si un cliente compra un producto 
compuesto a un precio menor que la suma de los precios de sus componentes 
que imprima la fecha, que cliente, que productos y a qué precio se realizó la 
compra. No se deberá permitir que dicho precio sea menor a la mitad de la suma 
de los componentes.


SI UN CLIENTE compra un PRODUCTO COMPUESTO .. a un precio < a la suma de los precios de SUS COMPONENTES
=> imprimir LA FECHA, EL CLIENTE, PRODUCTOS y el PRECIO
	* el precio NO debe ser la 1/2 de LA SUMA de SUS COMPONENTES
*/

IF OBJECT_ID (N'dbo.ej14', N'FN') IS NOT NULL  -- creo el objeto llamado DBO.EJE14
    DROP TRIGGER dbo.ej14;  
GO
CREATE TRIGGER dbo.ej14 ON item_factura INSTEAD OF INSERT -- en este caso no aclara que deba modificar algo, si no mas bien
-- de poder crear una tabla en el cual en el que SE INSERTARA DATOS 
AS
BEGIN
	DECLARE @tipo CHAR(1), -- para matchear con factura
			@sucursal CHAR(4), -- idem, para matchear con factura
			@numero CHAR(8), -- idem x3
			@prod CHAR(8), --parte del problema
			@precio DECIMAL (12,2), -- parte del problema
			@cliente NUMERIC(6), -- parte del problema
			@fecha SMALLDATETIME -- parte del problema
	DECLARE cur CURSOR FOR -- declaro cursor 
		SELECT item_tipo, item_sucursal, item_numero, item_producto, item_precio -- donde seleccionare de la tabla item_factura
		FROM inserted -- UNA VEZ LUEGO DE SER INSERTADO
	OPEN cur -- inicializo CURSOR
	FETCH NEXT FROM cur INTO @tipo, @sucursal, @numero, @prod, @precio -- PUNTERO AL SIGUIENTE CURSOR
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @precio > dbo.precioCompuesto(@prod)/2 -- FUUUUCK, NO TENGO ESA FUNCION A MANO
		BEGIN
			INSERT INTO Item_Factura
				SELECT *
				FROM inserted
				WHERE item_producto = @prod
			IF @precio <= dbo.precioCompuesto(@prod)
			BEGIN
				SELECT @cliente = fact_cliente, @fecha = fact_fecha
				FROM Factura
				WHERE fact_tipo + fact_sucursal + fact_numero = @tipo + @sucursal + @numero
				PRINT @fecha--, @cliente, @prod, @precio
			END
		END
		FETCH NEXT FROM cur INTO @tipo, @sucursal, @numero, @prod, @precio
	END
	CLOSE cur
	DEALLOCATE cur
END
GO
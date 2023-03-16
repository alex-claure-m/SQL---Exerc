USE[GD2015C1]
GO

/*
17)
Sabiendo que el punto de reposicion del stock es la menor cantidad de ese objeto que se debe almacenar en el deposito 
y que el stock maximo es la maxima cantidad de ese producto en ese deposito, cree el/los objetos de base de datos 
necesarios para que dicha regla de negocio se cumpla automaticamente. 
No se conoce la forma de acceso a los datos ni el procedimiento por el cual se incrementa o descuenta stock


reposicion de stock = menor cantidad del producto que se debe almacenar en el deposito
stock maximo = catnidad maxima del producto en ESE deposito

-- crear objeto para la regla de negocio se haga automaticamente ==> TRIGGER UPDATE INSERT


*/

CREATE TRIGGER stsql_ejercicio17 ON stock
AFTER INSERT, UPDATE
AS
BEGIN
	-- a ver por lo que entiendo es que debo modificar el stock, tanto la cantidad maxima, como minima de PRODUCTOS
	-- cambiar el tema de PUNTO_REPOSICION
	-- entonces
	DECLARE @cantidadMaxima DECIMAL(12,2)
	DECLARE @cantidadMinima DECIMAL(12,2)
	-- DECLARE @punto_reposicion DECIMAL(12,2) este no va debido a que representa la cantidad MINIMA, que esta delcarado arriba
	DECLARE @producto CHAR(8)
	DECLARE @deposito CHAR(8) -- este tiene sentido? ver mas abajo en la solucion
	DECLARE @cantidad DECIMAL(12,2)

	DECLARE cursor_stock_reposicion CURSOR FOR SELECT stoc_cantidad,stoc_punto_reposicion,stoc_stock_maximo,stoc_producto,stoc_deposito
		FROM inserted  -- declaro el cursor para aquellos elementos que seran modificados , acorde a lo que figura la tabla maestra
		-- y acorde a los variables declaradas
	OPEN cursor_stock_resposicion
	FETCH NEXT FROM cursor_stock_reposicion
	INTO @cantidad,@cantidadMinima,@cantidadMaxima,@producto,@deposito -- este into es acorde a como esta la tabla dbo.STOCK
	WHILE @@FETCH_STATUS = 0
		BEGIN
		-- si la cantidad que existe del producot, suepra a la cantidadMaxima soportada 
		IF @cantidad > @cantidadMaxima
			BEGIN
				PRINT 'Se está excediendo la cantidad maxima del producto ' + @producto + ' en el deposito ' + @deposito + ' por ' + STR(@cantidad - @cantidadMaxima) + ' unidades. No se puede realizar la operacion'
				ROLLBACK
			END
		-- si la cantidad que existe actualmente del producto es < a la cantidad minima que deberia tener 
		ELSE IF @cantidad < @cantidadMinima
			BEGIN
				PRINT 'El producto ' + @producto + ' en el deposito ' + @deposito + ' se encuentra por debajo del minimo. Reponer!'
			END
		FETCH NEXT FROM cursor_stock_reposicion -- vuelvo a poner el cursor a leer 
		INTO @cantidad,@cantidadMinima,@cantidadMaxima,@producto,@deposito
		END
	CLOSE cursor_stock_reposicion
	DEALLOCATE cursor_stock_reposicion -- elimino memoria 
	END
GO

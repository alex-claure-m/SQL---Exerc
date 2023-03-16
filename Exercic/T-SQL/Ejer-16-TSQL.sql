USE[GD2015C1]
GO

/*
16)
Desarrolle el/los elementos de base de datos necesarios para que ante una venta automaticamante se descuenten del stock 
los articulos vendidos. Se descontaran del deposito que mas producto poseea y se supone que el stock se almacena 
tanto de productos simples como compuestos (si se acaba el stock de los compuestos no se arman combos)
En caso que no alcance el stock de un deposito se descontara del siguiente y asi hasta agotar los depositos posibles.
En ultima instancia se dejara stock negativo en el ultimo deposito que se desconto

- ante UNA VENTA => automaticamente se descuente el STOCK los articulos que fueron vendidos
	--> se descontara del DEPOSITO que mas producto tenga 
		-- es como decir: COMPRE chicle -> entonces reviso en DONDE tiene mas cantidad de ese PRODUCTO . lo SELECCIONO y lo actualizo
		-- TENER EN CUENTA EL TEMA DE LOS COMPUESTOS DE LPS PRODUCTOS

TIENE MAS PINTA TRIGGER ESTE
*/

CREATE TRIGGER sqlt_ejercicio16 ON item_factura 
AFTER INSERT, UPDATE -- cuando va a ejecutarse esto? => despes e cada venta ==> AFTER
AS
BEGIN
	DECLARE @cantidad decimal(12,2) -- bueno, necesito claramente la cantidad, por que? => por que esta sera modificada
	DECLARE @producto char(8) -- producto, por que necesitare expecificar de que producto estamos hablando para la modificacion
	DECLARE @totalStock int -- para hacer el calculo del stock una vez que compraron el producto
	DECLARE @remanente int -- la cantidad de productos que hay de stock en un momento dado
	DECLARE @deposito char(2) -- para situarnos en donde esta guardado el producto

	-- necesito declara un cursor para que recorra toda la tabla ITEM_FACTURA e IMTE_PRODUCTO
	DECLARE cursor_modificacion CURSOR FOR

	-- PARA CADA MOMENTO QUE HAGA UN INSERTED, entonces aplicara el cursor
	SELECT item_cantidad, item_producto from inserted

	IF EXISTS (SELECT 1 from inserted i where not exists (select 1 from stock WHERE stoc_producto = i.item_producto))
	-- estoy diciendo SI existe UN insertado DONDE no pertenezca a un SELECT que stock_producto = i.item_producto(que recien "inserto")
	BEGIN
		ROLLBACK TRANSACTION
		RETURN
	END
OPEN c_ejercicio16 -- INICIALIZO EL CURSOR
	FETCH NEXT FROM c_ejercicio16 INTO @cantidad, @producto -- MIENTRAS HAYA DATOS 
	WHILE (@@FETCH_STATUS = 0) -- y mientras el stado sea = 0 
	BEGIN -- EMPEZAR

		SET @remanente = @cantidad -- inicializo que el remanente sea igual a la cantidad de productos que hay en este momento
		
		SELECT TOP 1 @totalStock = ISNULL(stoc_cantidad,0), @deposito = stoc_deposito  
		-- SELECCIONAME AL MEJOR TOATL STOCK donde le asignare el stock_cantidad. si no tiene le asigno 0
		-- y ademas a la variable deposito le asigno el stoc_deposito
		FROM stock where stoc_producto = @producto -- de la tabla Stock , donde el stoc_producto sea = a la variable producto que insertare
		ORDER BY ISNULL(stoc_cantidad,0) DESC -- ordenado por cantidad de stoc de forma mayor a menor

		WHILE @remanente > 0 -- mientras que remanete (que en un principio es = a cantidad) sea > 0
		BEGIN

			IF (@totalStock > 0 AND @totalStock > @remanente ) OR (@totalStock <= 0)
			-- si el totaStock es > 0 y es >  a la remanente (cantidad de productos) O es es <0 , debido a que no hay mas en ese deposito
			BEGIN
				UPDATE stock SET stoc_cantidad = ISNULL(stoc_cantidad,0) - @remanente
				WHERE stoc_deposito = @deposito AND stoc_producto = @producto
				-- ACTUALIZAME TABLA set STOC_CANTIDAD = STOC_CANTIDAD - cantidad existente en el momento
				-- DONDE stoc_deposito = deposito de Variable y que estemos hablando del producto en especifico
				SET @remanente = 0 --
			END
ELSE -- DEBE DESCONTAR DE OTRO DEPOSITO 
				IF @totalStock < @remanente
				BEGIN
				
					UPDATE stock SET stoc_cantidad = 0 
					WHERE stoc_deposito = @deposito AND stoc_producto = @producto

					SET @remanente = @remanente - @totalStock
				END

			SELECT TOP 1 @totalStock = ISNULL(stoc_cantidad,0), @deposito = stoc_deposito  
			FROM stock where stoc_producto = @producto
			ORDER BY ISNULL(stoc_cantidad,0) DESC
		
		END

		FETCH NEXT FROM c_ejercicio16 INTO @cantidad, @producto
	END
	CLOSE c_ejercicio16
	DEALLOCATE c_ejercicio16

END
GO

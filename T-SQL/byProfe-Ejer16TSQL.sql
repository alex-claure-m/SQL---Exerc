CREATE TRIGGER tr_ejercicio16ON item_facturaAFTER INSERTAS BEGIN	DECLARE @cantidad decimal(12,2)	DECLARE @producto char(8)	DECLARE @totalStock int	DECLARE @remanente int	DECLARE @deposito char(2)	DECLARE c_ejercicio16 CURSOR FOR	SELECT item_cantidad, item_producto from inserted    IF EXISTS (SELECT 1 from inserted i where not exists (select 1 from stock WHERE stoc_producto = i.item_producto))	BEGIN		ROLLBACK TRANSACTION		RETURN	END
OPEN c_ejercicio16	FETCH NEXT FROM c_ejercicio16 INTO @cantidad, @producto	WHILE (@@FETCH_STATUS = 0)	BEGIN		SET @remanente = @cantidad				SELECT TOP 1 @totalStock = ISNULL(stoc_cantidad,0), @deposito = stoc_deposito  		FROM stock where stoc_producto = @producto		ORDER BY ISNULL(stoc_cantidad,0) DESC		WHILE @remanente > 0		BEGIN			IF (@totalStock > 0 AND @totalStock > @remanente ) OR (@totalStock <= 0)			BEGIN				UPDATE stock SET stoc_cantidad = ISNULL(stoc_cantidad,0) - @remanente				WHERE stoc_deposito = @deposito AND stoc_producto = @producto				SET @remanente = 0			END
ELSE -- DEBE DESCONTAR DE OTRO DEPOSITO 				IF @totalStock < @remanente				BEGIN									UPDATE stock SET stoc_cantidad = 0 					WHERE stoc_deposito = @deposito AND stoc_producto = @producto					SET @remanente = @remanente - @totalStock				END			SELECT TOP 1 @totalStock = ISNULL(stoc_cantidad,0), @deposito = stoc_deposito  			FROM stock where stoc_producto = @producto			ORDER BY ISNULL(stoc_cantidad,0) DESC				END		FETCH NEXT FROM c_ejercicio16 INTO @cantidad, @producto	END	CLOSE c_ejercicio16	DEALLOCATE c_ejercicio16ENDGO

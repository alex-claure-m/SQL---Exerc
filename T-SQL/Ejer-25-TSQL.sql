USE[GD2015C1]
GO

/*
25)

Desarrolle el/los elementos de base de datos necesarios para que no se permita que la composición
de los productos sea recursiva, o sea, que si el producto A compone al producto B,
dicho producto B no pueda ser compuesto por el producto A, hoy la regla se cumple.

-- ESTE TAMBIEN PINTA RECONTRA FALOPA PERO VEREMOS

-- ANALISIS

	- NO DEBO PERMITIR QUE LA COMPOSICION DE PRODUCTOS SEA RECURSIVA
	-- OSEA UNA PRODUCTO A, que compone al PRODUCTO B
	-- ENTONCES EL PRODUCTO B no puede ser compuesto por PRODUCTO A
*/

CREATE TRIGGER stsql_ejericcio25 ON Composicion -- la tabla composicion va a ser la que mostrara que se puede o no se puede componer
AFTER INSERT
AS 
BEGIN	
	DECLARE @producto char(8)
	DECLARE @componente char(8)
	DECLARE cursor_composicion CURSOR FOR (
											SELECT comp_producto,comp_componente
											FROM inserted
											)
	-- este cursor medio falopa pero lo que hace es que ese cursor se movera de la composicion_prpducto y composicion_componente
		-- de la tabla que inserte 
	OPEN cursor_composicion
	FETCH NEXT FROM cursor_composicion
	INTO @producto,@componente
	WHILE @@FETCH_STATUS = 0
	BEGIN-- le digo si existe cualquier Composicion cuyo comp_producto es = @componente y que
	-- ademas el componente es el = @prodcuto 
	-- entonces es por que el componente es hecho de un producto As
		IF EXISTS( SELECT *
				   FROM Composicion
				   WHERE comp_producto = @componente
						AND comp_componente = @producto)
		BEGIN
			RAISERROR('El producto %s ya compone al producto %s, por lo tanto no es posible insertar',1,1,@componente,@producto)
			ROLLBACK TRANSACTION
		END
	FETCH NEXT FROM cursor_comp
	INTO @producto,@componente
	END
	CLOSE cursor_comp
	DEALLOCATE cursor_comp
END
GO
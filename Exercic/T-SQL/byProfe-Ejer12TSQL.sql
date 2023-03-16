USE[GD2015C1]
GO

/*
12)

Cree el/los objetos de base de datos necesarios para que nunca un producto 
pueda ser compuesto por sí mismo. Se sabe que en la actualidad dicha regla se 
cumple y que la base de datos es accedida por n aplicaciones de diferentes tipos 
y tecnologías. No se conoce la cantidad de niveles de composición existentes.

-- cree los objetos NECESARIOS para que NUNCA un producto pueda ser COMPUESTO x si mismo
	--x el momento esta regla se esta cumpliedo 

*/

CREATE TRIGGER tr_ejercicio12
ON Composicion
AFTER INSERT, UPDATE -- DESPUES DE insertar , ACTUALIZAR
AS 
BEGIN

		CREATE TABLE #composiciones( -- creo una tabla temporal
		producto CHAR(8),  -- un producto
		componente CHAR(8), -- el componente del producto
		nivel INT -- cantidad niveles
		)
	-- UNA VEZ CREADA LA TABLA TEMPORAL=> DECLARO VARIABLES (que seran las que se insertaran en esa tabla)
	DECLARE @componente CHAR(8), @producto CHAR(8), @cantidad INT, @nivel INT 
	
	DECLARE c_ejercicio12 CURSOR FOR -- declaro un CURSOR
	SELECT comp_componente, comp_producto from inserted -- seleccioname el compo_componente, comp_producto de lo INSERTADO 
OPEN c_ejercicio12
	FETCH NEXT FROM c_ejercicio12 INTO @componente, @producto -- puntero a la siguiente FILA
	WHILE (@@FETCH_STATUS = 0) -- mientras el estatus sea = 0 (osea que haya valores en la tabla)
	BEGIN

		INSERT INTO #composiciones VALUES (@producto,@componente,1)
		SET @cantidad = 1 --(inicializo que cantidad de ese componente es 1)
		SET @nivel = 1 --(inicializo que el nivel va a ser 1 por que hay componente de ese producto)

		WHILE @cantidad > 0 
		BEGIN
			INSERT INTO #composiciones -- insertame en la tabla temporal Composiciones
			SELECT c.comp_producto, c.comp_componente, @nivel + 1 -- el producto, el componente, y el nivel +1 
			FROM Composicion c -- de la tabla Composicion
			INNER JOIN #composiciones ct ON ct.componente = c.comp_producto -- y JOINEAME que el Componente de la tabla temporal sea = al componente del producto de la tabla Composicion
			WHERE ct.nivel = @nivel -- DONDE SEA EL MISMO NIVEL
			AND NOT EXISTS (SELECT 1 FROM #composiciones ct2 WHERE ct2.componente = c.comp_componente AND ct2.producto = c.comp_producto)
			-- y que ademas no exista UNO (de la misma tabla temporal de Composiciones) cuyo componente sea el mismo que la tabla Composicion
			-- y ni que sea el mismo producto
			-- ESTO ES PARA ASEGURAR ningun producto se pueda componer A SI MISMO
			SET @cantidad = @@ROWCOUNT -- seteame cantidad como ROWCOUNT, osea un contador , estaba ya en 1, entonces pasaria a 2

			SET @nivel = @nivel + 1 -- aumentame el nivel + 1

		END

		IF EXISTS (SELECT 1 FROM #composiciones ct WHERE ct.componente = @producto) -- PERO IS EXISTE UN PRODUCTO QUE ESTE EN EL COMPONENTE
		BEGIN
			ROLLBACK TRANSACTION -- rollbackeame esta parte de la operacion
			RETURN
		END

		FETCH NEXT FROM c_ejercicio12 INTO @componente, @producto -- apunto al siguiente 
	END
	CLOSE c_ejercicio12
	DEALLOCATE c_ejercicio12

END

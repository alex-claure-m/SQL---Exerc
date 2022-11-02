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

IF OBJECT_ID('TR_CONTROLAR_COMPOSICION') IS NOT NULL
	DROP TRIGGER TR_CONTROLAR_COMPOSICION
GO

CREATE TRIGGER TR_CONTROLAR_COMPOSICION
ON Composicion
AFTER INSERT, UPDATE --
AS 
BEGIN

		CREATE TABLE #composiciones(
		producto CHAR(8), 
		componente CHAR(8),
		nivel INT
		)
	
	DECLARE @componente CHAR(8), @producto CHAR(8), @cantidad INT, @nivel INT
	
	DECLARE c_ejercicio12 CURSOR FOR
	SELECT comp_componente, comp_producto from inserted
OPEN c_ejercicio12
	FETCH NEXT FROM c_ejercicio12 INTO @componente, @producto
	WHILE (@@FETCH_STATUS = 0)
	BEGIN

		INSERT INTO #composiciones VALUES (@producto,@componente,1)
		SET @cantidad = 1
		SET @nivel = 1

		WHILE @cantidad > 0 
		BEGIN
			INSERT INTO #composiciones 
			SELECT c.comp_producto, c.comp_componente, @nivel + 1
			FROM Composicion c
			INNER JOIN #composiciones ct ON ct.componente = c.comp_producto
			WHERE ct.nivel = @nivel
			AND NOT EXISTS (SELECT 1 FROM #composiciones ct2 WHERE ct2.componente = c.comp_componente AND ct2.producto = c.comp_producto)

			SET @cantidad = @@ROWCOUNT 

			SET @nivel = @nivel + 1

		END

		IF EXISTS (SELECT 1 FROM #composiciones ct WHERE ct.componente = @producto) 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN
		END

		FETCH NEXT FROM c_ejercicio12 INTO @componente, @producto
	END
	CLOSE c_ejercicio12
	DEALLOCATE c_ejercicio12

END










/*
ACLARACION: El trigger solo va a actuar cuando se realiza un INSERT. 
Si bien lo recomendable es que la PK nunca tenga que cambiar quise intentar que el trigger
tambien actue en caso de un UPDATE pero se hace bastante complejo ya que en caso
de que cambien la PK entera (comp_producto y comp_componente) no tengo forma de relacionar
las tablas inserted y deleted entre si a menos que cree una nueva PK asegurandome de que
esta nunca cambie, por lo tanto solo considero el evento INSERT, lo cual simplifico
mucho, igual dejo por las dudas el codigo del trigger que contemplaba INSERT y UPDATE 
comentado por si alguien quiere ojearlo.
*/

IF OBJECT_ID('TR_CONTROLAR_COMPOSICION') IS NOT NULL
	DROP TRIGGER TR_CONTROLAR_COMPOSICION
GO

CREATE TRIGGER TR_CONTROLAR_COMPOSICION
ON Composicion
INSTEAD OF INSERT
AS
	DECLARE @PRODUCTO_NUEVO CHAR(8)
	DECLARE @COMPONENTE_NUEVO CHAR(8)
	
	DECLARE C_COMPOSICION CURSOR FOR 
	SELECT inserted.comp_producto, inserted.comp_componente
	FROM inserted

	OPEN C_COMPOSICION
	FETCH NEXT FROM C_COMPOSICION INTO @PRODUCTO_NUEVO, @COMPONENTE_NUEVO

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @COMPONENTE_NUEVO != @PRODUCTO_NUEVO
		BEGIN
			INSERT INTO Composicion
			SELECT * FROM inserted
			WHERE comp_producto = @PRODUCTO_NUEVO
			AND comp_componente = @COMPONENTE_NUEVO
		END
		ELSE
			RAISERROR('EL PRODUCTO %s NO PUEDE ESTAR COMPUESTO POR SI MISMO', 16, 1, @PRODUCTO_NUEVO)
			
	FETCH NEXT FROM C_COMPOSICION INTO @PRODUCTO_NUEVO, @COMPONENTE_NUEVO
	END
	CLOSE C_COMPOSICION
	DEALLOCATE C_COMPOSICION
GO 

--PRUEBA

-- Elijo un producto compuesto como por ejemplo el producto 00001707 esta compuesto 
-- por dos 2 productos, el producto 00001491 y el 00014003 

SELECT * 
FROM Composicion
WHERE comp_producto = '00001707'

-- Primero pruebo con intentar insertar el producto 00001707 como componente
-- de si mismo, no me deberia dejar ya que no puede estar compuesto por si mismo 

INSERT INTO Composicion VALUES (2, '00001707', '00001707')

-- Compruebo que no se haya insertado el componente

SELECT * FROM Composicion WHERE comp_producto = '00001707'

-- Ahora pruebo con intentar insertar un componente distinto a si mismo 
-- para el producto 00001707 lo cual me deberia dejar hacer 

INSERT INTO Composicion VALUES (2, '00001707', '00001708')

-- Compruebo que se haya insertado el componente

SELECT * FROM Composicion WHERE comp_producto = '00001707'

-- Borro el componente de prueba

DELETE FROM Composicion 
WHERE comp_producto = '00001707' 
AND comp_componente = '00001708'
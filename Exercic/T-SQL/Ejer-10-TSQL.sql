USE[GD2015C1]
GO

/*
10)

Crear el/los objetos de base de datos que ante el intento de borrar un artículo 
verifique que no exista stock y si es así lo borre en caso contrario que emita un 
mensaje de error.

-- creemos los objetos (OBJECT_ID) en el cual ANTE UN INTENTO DE BORRAR - TRIGGER -
-- DEBEMOS VERIFICAR QUE NO EXISTA STOCK, CASO CONTRARIO EMITIR UN MENSAJE

-- ANTES DEL DELETE AHI SE DEBE EJECUTAR EL TRIGGER 
*/

IF OBJECT_ID('TR_ELIMINAR_PRODUCTO') IS NOT NULL
	DROP TRIGGER TR_ELIMINAR_PRODUCTO
GO

CREATE TRIGGER TR_ELIMINAR_PRODUCTO
ON Producto INSTEAD OF DELETE -- EN LUGAR DE BORRAR  (el INSTEAD OF puede tambien ir un AFTER - DESPUES - pero este no nos sirve ahora)
AS 
BEGIN
	DECLARE @producto CHAR(8) -- declaro el articulo  para verificar si no es es este al que quieren borrar
	DECLARE cursor_producto CURSOR FOR -- declaro cursor
		SELECT prod_codigo FROM deleted  -- selecciono el codigo del producto de la tabla DELETED

	OPEN cursor_producto  -- inicializao cursor
	FETCH NEXT FROM cursor_producto INTO @producto -- que el cursor_producto tenga el PRODUCTO declarado

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @stock DECIMAL(12,2) -- necesito saber sobre el stock del prodcto
		SET @stock = (SELECT SUM(s.stoc_cantidad) FROM STOCK s WHERE s.stoc_producto = @producto ) -- le sumo las cantidadesd de stock para ese producto
	IF @stock  <= 0  -- SI NO HAY STOCK
		DELETE FROM Producto  WHERE prod_codigo = @producto -- ELIMINO DE LA TABLA EL PRODUCTO
		ELSE
			RAISERROR('NO SE PUDO BORRAR EL PRODUCTO %s YA QUE TIENE STOCK', 16, 1, @producto)
			 
		FETCH NEXT FROM cursor_producto INTO @producto
	END

	CLOSE cursor_producto
	DEALLOCATE cursor_producto
END
GO




--PRUEBA

-- Hago un listado de los productos con stock y agarro la primer fila que corresponde
-- al producto 00010417 con un stock total de 191767 unidades por lo tanto el trigger
-- no me deberia dejar borrarlo ya que el producto tiene stock

SELECT stoc_producto, SUM(stoc_cantidad) AS 'Total stock' 
FROM STOCK
GROUP BY stoc_producto
ORDER BY SUM(stoc_cantidad) DESC 

-- Cuando ejecuto el trigger me tira un mensaje de error que no se pudo realizar la accion
-- ya que el producto tiene stock

DELETE FROM Producto
WHERE prod_codigo = '00010417'

-- Verifico que el producto siga en la tabla de Productos

SELECT * 
FROM Producto
WHERE prod_codigo = '00010417'

-- Ahora inserto un producto de prueba sin stock disponible para eliminarlo y ver si el
-- trigger deja realizar la accion

INSERT INTO Producto VALUES('99999999', 'PRUEBA', 0.1, '001', '0001', 1)
INSERT INTO STOCK VALUES(0, 0, 100, NULL, NULL, '99999999', '00')

-- Verifico que se hayan realizado mis inserts

SELECT * 
FROM Producto
WHERE prod_codigo = '99999999'

SELECT * 
FROM STOCK
WHERE stoc_producto = '99999999'
AND stoc_deposito = '00'

-- Para ejecutar el DELETE primero desactivo la FK en stock ya que sino no me va a dejar
-- borrar el producto.

ALTER TABLE STOCK NOCHECK CONSTRAINT R_11

-- Hecho esto veo que cuando ejecuto el trigger me sale que una fila fue afectada y de paso
-- borro tambien la fila que habia creado en la tabla STOCK

DELETE FROM Producto
WHERE prod_codigo = '99999999'

DELETE FROM STOCK
WHERE stoc_producto = '99999999'
AND stoc_deposito = '00'

-- Vuelvo a activar la FK en la tabla STOCK para dejarlo como estaba

ALTER TABLE STOCK WITH CHECK CHECK CONSTRAINT R_11

-- Finalmente verifico que el producto ya no este en la tabla de Productos

SELECT * 
FROM Producto
WHERE prod_codigo = '99999999'

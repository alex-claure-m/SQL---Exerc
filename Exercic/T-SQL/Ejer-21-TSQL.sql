USE[GD2015C1]
GO

/*
21)

Desarrolle el/los elementos de base de datos necesarios para que se cumpla automaticamente la regla
de que en una factura no puede contener productos de diferentes familias. 
En caso de que esto ocurra no debe grabarse esa factura y debe emitirse un error en pantalla

-- analisis 
una factura NO puede contener PRODUCTOS DE DIFERENTES FAMILIAS
-- SI ESTO OCURRE => NO ACTUALIZAR FACTURA + emitir error pantalla
*/

CREATE TRIGGER stql_ejercicio21 ON Factura
AFTER INSERT
AS 
BEGIN
-- PUEDO HACERLO DE 2 FORMAS, DECLARANDO VALORES Y CON UN CURSOR PARA QUE SE MUEVA POR TODA LA TABLA Y DE AHI ACTUALIZAR
				-- O HACER UN EXIST y validar de que se cumpla con los requisitos 

IF EXISTS(SELECT fact_numero+fact_sucursal+fact_tipo  -- ACA LE DIGO SI EXISTE UNA FACTURA que sesra insertada 
				 FROM inserted 
				 INNER JOIN Item_Factura -- QUE MATCHEE CON ITEM_FACTURA
						ON item_numero+item_sucursal+item_tipo = fact_numero+fact_sucursal+fact_tipo
				INNER JOIN Producto ON prod_codigo = item_producto  -- QUE SEA EL MISMO PRODUCTO
				JOIN Familia ON fami_id = prod_familia -- y pertenezca al grupo de familia 
                 GROUP BY fact_numero+fact_sucursal+fact_tipo -- AGRUPAMELOS POR FACTURA
                 HAVING COUNT(distinct fami_id) <> 1 -- CONTAME AQUELLAS FAMILIAS DISTINTAS A 1 ???=> NO LO ENTIENDO POR QUE DISTINTO
				 -- creo que apunta a que debe ser distinto a 1 FAMILIA 
					)
			-- UNA VEZ COMPROBADO DE QUE EXISTE UNA FACTURA QUE PERTENEZCA A UNA FAMILIA LO QUE HARE SON A LOS QUE ENCONTRO
			-- SERA ELIMINARLO DE LAS BBDD 
			  BEGIN
              DECLARE @NUMERO char(8),@SUCURSAL char(4),@TIPO char(1)
			  -- DECLARO VARIBLE NUMERO, SUCURSAL Y TIPO , que sera para FACTURA
              DECLARE cursorFacturas CURSOR FOR SELECT fact_numero,fact_sucursal,fact_tipo FROM inserted
			  -- DECLARO EL CURSOR NUMERO,SUCURSAL Y TIPO 
              OPEN cursorFacturas
              FETCH NEXT FROM cursorFacturas INTO @NUMERO,@SUCURSAL,@TIPO
              WHILE @@FETCH_STATUS = 0
              BEGIN
                     DELETE FROM Item_Factura WHERE item_numero+item_sucursal+item_tipo = @NUMERO+@SUCURSAL+@TIPO
                     DELETE FROM Factura WHERE fact_numero+fact_sucursal+fact_tipo = @NUMERO+@SUCURSAL+@TIPO
                     FETCH NEXT FROM cursorFacturas INTO @NUMERO,@SUCURSAL,@TIPO -- QUE VUELVA AL LOOP
              END
              CLOSE cursorFacturas
              DEALLOCATE cursorFacturas
              RAISERROR ('no puede ingresar productos de mas de una familia en una misma factura.',1,1)
              ROLLBACK
       END
END


-- version 2

CREATE TRIGGER dbo.ejercicio21 ON Item_factura FOR INSERT -- aca apunto a ITEM_FACTURA
AS
BEGIN
	DECLARE @tipo char(1) -- de la factura
	DECLARE @sucursal char(4) -- de la factura
	DECLARE @numero char(8) -- de la factura
	DECLARE @producto char(8) -- producto para saber der que habamos 
	DECLARE cursor_ifact CURSOR FOR SELECT item_tipo,item_sucursal,item_numero,item_producto
									FROM inserted
	OPEN cursor_ifact -- inicializo cursor
	FETCH NEXT FROM cursor_ifact -- apuntame al siguiente cursor
	INTO @tipo,@sucursal,@numero,@producto -- e insertame estas variables
	WHILE @@FETCH_STATUS = 0
	BEGIN
	-- declaro la variable para que me almacene la familia de un producto,
	-- para eso el codigo del producto tiene que ser el producto que estoy analizando
		declare @familiaProd char(3) = (
									SELECT prod_familia
									FROM Producto
									WHERE prod_codigo = @producto
									)
		-- ENTONCES DATOS EN LA TABLA ITEM_FACTURA que sea:
			-- el producto igual a ite_producto
			-- DONDE ITEM_TIPO,ITEM_SUCURSAL .... SEA = @TIPO,SUCURSAL,ETC
			-- Y ADEMAS DONDE LA FAMLIA DEL PRODUCTO SEA LA FAMILIA QUE BUSQUE ANTERIORMENTE
			-- Y QUE (CLAVE) el codigo del producto SEA DISTINTO
				-- hace referencia a que existe un PRODUCTO DISTINTO a ESA FAMILIA 
		IF EXISTS(
					SELECT *
					FROM Item_Factura
						INNER JOIN Producto
							ON prod_codigo = item_producto		
					WHERE item_tipo+item_sucursal+item_numero = @tipo+@sucursal+@numero
						AND prod_familia = @familiaProd
						AND prod_codigo <> @producto
						)
		-- ENTONCES BORRARE DATOS
		BEGIN
			DELETE FROM Item_factura WHERE item_tipo+item_sucursal+item_numero = @tipo+@sucursal+@numero
			DELETE FROM Factura WHERE fact_tipo+fact_sucursal+fact_numero = @tipo+@sucursal+@numero
			RAISERROR('La familia del producto a insertar ya existe en la factura mencionada',1,1)
			ROLLBACK TRANSACTION
		END
	FETCH NEXT FROM cursor_ifact
	INTO @tipo,@sucursal,@numero,@producto
	END
	CLOSE cursor_ifact
	DEALLOCATE cursor_ifact
END
GO

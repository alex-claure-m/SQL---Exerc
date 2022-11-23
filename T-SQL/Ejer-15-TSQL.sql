USE [GD2015C1]
GO

/*
Cree el/los objetos de base de datos necesarios para que el objeto principal reciba un producto como parametro 
y retorne el precio del mismo.
Se debe prever que el precio de los productos compuestos sera la sumatoria de los componentes del mismo multiplicado
por sus respectivas cantidades. No se conocen los nivles de anidamiento posibles de los productos. 
Se asegura que nunca un producto esta compuesto por si mismo a ningun nivel. El objeto principal debe poder ser utilizado
como filtro en el where de una sentencia select.


-- que diga "reciba un PRODUCTO como PARAMETRO y RETORNE el PRECIO =>  hacer una funcion

-- TIPS
	- DECLARE precio
	- DECLARE cantidades
	- DECLARE productoCompuesto

- entonces debo calcualr el precio nuevo del producto compuesto que sera 
	*la sumatoria de todos los componente que tiene por su CANTIDAD

- debo asegurarme que un producto no debe estar compuesto por si MISMO


*/

IF OBJECT_ID (N'dbo.precioCompuesto', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.precioCompuesto;  
GO
CREATE FUNCTION dbo.precioCompuesto (@prod CHAR(8))
RETURNS DECIMAL(12,2)
BEGIN
	DECLARE @comp CHAR(8), @cant DECIMAL(12,2), @precio DECIMAL(12,2)
	SET @precio = 0
	DECLARE cur CURSOR FOR
		SELECT	comp_componente, comp_cantidad
		FROM Composicion
		WHERE comp_producto = @prod	
	OPEN cur
	FETCH NEXT FROM cur INTO @comp, @cant
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @precio = @precio + @cant * dbo.precioCompuesto(@comp)
		FETCH NEXT FROM cur INTO @comp, @cant
	END
	IF @precio = 0
		SET @precio = (SELECT prod_precio FROM Producto WHERE prod_codigo = @prod)	
	CLOSE cur
	DEALLOCATE cur
	RETURN @precio
END
GO









Alter FUNCTION dbo.ejercicio15 (@producto char(8))
RETURNS decimal(12,2)
AS
BEGIN
	DECLARE @precioProd decimal(12,2) = 0
	DECLARE @prodCompuesto char(8)
	DECLARE @cantProdCompuesto decimal(12,2)
	IF NOT EXISTS(SELECT * FROM Composicion WHERE comp_producto = @producto)
	BEGIN
		SET @precioProd = (
							SELECT prod_precio
							FROM Producto
							WHERE prod_codigo = @producto
							)
		RETURN @precioProd
	END
	ELSE
	BEGIN
		DECLARE cursor_prod CURSOR FOR SELECT comp_componente,comp_cantidad
										FROM Composicion
										WHERE comp_producto = @producto
		OPEN cursor_prod
		FETCH NEXT FROM cursor_prod
		INTO @prodCompuesto,@cantProdCompuesto
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @precioProd = @precioProd + (
												SELECT prod_precio
												FROM Producto
												WHERE prod_codigo = @prodCompuesto
												) * @cantProdCompuesto
		FETCH NEXT FROM cursor_prod
		INTO @prodCompuesto,@cantProdCompuesto
		END
		CLOSE cursor_prod
		DEALLOCATE cursor_prod
		RETURN @precioProd
	END
	RETURN @precioProd
END
GO

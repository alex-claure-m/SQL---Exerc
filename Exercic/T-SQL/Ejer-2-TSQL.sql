USE [GD2015C1]
GO

/*
2)
Realizar una función que dado un artículo y una fecha, retorne el stock que existía a esa fecha
*/

/*
palabras reservadas para indicarle de que si existe el objeto llamado ej2-tsql y no es nulo
borrame eso y ..... GO
*/
IF OBJECT_ID (N'dbo.ejer2_tsql', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.ejer2_tsql;
GO
-- articulo se refiere al producto
CREATE FUNCTION ejer2_tsql (@articulo CHAR(8) , @fecha SMALLDATETIME)
RETURNS DECIMAL(12,2)
AS
	BEGIN -- que comienze . aunque aca le puedo instanciar variables
	RETURN -- para que regrese esa operacion!
		ISNULL((SELECT sum(stoc_cantidad)
			FROM STOCK
			WHERE stoc_producto = @articulo), 0) 		
-- le digo que me sume la cantidad de stock de la tabla stock DONDE STOC_PRODUCTO sea = al producto (articulo) que busco
		+
-- pero ademas debo sumar las cantidades de aquellos productos que se estan vendiendo
-- diciendole que me sume las cantidades de items que se venderan en las cuales joinee con factura 
-- por que de aca necesito saber las fechas
		ISNULL((SELECT sum(item_cantidad)
			FROM Item_Factura
				JOIN Factura ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
			WHERE item_producto = @articulo AND fact_fecha > @fecha), 0)

END
GO

USE [GD2015C1]
GO

/*
1)
Hacer una función que dado un artículo y un deposito devuelva un string que
indique el estado del depósito según el artículo. Si la cantidad almacenada es 
menor al límite retornar “OCUPACION DEL DEPOSITO XX %” siendo XX el 
% de ocupación. Si la cantidad almacenada es mayor o igual al límite retornar
“DEPOSITO COMPLETO”.

*/

-- producto = 30
-- deposito = 00 ==> 10 unidades con 50 de maximo , 20% de ocupacion

--select * from STOCK
--where stoc_cantidad >= stoc_stock_maximo
-- EN SU VERSION ES PARA EL PRODUCTO 1707 en el deposito 02 - stock= completo

CREATE FUNCTION fx_ejericico1_tsql (@articulo char(8), @deposito char(2))
RETURNS VARCHAR(MAX) AS
BEGIN
	DECLARE @retorno	varchar(MAX) = ''
	DECLARE @cantidad	DECIMAL(12,2) -- MIRO EL TIPO SEGUN STOCK
	DECLARE @maximo		DECIMAL(12,2) -- MIRO SU TIPO DE DATO SEGUN STOCK TABLA PRINCIPAL
	DECLARE @porcentaje	DECIMAL(12,2)

	SELECT  @cantidad = ISNULL(stoc_cantidad,0),  @maximo = ISNULL(stoc_stock_maximo,0)
		FROM STOCK WHERE stoc_producto = @articulo and stoc_deposito = @deposito

	IF @cantidad >= @maximo
		SET @retorno = 'DEPOSITO COMPLETO'
	ELSE
		BEGIN
			SET @porcentaje = @cantidad * 100 / @maximo
	
	SET @retorno = CONCAT('DEPOSITO ESTA OCUPADO AL', @porcentaje, '%')

	RETURN @retorno


END
GO

-- PORCENTAJE --> EL 10 DE 50 ES EL 20%
-- 10*100 /50



-- ESTO IRIA EN OTRO ARCHIVITO PONELEL

-- PERO MIRAR LOS ULTIMOS MINUTOS DE CLASES QUE HACE UN ALTER A LA FUNCION

SELECT [dbo].[fx_ejericico1_tsql] ('00001707','02')
GO





/* -------------------------------- VERSION PROFESOR ---------------------------------- */

/*
Hacer una función que dado un artículo y un deposito devuelva un string que indique el estado del depósito según el artículo.
Si la cantidad almacenada es menor al límite retornar “OCUPACION DEL DEPOSITO XX %” siendo XX el % de ocupación.
Si la cantidad almacenada es mayor o igual al límite retornar “DEPOSITO COMPLETO”.
*/


/*
DADO UN ARTICULO Y DEPOSITO -> LA FUNCION TENDRA 2 PARAMETROS 
DEVOLVER UN STRING -> RETURNS VARCHAR => que indicara el estado del DEPOSITO 

*/


/* version profesor pero aun asi mirate los ultimos 20 minutos*/



CREATE FUNCTION dbo.fx_ejercicio1_tsql (@articulo CHAR(8), @deposito CHAR(2))
RETURNS VARCHAR(MAX) AS 
BEGIN
	
	DECLARE @retorno      VARCHAR(MAX) = ''
	DECLARE @cantidad     DECIMAL(12,2)
	DECLARE @maximo       DECIMAL(12,2)
	DECLARE @porcentaje   DECIMAL(12,2)
	 
	SELECT @cantidad = ISNULL(stoc_cantidad,0), @maximo = ISNULL(stoc_stock_maximo,0) 
	FROM stock WHERE stoc_producto = @articulo AND stoc_deposito = @deposito
	
	IF @@ROWCOUNT = 0 -- si no hay ninguna fila que fue afectado durante su ejecucion -> entonces..
		RETURN 'ARTICULO O DEPOSITO INEXISTENTE O SIN UNIDADES EN DEPOSITO'

	IF @cantidad >= @maximo  -- si la cantidad calculada (de stock) es = al maximo (de stock maximo)
		SET @retorno = 'DEPOSITO COMPLETO' -- seteame la variable retorno "deposito completo
	ELSE -- si no es ninguno de los 2 entonces ....
		BEGIN -- begin por que hare alguna operacion aritmetica
			SET @porcentaje = @cantidad * 100 / @maximo
			SET @retorno = CONCAT('EL DEPOSITO ESTA OCUPADO AL ',@porcentaje, '%')
		END

	RETURN @retorno

END
GO


SELECT [dbo].[fx_ejercicio1_tsql] ('00001707','02')
GO

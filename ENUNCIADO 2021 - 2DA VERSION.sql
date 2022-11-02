USE[GD2015C1]
GO

/*
-- ENUNCIADO 2021

Realizar una consulta SQL que retorne: 
	A�o (OK)
	Cantidad de productos compuestos vendidos en el A�o 
	Cantidad de facturas realizadas en el A�o (OK)
	Monto total facturado en el A�o (OK)
	Monto total facturado en el A�o anterior.
*/

SELECT 
	 (f.fact_fecha)
		 FROM Factura f


















SELECT
	YEAR(fact2.fact_fecha) as 'Anio', 
	(
		SELECT SUM(itemFact.item_cantidad)
		FROM Factura fact
		JOIN Item_Factura itemFact ON itemFact.item_tipo = fact.fact_tipo AND itemFact.item_sucursal = fact.fact_sucursal AND itemFact.item_numero = fact.fact_numero
		WHERE 
			YEAR(fact.fact_fecha) = YEAR(fact2.fact_fecha)
			AND itemFact.item_producto IN (
				SELECT DISTINCT prod.prod_codigo FROM Producto prod JOIN Composicion c ON c.comp_producto = prod.prod_codigo
			)

	) as 'Productos compuestos vendidos',
	COUNT(DISTINCT fact2.fact_tipo+fact2.fact_sucursal+fact2.fact_numero) as 'Facturas realizadas',
	(SELECT SUM(fact.fact_total) FROM Factura fact WHERE year(fact.fact_fecha) = year(fact2.fact_fecha))  as 'Monto total facturado',
	(
		SELECT COALESCE(SUM(fact.fact_total), 0)
		FROM Factura fact
		WHERE YEAR(fact.fact_fecha) = YEAR(fact2.fact_fecha) - 1
	) as 'Monto total facturado a�o anterior'
FROM Factura fact2
JOIN Item_Factura itemFact2 ON itemFact2.item_tipo = fact2.fact_tipo AND itemFact2.item_sucursal = fact2.fact_sucursal AND itemFact2.item_numero = fact2.fact_numero
GROUP BY YEAR(fact2.fact_fecha)
HAVING COALESCE(SUM(itemFact2.item_cantidad),0) > 1000
ORDER BY COALESCE(SUM(itemFact2.item_cantidad),0) DESC


/*
Realizar una funci�n
	Parametros:
		Tipo de factura 
		Sucursal 
	Retorno:
		Pr�ximo n�mero de factura consecutivo 
		No exista ninguno informar el primero
	Consideraciones:
		El tipo de dato y formato de retorno debe coincidir con el de la tabla (Ej. '00002021').
*/

/*SELECT *
  FROM sys.sql_modules m 
INNER JOIN sys.objects o 
        ON m.object_id=o.object_id
WHERE type_desc like '%function%'*/

CREATE FUNCTION dbo.ProxNumFactura1(@tipo CHAR(1), @sucursal CHAR(4))
RETURNS CHAR(8)
BEGIN
	RETURN COALESCE((
    SELECT 
	MAX(f.fact_numero) 
	FROM Factura f
    WHERE f.fact_sucursal = @sucursal AND f.fact_tipo = @tipo
    ), 0) + 1 
END;

DROP FUNCTION dbo.ProxNumFactura1

SELECT dbo.ProxNumFactura1('A', '0003')



/*
Realizar un stored procedure que 
	Objetivo:
		Inserte un nuevo registro de factura y un �tem
	Parametros:
		Todos los datos obligatorios de las 2 tablas, la fecha y un c�digo de dep�sito
	Consideraciones:
		Guardar solo los valores no nulos en ambas tablas
		Restar el stock de ese producto en la tabla correspondiente
		Se debe validar previamente la existencia del stock en ese dep�sito y en caso de no haber no realizar nada.
		El total de factura se calcula como el precio de ese �nico �tem
		Los impuestos es el 21% de dicho valor redondeado a 2 decimales.
Se debe programar una transacci�n para que las 3 operaciones se realicen at�micamente, se asume que todos los par�metros recibidos est�n validados a excepci�n de la cantidad del producto en stock.
Queda a criterio del alumno, que acciones tomar en caso de que no se cumpla la �nica validaci�n o se produzca un error no previsto.
*/

create procedure proc_registroNuevo (
		@facturaTipo CHAR(1), 
		@facturaSucursal CHAR(4),
		@facturaNumero CHAR(8),
		@fechaRegistro SMALLDATETIME,
		@deposito CHAR(2),
		@producto CHAR(8),
		@precioProducto DECIMAL(12,2)
	)

AS
	DECLARE @stock decimal(12,2)
	SET @stock = (SELECT ISNULL((SELECT s.stoc_cantidad FROM STOCK s WHERE s.stoc_producto =@producto AND s.stoc_deposito = @deposito),0)
	-- seteo la cantidad de stock del producto 
	IF @stock < 1
		BEGIN
			RAISERROR('no hay stock del producto en el deposito',1,1)
			rollback
			RETURN
		ELSE
			BEGIN
				SET @precioProducto = (SELECT p.prod_precio FROM Producto p WHERE p.prod_codigo = @producto)
				BEGIN TRANSACTION

				UPDATE dbo.STOCK

				SET stoc_cantidad = stoc_cantidad - 1
				WHERE stoc_producto = @producto AND stoc_deposito = @deposito;


				INSERT INTO dbo.Factura 
				(
					fact_tipo,
					fact_sucursal,
					fact_numero,
					fact_fecha,
					fact_total,
					fact_total_impuestos
				)
				VALUES
				(
					@facturaTipo,
					@facturaSucursal,
					@facturaNumero,
					@fechaRegistro,
					@precioProducto,
					ROUND(@precioProducto * 0.21, 2)
				);
				INSERT INTO dbo.Item_Factura
				(
					item_tipo,
					item_sucursal,
					item_numero,
					item_producto,
					item_cantidad,
					item_precio
				)
				VALUES
				(
					@facturaTipo,
					@facturaSucursal,
					@facturaNumero,
					@producto,
					1,
					@precioProducto
				);
				ROLLBACK 
			END
		END














DROP PROCEDURE dbo.ComprarUnProducto;
CREATE PROCEDURE dbo.ComprarUnProducto 
	@fact_tipo char(1), 
	@fact_sucursal char(4),
	@fact_numero char(8),
	@item_producto char(8),
	@fecha smalldatetime,
	@depo_codigo char(2)
AS
	DECLARE @stock decimal(12,2);
	SET @stock = (SELECT ISNULL((SELECT s.stoc_cantidad FROM STOCK s WHERE s.stoc_producto = @item_producto AND s.stoc_deposito = @depo_codigo), 0));
	IF @stock < 1
		BEGIN
			print 'Stock insuficiente: ' + convert(varchar, @stock);
		END
	ELSE
		BEGIN
			DECLARE @precio decimal(12,2);
			DECLARE @upd_error int, @ins1_error int, @ins2_error int;

			SET @precio = (SELECT p.prod_precio FROM Producto p WHERE p.prod_codigo = @item_producto);
			
			BEGIN TRANSACTION T1 WITH MARK 'VENDIENDO UN PRODUCTO';

			UPDATE dbo.STOCK
			SET stoc_cantidad = stoc_cantidad - 1
			WHERE stoc_producto = @item_producto AND stoc_deposito = @depo_codigo;

			SET @upd_error = @@ERROR;

			INSERT INTO dbo.Factura 
				(
					fact_tipo,
					fact_sucursal,
					fact_numero,
					fact_fecha,
					fact_total,
					fact_total_impuestos
				)
				VALUES
				(
					@fact_tipo,
					@fact_sucursal,
					@fact_numero,
					@fecha,
					@precio,
					ROUND(@precio * 0.21, 2)
				);
			SET @ins1_error = @@ERROR;

			INSERT INTO dbo.Item_Factura
				(
					item_tipo,
					item_sucursal,
					item_numero,
					item_producto,
					item_cantidad,
					item_precio
				)
				VALUES
				(
					@fact_tipo,
					@fact_sucursal,
					@fact_numero,
					@item_producto,
					1,
					@precio
				);
			SET @ins2_error = @@ERROR;

			IF @upd_error = 0 AND @ins1_error = 0 AND @ins2_error = 0
			BEGIN
				PRINT 'Sali� todo bien'
				COMMIT TRAN
			END
			ELSE
			BEGIN
				IF @upd_error <> 0
					PRINT 'Error en update'
				IF @ins1_error <> 0
					PRINT 'Error en insert 1'
				IF @ins2_error <> 0
					PRINT 'Error en insert 2'
			 ROLLBACK TRANSACTION T1
			END
		END
GO


EXEC dbo.ComprarUnProducto 
	@fact_tipo = 'A', 
	@fact_sucursal = '0003', 
	@fact_numero = '33233122',
	@item_producto = '42424242',
	@fecha = '2010-01-23 00:00:00',
	@depo_codigo = '00'

EXEC dbo.ComprarUnProducto 
	@fact_tipo = 'A', 
	@fact_sucursal = '0003', 
	@fact_numero = '55555559',
	@item_producto = '00000030',
	@fecha = '2010-01-23 00:00:00',
	@depo_codigo = '00'

SELECT S.stoc_cantidad FROM STOCK S WHERE S.stoc_producto = '00000030' AND S.stoc_deposito = '00'


/* ================================= version 2 =========================== */


create procedure sp_parcial2021(@tipo char(1),@sucursal char(4),@numero char(8), @producto char(8), @deposito char(2), @precio decimal(12,2), @cantidad decimal(12,2))
as
begin
	declare @stock as decimal(12,2)
	declare @fecha as smalldatetime
	set @fecha = GETDATE()
	select @stock = isnull(stoc_cantidad,0) from STOCK where stoc_deposito = @deposito and stoc_producto = @producto

	if @stock > @cantidad
	begin
		begin transaction
		begin try
			insert into Factura(fact_tipo, fact_sucursal,fact_numero,fact_fecha,fact_total,fact_total_impuestos) 
			values (@tipo,@sucursal,@numero,@fecha,coalesce(@precio*@cantidad,0),round(coalesce(@precio*21/100,0),2))

			insert into Item_Factura(item_tipo, item_sucursal, item_numero, item_producto, item_precio, item_cantidad) 
			values (@tipo,@sucursal,@numero,@producto,coalesce(@precio,0),@cantidad)

			update Stock set stoc_cantidad = @stock - @cantidad where stoc_deposito = @deposito and stoc_producto = @producto
		end try
		begin catch
			rollback transaction;
			throw 50001,'Error: No se ha podido realizar la operaci�n',1
		end catch
	end
	else 
	begin
		throw 50002,'Error: No hay Stock disponible para el producto elegido',1
	end
	commit transaction;
end

drop procedure sp_parcial2021

execute sp_parcial2021 
@tipo = 'T', @sucursal = '9999', @numero ='00000001', @producto = '00000849',  @deposito ='00', @precio = 2, @cantidad = 4

select * from factura where fact_tipo = 'T'
select * from Item_Factura where item_tipo = 'T'
select * from stock where stoc_producto = '00000849' and stoc_deposito = '00'

update Stock set stoc_cantidad = 20 where stoc_producto = '00000849' and stoc_deposito = '00'

delete from Item_Factura where item_tipo = 'T'
delete from Factura where fact_tipo = 'T'
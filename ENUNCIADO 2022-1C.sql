USE[GD2015C1]
GO

/*
ENUNCIADO PARCIAL 2022 - 1C

se requiere mostrar los productos que sean componentes y que se hayan vendido en forma unitaria
o a traves del producto al cual compone, por ejemplo una hamburguesa se debera mostrar si se vendio
como hamburguesa y si se vendio un combo que esta compuesto x una hamburguesa

SE DEBERA MOSTRAR

*codigo de producto
*nombre del producto
*cantidad de facturas vendidas solo
*cantidad de facturas vendidas de los productos que compone
*cantidad de productos a los cuales compone que se vendieron

el resultado debera ser ordenado x el componente que se haya vendido solo en mas facturas

ACLARACION: se debe resolver en una sola consulta sin utilizar subconsultas en ningun lugar del select
*/


SELECT p.prod_codigo as [Codigo de producto], p.prod_detalle as [nombre del produto]
	 ,(SELECT COUNT (DISTINCT IFAC1.item_producto) FROM Item_Factura ifac1 
		INNER JOIN Producto p1 ON ifac1.item_producto = p1.prod_codigo 
		INNER JOIN Composicion c on c.comp_producto = p1.prod_codigo ) AS [facturas vendidas solos]
	--, (SELECT COUNT( *) FROM  Item_Factura ifac2	-- esta parte ne da una inseguridad de que esta MUY MAL
	--	INNER JOIN Producto p2 ON ifac2.item_producto = p2.prod_codigo 
	--	INNER JOIN Composicion c on c.comp_componente = p2.prod_codigo ) as [productos que lo componene]
	  , (SELECT COUNT(distinct f2.fact_numero+f2.fact_sucursal+f2.fact_tipo) FROM Factura f2
		INNER JOIN Item_Factura ifac2 ON ifac2.item_sucursal+ifac2.item_numero+ifac2.item_tipo =f2.fact_sucursal+f2.fact_numero+f2.fact_tipo
		INNER JOIN Producto p2 ON p2.prod_codigo = ifac2.item_producto
		WHERE p2.prod_codigo in (SELECT c1.comp_componente FROM Composicion c1)) as [ cantidad facturas de productos compuestos]
	  , (SELECT COUNT(ifac3.item_producto) FROM Item_Factura ifac3
			INNER JOIN Producto p3 ON p3.prod_codigo = ifac3.item_producto
			INNER JOIN Factura f3 ON ifac3.item_sucursal+ifac3.item_numero+ifac3.item_tipo =f3.fact_sucursal+f3.fact_numero+f3.fact_tipo
			WHERE p3.prod_codigo IN (SELECT c3.comp_producto FROM Composicion c3) as [CANTIDAD PRODUCTOS VENDIDOS COMPUESTOS]
	 FROM Producto p
	 INNER JOIN Item_Factura ifac ON p.prod_codigo = ifac.item_producto
	 INNER JOIN Factura f ON ifac.item_sucursal+ifac.item_tipo+ifac.item_numero = f.fact_sucursal+f.fact_tipo+f.fact_numero
	 ORDER BY 3 desc

select * FROM Composicion

-- ========================= FUNCION ============================

/*
Realizar una función
	Parametros:
		Tipo de factura 
		Sucursal 
	Retorno:
		Próximo número de factura consecutivo 
		en caso de que No exista ninguno informar el primero
	Consideraciones:
		El tipo de dato y formato de retorno debe coincidir con el de la tabla (Ej. '00002021').
*/

IF OBJECT_ID (N'dbo.funcionParcial', N'FN') IS NOT NULL  
    DROP FUNCTION dbo.funcionParcial;
GO

CREATE FUNCTION dbo.funcionParcial(@tipo CHAR(1), @sucursal CHAR(4))
returns CHAR(8)
AS
BEGIN
	return right('00000000'+cast((select max(fact_numero) from Factura where fact_tipo = @tipo and fact_sucursal = @sucursal)+1  as varchar(8)),8)
-- RIGHT (STRING, FUNCTION)
-- esta funcion lo que hace es que al string le aplico un casteo donde SELECCIONO 
-- EL MAXIMO NUMERO DE FACTURA DE LA TABLA FACTURA EN LA CUAL
-- DEBE SER DEL MISMO TIPO PERO NO ASI DE LA MISMA SUCURSAL
-- ACA LO QUE SE HACE ES TOMAR EL SIGUIENTE NUMERO MAXIMO, para ese TIPO y x CADA SUCURSAL
END

DROP FUNCTION funcionParcial
SELECT dbo.funcionParcial('A', '0003')
go


-- ======================== STORE PROCEDURE =======================

/*
Realizar un stored procedure que 
	Objetivo:
		Inserte un nuevo registro de factura y un ítem
	Parametros:
		Todos los datos obligatorios de las 2 tablas, la fecha y un código de depósito
	Consideraciones:
		Guardar solo los valores no nulos en ambas tablas
		Restar el stock de ese producto en la tabla correspondiente
		Se debe validar previamente la existencia del stock en ese depósito y en caso de no haber no realizar nada.
		El total de factura se calcula como el precio de ese único ítem
		Los impuestos es el 21% de dicho valor redondeado a 2 decimales.
Se debe programar una transacción para que las 3 operaciones se realicen atómicamente, se asume que todos los parámetros recibidos están validados a excepción de la cantidad del producto en stock.
Queda a criterio del alumno, que acciones tomar en caso de que no se cumpla la única validación o se produzca un error no previsto.
*/


-- mirarlo luego
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
			throw 50001,'Error: No se ha podido realizar la operación',1
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


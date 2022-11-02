USE [GD2015C1]
GO
/*
1.	Realizar una consulta SQL que retorne, para cada producto que no fue vendido en el 2012, la siguiente información:
a)	Detalle del producto.
b)	Rubro del producto.
c)	Cantidad de productos que tiene el rubro.
d)	Precio máximo de venta en toda la historia, sino tiene ventas en la historia, mostrar 0.
El resultado deberá mostrar primero aquellos productos que tienen composición.
Nota: No se permite el uso de sub-selects en el FROM ni funciones definidas por el usuario para este punto.

*/

SELECT p.prod_detalle as [detalle del producto]
	, p.prod_rubro as [rubro del producto]
	, (select count(*) FROM Producto p1	
		INNER JOIN Rubro r ON r.rubr_id = p1.prod_rubro) as [cantidad de productos que tiene el rubro]
	, max(ISNULL(ifac.item_precio,0)) as [precio maximo de la historia]
	 FROM Producto p
	 INNER JOIN Item_Factura ifac ON ifac.item_producto = p.prod_codigo
	 INNER JOIN Composicion c on c.comp_producto = p.prod_codigo
	 WHERE p.prod_codigo not in (select distinct ifac.item_producto FROM factura f 
		WHERE f.fact_numero+f.fact_sucursal+f.fact_tipo = ifac.item_numero+ifac.item_sucursal+ifac.item_tipo and year(f.fact_fecha) ='2012')
	 GROUP BY p.prod_detalle, p.prod_rubro,P.prod_codigo
	 ORDER BY (case when exists(select * from Composicion c where c.comp_producto = p.prod_codigo) then 1 else 0 end) DESC

/*
2)
Es atributo clie_limite_credito, representa el monto máximo que puede venderse a un cliente
en el mes en curso. Implementar el/los objetos necesarios para que no se permita realizar una venta si el
monto total facturado en el mes supera el atributo clie_limite_credito. Considerar que esta restricción debe 
cumplirse siempre y validar también que no se pueda hacer una factura de un mes anterior.
*/





CREATE FUNCTION total_vendido_mes(@fact_cliente char(6))
RETURNS DECIMAL(12,2)
AS

    BEGIN
 
        RETURN (select sum(f.fact_total) from Factura f
                where f.fact_cliente = @fact_cliente
                and MONTH(CURRENT_TIMESTAMP) = MONTH(f.fact_fecha)
                and YEAR(CURRENT_TIMESTAMP) = YEAR(f.fact_fecha))
    END
GO
 
--se considera que el fact_total una vez insertado no se vuelve a modificar
CREATE TRIGGER tr_check_limite_credito on Factura
instead of INSERT
AS
    BEGIN
        IF(exists(select * from inserted i where month(i.fact_fecha) != month(CURRENT_TIMESTAMP)))
            BEGIN
                RAISERROR (15599,10,1, 'No se puede facturar un mes distinto del actual');
            END
        ELSE
            BEGIN
                IF(exists(select * from inserted i join Cliente c
                            on c.clie_codigo = i.fact_cliente           --total_vendido_mes esta definido arriba
                            where c.clie_limite_credito < (i.fact_total + total_vendido_mes(i.fact_cliente)) ) )
                    BEGIN
                        RAISERROR (15600,10,1, 'La venta no puede superar el limite de credito para el cliente');
                    END
                ELSE
                    BEGIN
                        INSERT INTO Factura (fact_tipo,fact_sucursal,fact_numero,fact_fecha,fact_vendedor,fact_total,fact_total_impuestos,fact_cliente)
                        SELECT fact_tipo,fact_sucursal,fact_numero,fact_fecha,fact_vendedor,fact_total,fact_total_impuestos,fact_cliente from inserted

                    END
            END
    END
GO

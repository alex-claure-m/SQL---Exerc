USE GD2015C1;
GO
/* ej 1*/
SELECT c1.clie_codigo, 
(SELECT TOP 1 item_producto from Item_Factura join Factura on item_sucursal = fact_sucursal and item_tipo = fact_tipo and item_numero = fact_numero
 WHERE YEAR(fact_fecha) = 2012
 AND fact_cliente = c1.clie_codigo
 GROUP BY item_producto
 ORDER BY SUM(item_cantidad) DESC
 ) as 'Cod_producto',
 (SELECT TOP 1 prod_detalle from Item_Factura join Factura on item_sucursal = fact_sucursal and item_tipo = fact_tipo and item_numero = fact_numero 
											  join Producto on item_producto = prod_codigo
 WHERE YEAR(fact_fecha) = 2012
 AND fact_cliente = c1.clie_codigo
 GROUP BY prod_detalle
 ORDER BY SUM(item_cantidad) DESC
 ) as 'Nombre_producto',
 (SELECT COUNT(DISTINCT item_producto) FROM Item_Factura join Factura on item_sucursal = fact_sucursal and item_numero = fact_numero and fact_tipo = item_tipo
  WHERE YEAR(fact_fecha) = 2012
  AND fact_cliente = c1.clie_codigo) as 'Cantidad_prod_distintos_comprados',
  (SELECT COUNT(DISTINCT item_producto ) FROM Item_Factura join Factura on item_sucursal = fact_sucursal and item_numero = fact_numero and fact_tipo = item_tipo
  WHERE YEAR(fact_fecha) = 2012
  AND fact_cliente = c1.clie_codigo
  AND item_producto in (SELECT comp_producto FROM Composicion)) as 'Cantidad_prod_composición'
FROM Item_Factura i1 join Factura f1 on i1.item_tipo = f1.fact_tipo and i1.item_sucursal = f1.fact_sucursal and i1.item_numero = f1.fact_numero
					 join Cliente c1 on c1.clie_codigo = f1.fact_cliente
					 join Producto on prod_codigo = item_producto
WHERE YEAR(fact_fecha) = 2012
GROUP BY c1.clie_codigo
HAVING COUNT(DISTINCT prod_rubro) = (SELECT COUNT(*) FROM Rubro)

/*ej2*/

CREATE TRIGGER [dbo].[TR_COMPONER]
	ON [dbo].[Item_Factura]
INSTEAD OF INSERT AS
BEGIN
	DECLARE @tipo as char(1), @numero as char(8), @sucursal as char(4), @producto as char(8)
	DECLARE @precio as decimal (12, 2), @cantidad as int, @cliente as char(6), @fecha as smalldatetime
	DECLARE @producto_compuesto as char(8)
	DECLARE @cantidad_composicion as integer

	DECLARE c_items CURSOR FOR (SELECT item_tipo, item_numero, item_sucursal, item_producto, item_precio, item_cantidad, fact_cliente, fact_fecha
									  FROM Inserted JOIN Factura ON fact_tipo+fact_numero+fact_sucursal = item_tipo+item_numero+item_sucursal 
								      WHERE item_producto IN (SELECT comp_componente FROM Composicion)) -- Filtro que el item sea un componente
	OPEN c_items
	FETCH NEXT FROM compra_comp_cr INTO @tipo, @numero, @sucursal, @producto, @precio, @cantidad, @cliente, @fecha
		WHILE (@@FETCH_STATUS = 0)
		BEGIN 
			SELECT @producto_compuesto = comp_producto, @cantidad_composicion = comp_cantidad FROM Composicion WHERE comp_componente = @producto --
			SET @cantidad_composicion = @cantidad / @cantidad_composicion
			DELETE FROM Item_factura WHERE item_tipo+item_numero+item_sucursal = @tipo+@numero+@sucursal 
			SELECT @precio = SUM(item_precio) FROM Item_Factura
			 			 
			INSERT INTO Item_Factura VALUES(@fecha, @cliente, @producto_compuesto, @precio, @cantidad)
			FETCH NEXT FROM compra_comp_cr INTO @tipo, @numero, @sucursal, @producto, @precio, @cantidad, @cliente, @fecha
		END 


		 	
END 


CREATE FUNCTION dbo.cantidad_combos(DECLARE @tipo as char(1), @numero as char(8), @sucursal as char(4), @producto as char(8))
RETURN integer AS
BEGIN	
	SELECT 
END 

SELECT * FROM Composicion
ORDER BY comp_cantidad desc
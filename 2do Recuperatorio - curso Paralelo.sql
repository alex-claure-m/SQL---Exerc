USE GD2015C1;

-- Ejercicio 1 (Composicion de 1 solo nivel) 

SELECT producto.prod_codigo, producto.prod_detalle, 

ISNULL((SELECT SUM(item2.item_cantidad) FROM Composicion composicion2 
JOIN Item_Factura item2 ON item2.item_producto = composicion2.comp_componente
JOIN Factura factura ON factura.fact_numero = item2.item_numero AND factura.fact_tipo = item2.item_tipo AND factura.fact_sucursal = item2.item_sucursal
WHERE composicion2.comp_producto = producto.prod_codigo AND YEAR(factura.fact_fecha) = 2012), 0) AS 'Cantidad vendidos 2012', --por separado

ISNULL((SELECT SUM(item.item_precio*item_cantidad) FROM Item_Factura item 
WHERE item.item_producto = producto.prod_codigo),0) AS 'Total vendido producto'

FROM Producto producto 
JOIN Composicion composicion ON composicion.comp_producto = producto.prod_codigo
WHERE 

	ISNULL((SELECT COUNT(DISTINCT producto2.prod_rubro) FROM Composicion composicion3
	JOIN Producto producto2 ON producto2.prod_codigo = composicion3.comp_componente
	WHERE composicion3.comp_producto = producto.prod_codigo),0) = 2 

GROUP BY producto.prod_codigo, producto.prod_detalle
HAVING COUNT(DISTINCT composicion.comp_componente) = 3
ORDER BY 
	(SELECT COUNT(item.item_producto) FROM Item_Factura item 
	JOIN Factura factura2 ON factura2.fact_numero = item.item_numero AND factura2.fact_tipo = item.item_tipo AND factura2.fact_sucursal = item.item_sucursal
	WHERE item.item_producto = producto.prod_codigo AND YEAR(factura2.fact_fecha) = 2012) DESC  


-- Ejercicio 2 (Los datos desde un inicio estan bien)

CREATE TRIGGER tx_parcial ON Producto
AFTER INSERT AS
BEGIN TRANSACTION 
	
	DECLARE @producto_insertado CHAR(8); 
	DECLARE @rubro_producto CHAR(4);
	DECLARE @componente CHAR(8);
	DECLARE @rubro_componente CHAR(4); 

	DECLARE cursor_productos CURSOR FOR
	(SELECT inserted.prod_codigo, inserted.prod_rubro, composicion.comp_producto FROM inserted
	JOIN Composicion composicion ON composicion.comp_producto = inserted.prod_codigo)

	OPEN cursor_productos; 
	FETCH NEXT FROM cursor_productos INTO @producto_insertado, @rubro_producto, @componente; 
	
	WHILE @@FETCH_STATUS = 0 
	BEGIN 
		SELECT @rubro_componente = producto.prod_rubro FROM Producto producto
		WHERE producto.prod_codigo = @componente

		IF(@rubro_componente != @rubro_producto)
		BEGIN
			PRINT("Un componente no puede ser de otro rubro que su producto padre"); 
			ROLLBACK 
		END
		FETCH NEXT FROM cursor_productos INTO @producto_insertado, @rubro_producto, @componente; 
	END

	CLOSE cursor_productos;
	DEALLOCATE cursor_productos;

COMMIT
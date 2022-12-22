USE[GD2015C1]
GO
/* EJERCICIO 1 - SQL
realizar una consulta sql QUE PERMITA SABER LOS CLIENTES QUE COMPRARO POR ENCIMA DEL PROMEDIO DE COMPRAS(FACT_TOTAL) DE TODOS LOS CLIENTES DEL 2012

DE ESTOS CLIENTES MOSTRAR PARA EL 2012
 * EL CODIGO DEL CLIENTE
 * LA RAZON SOCIAL DEL CLIENTE
 * EL CODIGO DE PRODUCTO QUE EN CANTIDADES MAS CO,PRO
 * EL NOMBRE DEL PRODUCTO DEL PUNTO 3
 * CANTIDAD DE PRODUCTOS DISTINTOS COMPRADOS POR EL CLIENTE
 * CANTIDAD DE PRODUCTOS CON COMPOSICION COMPRADOS POR EL CLIENTE

EL RESULTADO DEBERA SER ORDENADO PONIENDO PRIMERO AQUELLOS CLIENTES QUE COMPRARON MAS DE ENTRE 5 Y 10 PRODUCTOS DISTITNSO EN EL 2012


*/


SELECT c.clie_codigo as [codigo del cliente]
	,c.clie_razon_social as [razon social del cliente]
	, (SELECT TOP 1 (ifac1.item_producto) from Item_Factura ifac1
		INNER JOIN Factura f1 ON (f1.fact_sucursal+f1.fact_numero+f1.fact_tipo=ifac1.item_sucursal+ifac1.item_numero+ifac1.item_tipo)
		WHERE f1.fact_cliente = c.clie_codigo  AND YEAR(f1.fact_fecha)= '2012'
		ORDER BY ifac1.item_producto DESC) as [codigo del producto que en cantidades mas compro]
	, (SELECT TOP 1 (p1.prod_detalle) FROM Producto p1
		INNER JOIN Item_Factura ifac2 ON ifac2.item_producto = p1.prod_codigo
		INNER JOIN factura f2 ON f2.fact_numero+f2.fact_sucursal+ f2.fact_tipo = ifac2.item_numero+ifac2.item_sucursal+ifac2.item_tipo
		WHERE YEAR(f2.fact_fecha) = '2012' AND c.clie_codigo = f2.fact_cliente) as [DETALLE DEL PRODUCTO QUE MAS EN CANTIDADES COMPRO]
	, (SELECT COUNT(distinct ifac3.item_producto) FROM Item_Factura ifac3
		INNER JOIN Factura f3 ON (f3.fact_numero+f3.fact_sucursal+f3.fact_tipo = ifac3.item_numero + ifac3.item_sucursal + ifac3.item_tipo  )
		WHERE YEAR(f3.fact_fecha)='2012' AND f3.fact_cliente = c.clie_codigo) as [CANTIDAD DE PRODUCTOS DISTITNOS COMPRADOS POR EL CLIENTE]
	,(SELECT COUNT(ifac4.item_producto) FROM Item_Factura ifac4
		INNER JOIN Factura f4 ON (f4.fact_numero+f4.fact_sucursal+f4.fact_tipo = ifac4.item_numero+ ifac4.item_sucursal+ ifac4.item_tipo )
		WHERE f4.fact_cliente = c.clie_codigo AND ifac4.item_producto IN (SELECT com.comp_producto FROM Composicion com )
		) as [CANTIDAD DE PRODUCTOS CON COMPOSICION COMPRADOS POR EL CLIENTE]
	 FROM Cliente c
	 INNER JOIN Factura f ON f.fact_cliente = c.clie_codigo
	 INNER JOIN Item_Factura ifac ON ifac.item_numero = f.fact_numero AND ifac.item_sucursal = f.fact_sucursal AND ifac.item_tipo = f.fact_tipo
	 INNER JOIN Producto p ON p.prod_codigo = ifac.item_producto
	 WHERE YEAR(f.fact_fecha) = '2012'
	 GROUP BY c.clie_codigo, c.clie_razon_social
	 HAVING AVG(f.fact_total) > (SELECT sum(f5.fact_total) FROM Factura f5
									inner join Cliente c2 ON f5.fact_cliente = c2.clie_codigo
									WHERE YEAR(f5.fact_fecha) = '2012'
									)
		

/* T - SQL 


implementar una regla de negocio de validacion en linea que permita validar el STOCK al realziarse una venta. Cada venta se debe descontar sobre el deposito 00. En caso de que se venda un producto compuesto, el descuento de stock se debe realizar por sus componentes.
si no hay STOCK para ese articulo, no se debera guardar ese articulo, pero si los otros en los cuales hay stock positivo
Es decir, solamente se deberan guardar aquellos para los cuales si hay stock, sin guardarse los que no poseen cantidades suficientes
*/

CREATE TRIGGER validacionStock ON Item_factura
AFTER INSERT, UPDATE
AS
BEGIN	
	DECLARE @deposito CHAR(2)
	DECLARE @productoCompuesto CHAR(8)
	DECLARE @producto CHAR(8)
	DECLARE @cantidadStock DECIMAL(12,2)
	DECLARE @cantidadProductoCompuesto DECIMAL(12,2)

	DECLARE cursor_validacion_stock CURSOR FOR (SELECT item_cantidad, item_producto
												FROM inserted 
												)
	OPEN cursor_validacion_stock
	FETCH NEXT FROM cursor_validacion_stock INTO @cantidadStock,@producto
	WHILE(@@FETCH_STATUS = 0)

	BEGIN
		
		SET @deposito = (SELECT d.depo_codigo FROM DEPOSITO d 
							INNER JOIN STOCK s ON s.stoc_deposito = d.depo_codigo
							WHERE d.depo_codigo = '00' AND s.stoc_producto = @producto)

		SET @cantidadStock = (SELECT stoc_cantidad FROM STOCK s
							INNER JOIN DEPOSITO d ON s.stoc_deposito = d.depo_codigo
							WHERE d.depo_codigo = '00' AND s.stoc_producto = @producto)

		SET @cantidadProductoCompuesto = (SELECT count(p.prod_codigo) FROM Producto p
										INNER JOIN Composicion c ON p.prod_codigo = c.comp_producto)

		BEGIN
			IF(@cantidadStock > 0 and @productoCompuesto = null )
				BEGIN	
					UPDATE STOCK SET stoc_cantidad = isnull(stoc_cantidad,0) - @cantidadStock
					WHERE stoc_deposito = @deposito and stoc_producto = @producto
				END
		ELSE IF (@productoCompuesto <> null)
				BEGIN
					UPDATE STOCK set stoc_cantidad = isnull(stoc_cantidad,0) - @productoCompuesto
					WHERE stoc_deposito = @deposito and stoc_producto = @productoCompuesto

		FETCH NEXT FROM cursor_validacion_stock INTO @cantidadStock, @producto
			END
	CLOSE cursor_validacion_stock
	DEALLOCATE cursor_validacion_stock

END
GO
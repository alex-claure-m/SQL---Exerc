USE[GD2015C1]
GO

/*
23)

Desarrolle el/los elementos de base de datos necesarios para que ante una venta automaticamante 
se controle que en una misma factura no puedan venderse más de dos productos con composición.
Si esto ocurre debera rechazarse la factura.


-- ANALISIS

-- ante una venta => DEBEMOS CONTROLAR QUE EN UNA MISMA FACTURA NO PUEDA VENDERSE MAS DE 2 PRODUCTOS CON COMPOSICION
-- OSEA CREAR UN TRIGGER DE EXISTENCIA POR AHI
-- TAL VEZ SI HAGO UN TRIGGER POR ITEM_FACTURA o FACTURA pero aca (EN FACTURA) deberia JOINEAR CON ITEM_FACTURA
*/
CREATE TRIGGER stsql_ejericio23 ON Item_Factura AFTER INSERT 
AS
BEGIN
	IF (SELECT COUNT(ite.item_producto) -- LA CANTIDAD DE PRODUCTOS
		FROM Item_Factura ite INNER JOIN inserted ins  -- DE LA TABLA ITEM_FACTURA joineada con LA TABLA QUE INSERTO
			ON ite.item_tipo + ite.item_sucursal + ite.item_numero = ins.item_tipo + ins.item_sucursal + ins.item_numero
		WHERE ite.item_producto IN (SELECT comp_producto FROM Composicion) ) > 2
		-- DONDE EL PRODUCTO ESTE DENTRO DEL COMPOSICION 
		-- SEA MAYOR A 2
		-- osea que encontre que un producto esta en la tabla composicion mas de 2 veces
		BEGIN
		RAISERROR('NO PUEDE HABER MAS DE DOS PRODUCTOS CON COMPOSICIÓN EN UNA MISMA FACTURA',1,1)
		ROLLBACK TRANSACTION		
	END
END
GO


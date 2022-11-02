USE [GD2015C1]
GO
/*
1. Se pide realizar una consulta sql que retorne por cada año, el cliente que mas compro (fact_total),
la canitdad de articulos distintos comprados, la cantidad de rubros distintos comprados.
Solamente se deberan mostras aquellos clientes que posean al menos 10 facturas o mas por año.
El resultado debe ser ordenado por año.
Nota: no se permite el uso de sub-selects en el FROM ni funciones definidas por el usuario para este punto.
*/

SELECT YEAR(f.fact_fecha) as [año]
	, f.fact_cliente as [cliente]
	, count (distinct(ifac.item_producto)) as [cantidad productos distintos comprados]
	, count (distinct p.prod_rubro) as [rubros distintos]
	 FROM Factura f
	 INNER JOIN Item_Factura ifac ON ifac.item_numero+ifac.item_sucursal+ifac.item_tipo = f.fact_numero+f.fact_sucursal+f.fact_tipo
	 INNER JOIN Producto p ON p.prod_codigo = ifac.item_producto
	 -- ES OTRA FORMA DE CALCULAR AL CLIENTE QUE MAYOR FACTURA TOTAL TUVO, elijo AL TOP1 cliente que su sumatoria sea la mayor
	 WHERE f.fact_cliente = (SELECT TOP 1 f1.fact_cliente FROM Factura f1
							WHERE YEAR(f1.fact_fecha) = year(f.fact_fecha)
							GROUP BY f1.fact_cliente
							ORDER BY SUM(f1.fact_total) DESC
							)

	GROUP BY year(f.fact_fecha), f.fact_cliente
	HAVING COUNT(f.fact_cliente) >= 10 -- con esto le digo que me traiga aquellos clientes que tuvieron mayor de 10 facturas
	ORDER BY YEAR(f.fact_fecha) 




/*
2. Implementar el/los objetos necesarios para la siguiente restriccion:
"Toda composicion (ej. COMBO 1) debe estar compuesta solamente por productos simples
(EJ: COMBO4 compuesto por: 4 Hamburguesas, 2 gaseosas y 2 papas). No se permitirá que un combo este compuesto por nigun otro combo."
Se sabe que en la actualidad dicha regla se cumple y que la base de datos es accedido por n aplicaciones de diferentes tipos y tecnologías.
*/


USE [GD2015C1]
GO
CREATE TRIGGER TR_COMPOSICION ON Composicion
AFTER INSERT, UPDATE
AS
    BEGIN TRANSACTION
    IF(EXISTS(SELECT 1 FROM inserted i WHERE EXISTS(SELECT 1 FROM Composicion c WHERE c.comp_producto = i.comp_componente)))
        BEGIN
            RAISERROR('Las composiciones deben estar compuestas por productos simples', 1, 1)
            ROLLBACK
            RETURN
        END
    COMMIT TRANSACTION
GO

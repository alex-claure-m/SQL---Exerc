USE [GD2015C1]
GO


/*
ENUNCIADO 2018

1) Se necesita saber que productos no son vendidos durante el 2018 y cuáles sí. La consulta debe mostrar:
a) código de producto
b) Nombre de producto
c) Fue vendido (si o no) según el caso
d) cantidad de componentes
EL resultado debe ser ordenado por cantidad total vendida
Nota: no se permite el uso de sub-selects en el FROM ni funciones definidas por el usuario
Aclaracion: se realiza con la base de práctica de la cátedra, en lugar de 2018 se puede usar otro año para testearla

2) implementar el/los objetos necesarios para mantener siempre actualizado al instante ante cualquier evento el campo fact_total de la tabla Factura
Nota: se sabe que actualmente el campo fact_total presenta esta propiedad

*/


SELECT p.prod_codigo as [codigo de producto]
	, p.prod_detalle as [nombre del producto] 
	, (CASE WHEN(ifac.item_producto) IS NOT NULL THEN 'SI' ELSE 'NO' END) as [FUE VENDIDO] -- NO ME GUSTA PARA NADA ESTA PARTE!!!!
	, ISNULL((SELECT COUNT(c.comp_componente) FROM Composicion c WHERE c.comp_producto = p.prod_codigo) ,0) AS [CANTIDAD DE COMPONENTES]
	 FROM Producto p
	 INNER JOIN Item_Factura ifac ON p.prod_codigo = ifac.item_producto
	 INNER JOIN Factura f ON f.fact_numero+f.fact_sucursal+f.fact_tipo = ifac.item_numero+ifac.item_sucursal+ifac.item_tipo
	 GROUP BY p.prod_codigo,p.prod_detalle,IFAC.item_producto
	 ORDER BY sum(f.fact_total) DESC






	 SELECT count (distinct(p.prod_codigo))FROM Item_Factura ifac
	 inner join Producto p on p.prod_codigo = item_producto
	 INNER JOIN Factura f ON f.fact_numero+f.fact_sucursal+f.fact_tipo = ifac.item_numero+ifac.item_sucursal+ifac.item_tipo



SELECT p.prod_codigo, p.prod_detalle as 'nombre',

ISNULL((SELECT COUNT(c.comp_producto) FROM [GD2015C1].[dbo].Composicion c WHERE c.comp_producto = p.prod_codigo),0) as 'Cantidad componentes',

'Vendido' AS 'Producto', SUM(it.item_cantidad) as cant_vendida

FROM [GD2015C1].[dbo].Producto p
INNER JOIN [GD2015C1].[dbo].Item_Factura it ON it.item_producto = p.prod_codigo
INNER JOIN [GD2015C1].[dbo].Factura f ON f.fact_numero = it.item_numero AND f.fact_sucursal = it.item_sucursal AND f.fact_tipo = it.item_tipo
where YEAR(f.fact_fecha) = 2018
GROUP BY p.prod_codigo, p.prod_detalle
UNION ALL
SELECT p.prod_codigo, p.prod_detalle as 'nombre',

ISNULL((SELECT COUNT(c.comp_producto) FROM [GD2015C1].[dbo].Composicion c WHERE c.comp_producto = p.prod_codigo),0) as 'Cantidad componentes',

'No Vendido' AS 'Producto',0 as cant_vendida

FROM [GD2015C1].[dbo].Producto p
where p.prod_codigo not in (SELECT p.prod_codigo
FROM [GD2015C1].[dbo].Producto p
INNER JOIN [GD2015C1].[dbo].Item_Factura it ON it.item_producto = p.prod_codigo
INNER JOIN [GD2015C1].[dbo].Factura f ON f.fact_numero = it.item_numero AND f.fact_sucursal = it.item_sucursal AND f.fact_tipo = it.item_tipo
where YEAR(f.fact_fecha) = 2018)
GROUP BY p.prod_codigo, p.prod_detalle
order by 5 desc








CREATE TRIGGER tr_totalFactura ON ItemFactura
AFTER INSERT, UPDATE, DELETE
AS
    BEGIN TRANSACTION
DECLARE @fact decimal (12,2)
DECLARE @importe decimal (12,2)

DECLARE mi_cursor cursor for
SELECT (ITEM_CANTIDAD * ITEM_PRECIO),ITEM_NUMERO FROM
INSERTED GROUP BY ITEM_NUMERO
UNION SELECT (-1* (ITEM_CANTIDAD * ITEM_PRECIO)),ITEM_NUMERO FROM
DELETED GROUP BY ITEM_NUMERO
OPEN mi_cursor
FETCH NEXT mi_cursor into @importe,@fact
WHILE @@FETCH_STATUS =0
BEGIN 
UPDATE FACTURA
SET FACT_TOTAL=FACT_TOTAL+@importe
WHERE
FACT_NUMERO=@fact (aca faltaba preguntar por los otros PK que eran tipo y sucursal[/offtopic])
FETCH NEXT mi_cursor into @importe,@fact
END
CLOSE mi_cursor
DEALLOCATE mi_cursor

        COMMIT TRANSACTION
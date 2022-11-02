USE[GD2015C1]
GO


/*
ENUNCIADO 2017

REALIZAR UNA CONSULTA SQL QUE RETORNE, PARA CADA PRODUCTO CON MAS DE 2 ARTICULOS DISTINTOS EN SU COMPOSICION LA SIGUIENTE INFORMACION

- DETALLE DEL PRODUCTIO
- RUBRO DEL PRODUCTO
- CANTIDAD DE VECES QUE FUE VENDIDO

EL RESULTADO SE DEBERA MOSTRAR ORDENADO POR LA CANTIDAD DE PRODUCTOS QUE LA COMPONEN
*/

SELECT p.prod_detalle as [detalle del producto]
	, r.rubr_detalle  [rubro del producto]
	, (SELECT COUNT(*) FROM Item_Factura ifac WHERE P.prod_codigo = IFAC.item_producto
		) AS [CANTIDAD DE VECES VENDIDA]
	 FROM Producto p
	 INNER JOIN Rubro r ON p.prod_rubro = r.rubr_id
	 WHERE p.prod_codigo IN  (select c.comp_producto from composicion c group by c.comp_producto having count(comp_componente) > 2) 
	 -- este es el chicle nuevo, en el cual el codigo del producto tiene que etar en la compisicion y que este compuesto x mas de 2 componentes
	 order by (select sum(comp_cantidad) from composicion where comp_producto = p.prod_codigo) desc
/*
2)
AGREGAR EL/LOS OBJETOS NECESARIOS PARA QUE SE PERMITA MANTENER LA SIGUIENTE RESTRICCION
- NUNCA UN JEFE VA A PODER TENER MAS DE 20 PERSONAS A CARGO Y MENOS DE 1
NOTA: CONSIDERAR SOLO 1 NIVEL DE LA RELACION EMPLEADO-JEFE
*/
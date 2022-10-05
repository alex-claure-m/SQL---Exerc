

--SEGUN EL PROFE

SELECT compuesto.prod_detalle, compuesto.prod_precio, CAST(SUM(componente.prod_precio*c.comp_cantidad) AS decimal(12,2)) AS 'Precio Total'FROM Composicion c JOIN Producto compuesto ON c.comp_producto=compuesto.prod_codigo					JOIN Producto componente ON c.comp_componente=componente.prod_codigoGROUP BY compuesto.prod_detalle, compuesto.prod_precioHAVING SUM(c.comp_cantidad)>2ORDER BY SUM(c.comp_cantidad) DESC

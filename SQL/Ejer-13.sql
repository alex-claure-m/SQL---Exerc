

--SEGUN EL PROFE

SELECT compuesto.prod_detalle, compuesto.prod_precio, CAST(SUM(componente.prod_precio*c.comp_cantidad) AS decimal(12,2)) AS 'Precio Total'
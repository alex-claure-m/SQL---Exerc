USE[GD2015C1]
GO

/*
21)
Escriba una consulta sql que retorne para todos los años, en los cuales se haya hecho al 
menos una factura, la cantidad de clientes a los que se les facturo de manera incorrecta 
al menos una factura y que cantidad de facturas se realizaron de manera incorrecta. 
Se 
considera que una factura es incorrecta cuando la diferencia entre el total de la factura 
menos el total de impuesto tiene una diferencia mayor a $ 1 respecto a la sumatoria de 
los costos de cada uno de los items de dicha factura. Las columnas que se deben mostrar 
son:
	Año
	Clientes a los que se les facturo mal en ese año
	Facturas mal realizadas en ese año
*/

/*
Escriba una consulta sql que retorne para todos los años, en los cuales se haya hecho al 
menos una factura
-- CREO QUE LO QUE QUIERE DECIR ES QUE RETORNE AQUELLOS QUE AL MENOS TUVIERON UNA VENTA UNA VEZ AL AÑO*/
SELECT YEAR(f.fact_fecha) as [Anio]
		, COUNT(DISTINCT f.fact_cliente) as [cantidad de clientes que se les facturo mal]
		, COUNT(DISTINCT fact_tipo + fact_sucursal + fact_numero) as [factura mal realizadas]
		 FROM Factura f
		 WHERE (f.fact_total-f.fact_total_impuestos) - 
				(SELECT SUM(ifac.item_cantidad * ifac.item_precio) 
					FROM Item_Factura ifac
					WHERE ifac.item_numero = f.fact_numero AND ifac.item_sucursal = f.fact_sucursal AND f.fact_tipo = ifac.item_tipo
					 ) > 1
		-- ES MEDIO TOSCO, PERO ES OTRA FORMA DE OBTENER LA CANTIDAD DE FACTURAS
		-- YA QUE EN ESTE CASO LE DIGO QUE IFAC.NUMERO, IFAC.SUCURSAL E IFAC.TIPO SEA IGUAL A F.TIPO, F.SUCURSAL ...ETC
		-- POR QUE DEPENDE DE QUE SEAN IGUALES ES DONDE DEBO RESTARLE LA FACTURA TOTAL - LOS IMPUESTOS
		-- PARA ASI VER QUE SEAN > 1


		 /* NOT BETWEEN ( -- aclara que debo devolver aquelals facturas que 
						SELECT SUM(ifac.item_precio * ifac.item_cantidad) + 1  
						FROM Item_Factura ifac
						INNER JOIN factura f1 ON ifac.item_numero = f1.fact_numero AND ifac.item_sucursal = f1.fact_sucursal AND f1.fact_tipo = ifac.item_tipo
						)		
						AND
						(SELECT SUM(ifac.item_precio * ifac.item_cantidad) - 1  
						FROM Item_Factura ifac
						INNER JOIN factura f1 ON ifac.item_numero = f1.fact_numero AND ifac.item_sucursal = f1.fact_sucursal AND f1.fact_tipo = ifac.item_tipo
						)	
		*/
		GROUP BY YEAR(f.fact_fecha)


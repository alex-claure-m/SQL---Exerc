USE[GD2015C1]
GO

/*
SQL
1-Desarrolle una consulta que muestre para cada empleado que no tenga gente a cargo el indice de productividad
periodo x periodo (periodo x periodo implica periodo mensual A�OMES).

Dicho indice es el porcentaje respecto a la cantidad de facturas que vendio ese vendedor en el periodo respecto
al periodo en el que mas facturas vendio (en el periodo en que mas facturas vendio es %100).
  I.  Codigo de empleado
 II.  Nombre y apellido
III.  Periodo (AAAAMM)
 IV.  indice de productividad
  V.  Periodo de referencia (periodo en el que mas vendi historico)
El resultado debe ser ordenado por la edad del empleado de manera descendente y periodo ascendente.
No se puede utilizar subselect en el FROM
*/

SELECT e.empl_codigo as [codigo de empleado]
	,e.empl_nombre + ' ' + e.empl_apellido as [nombre y apellido]
	, CONCAT( YEAR(f.fact_fecha) , RIGHT(CONCAT('0', MONTH(f.fact_fecha)), 2)) as Periodo
	-- CONCATENO AÑO , MES -> pero antepongo el RIGHT debido a que si no le pongo nada me tira un aaaaMes (mes=1,mes =2 ..etc)
	-- y yo busco que me devuelva 01,02,03..etc
	, COUNT(*) * 100 / (SELECT TOP 1 COUNT(f1.fact_sucursal+f1.fact_numero+f1.fact_tipo) FROM factura f1
		WHERE f1.fact_vendedor =e.empl_codigo) as [INDICE DE PRODUCTIVIDAD]
	-- EL INDICE es el % RESPECTO A LA CANTIDAD (COUNT) de facturas  (este como esta joineado con FACTURA A UN EMPLEADO - FUNCA)
	-- RESPECTO el que mas factura vendio -> TOP 1 
	,  (SELECT TOP 1 CONCAT( YEAR(f2.fact_fecha) , RIGHT(CONCAT('0', MONTH(f2.fact_fecha)), 2))
		FROM Factura f2 
		WHERE e.empl_codigo=f2.fact_vendedor
		GROUP BY YEAR(f2.fact_fecha),MONTH(f2.fact_fecha)
		ORDER BY COUNT(*) DESC) AS Periodo_Referencia
	-- periodo en el que mas vendio historiccamente -- OSEA EL TOP 1 EN PERIODO
	-- para eso hago un factura f2 y busco al empleado en cuestion y lo ordeno de forma DESCENDIENTE
	 FROM Empleado e
	 INNER JOIN Factura f ON f.fact_vendedor = e.empl_codigo
	 GROUP BY e.empl_codigo, e.empl_nombre+' '+e.empl_apellido, YEAR(f.fact_fecha), MONTH(f.fact_fecha)



/*
	 
2-Cree el/los objetos de bases de datos necesarios para que automAticamente se cumpla la siguiente regla de
negocio "Ninguna factura puede contener mAs de 12 Items".
La regla en la actualidad se cumple. No se conoce la forma de acceso a los datos ni el procedimiento por el
cual se emiten las mismas.

-- crear objeto para que cumpla : NINGUNA FACTURA DEBE CONTENER MAS DE 12 ITEMS

*/
/*PARA CADA ITEM INSERTADO, HAY QUE VERIFICAR QUE SU FACTURA NO CONTIENE MAS DE 12 ITEMS*/
IF EXISTS(SELECT name FROM sys.objects WHERE name='trig_facturaNegocio12Items')
DROP TRIGGER trig_facturaNegocio12Items
GO


CREATE TRIGGER trig_facturaNegocio12Items ON Item_factura
AFTER INSERT, UPDATE
AS
	BEGIN -- pregunto que si existe alguna tabla en el que TUVO ITEMS INSERTADOS con los mismos DATOS de la tabla Item_factura..
		IF EXISTS(SELECT * FROM Item_Factura ifac 
					JOIN inserted ins ON
					ifac.item_numero = ins.item_numero
					AND ifac.item_sucursal = ins.item_sucursal
					AND ifac.item_tipo = ins.item_tipo
				GROUP BY  ifac.item_sucursal,ifac.item_tipo,ifac.item_numero
				HAVING COUNT (DISTINCT ifac.item_producto)>12 -- y que al ser insertados, fueron hecho 12 veces del mismo producto
						)
				BEGIN
					RAISERROR('ESTE PRODUCTO TIENE 12 ITEMS ',1,1)
					ROLLBACK
					RETURN
				END
		END














IF EXISTS(SELECT name FROM sysobjects WHERE name='trigger_12_items_factura')
DROP TRIGGER trigger_12_items_factura
GO

CREATE TRIGGER trigger_12_items_factura ON Item_Factura FOR INSERT, UPDATE
AS
BEGIN
	--sin cursores
	IF EXISTS(--si al menos una factura cumple que:
	SELECT *
	-- 1.a todos los items de las facturas con items insertados...
	FROM Item_Factura ite JOIN inserted ins 
				ON  ite.item_numero=ins.item_numero 
				AND ite.item_sucursal=ins.item_sucursal 
				AND ite.item_tipo=ins.item_tipo
				/*esto seria una tabla de todos los items de las facturas que tuvieron items insertados,
				est� llena de repetidos ya que cada item de una factura
				aparece n veces por las n inserciones que se hicieron ahi,
				pero al aplicar distinct en el count se arregla todo*/
	--2. se los agrupa por factura...
	GROUP BY ite.item_sucursal , ite.item_tipo, ite.item_numero
	--3. y se toman los grupos con mas de 12 items
	HAVING COUNT (DISTINCT ite.item_producto)>12
	)
	BEGIN
		RAISERROR('Error: se intentaron insertar mas de 12 items en una factura',1,1)
		ROLLBACK TRANSACTION
		RETURN
	END


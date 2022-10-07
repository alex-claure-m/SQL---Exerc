USE[GD2015C1]
GO

/*
20)

Escriba una consulta sql que retorne un ranking de los mejores 3 empleados del 2012
Se debera retornar legajo, nombre y apellido, anio de ingreso, puntaje 2011, puntaje 
2012. El puntaje de cada empleado se calculara de la siguiente manera: para los que 
hayan vendido al menos 50 facturas el puntaje se calculara como la cantidad de facturas 
que superen los 100 pesos que haya vendido en el año, para los que tengan menos de 50
facturas en el año el calculo del puntaje sera el 50% de cantidad de facturas realizadas 
por sus subordinados directos en dicho año
*/


SELECT TOP 3 e.empl_codigo as [legajo empleado]
	, e.empl_nombre as [nombre empleado]
	, e.empl_apellido as [apellido empleado]
	, e.empl_ingreso as [anio de ingreso]
	, CASE
		WHEN (SELECT COUNT(f.fact_vendedor) FROM Factura f WHERE e.empl_codigo = f.fact_vendedor AND YEAR(f.fact_fecha) = '2011' ) >= 50 -- analizo condicion que debe ser un empleado que vendio y en el 2011 por el puntaje y que tenga 50 ventas
		THEN (SELECT COUNT(*) FROM Factura f WHERE f.fact_total > 100 AND e.empl_codigo = f.fact_vendedor AND YEAR(f.fact_fecha) = '2011') -- cuento que lo que facturo sea > 100
		ELSE (SELECT COUNT(*) * 0.5 FROM Factura f WHERE f.fact_vendedor IN (SELECT e.empl_codigo FROM Empleado e WHERE empl_jefe = empl_codigo) AND YEAR(f.fact_fecha)= '2011') -- sino facturo > 100 , el puntaje sea el 0.5 de las facturas realizadas
		END 'PUNTAJE 2012' -- SON 2 CASOS LO CUAL DEBERIA ANALIZARSE DE DISTINTA MANERA
	 FROM Empleado e


SELECT C.fact_cliente FROM Factura C
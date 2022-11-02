USE[GD2015C1]
GO

/*
ENUNCIADO 2-07-22

REALIZAR UNA CONSULTA SQL QUE DEVUELVA LOS CLIENTES QUE NO TUVIERON FACTURACION MAXIMA Y LA FACTURACION MINIMA EN EL 2012
DE ESTOS CLIENTES SE DEBE MOSTRAR
*el numero de orden: asignando 1 al cliente de mayor venta y N el de menor venta. Entiendase N como el numero correspondiente
al que menos vendio en el 2012. Entiendase venta como total facturado
*codigo de cliente
*el monto total comprado en el 2012
*la cantidad de unidades de productos comprados en el 2012

*/
-- EL PROBLEMA ES cuando digo ASIGNO 1 al cliente de mayor venta ... tambien hablamos del 2012?
SELECT---(SELECT COUNT(*) FROM Factura f1
		--INNER JOIN Cliente c ON c.clie_codigo = f1.fact_cliente
		--ORDER BY f1.fact_total DESC )  as [NUMERO DE ORDEN]
	(SELECT isnull(sum(f2.fact_total),0) FROM Factura f2
		WHERE YEAR(F2.fact_fecha) = '2012') AS [MONTO TOTAL DEL 2012]
	,(SELECT count(IFAC.item_producto) FROM Item_Factura IFAC 
		INNER JOIN Factura f3 ON f3.fact_sucursal+f3.fact_tipo+f3.fact_numero = ifac.item_sucursal+ifac.item_tipo+ifac.item_numero
		WHERE YEAR(f3.fact_fecha) = '2012') as [unidades totales comprados en 2012]
	FROM Factura f
	GROUP BY f.fact_cliente


	-- OTRA FORMA!!!
	-- ME GUSTA ESTA VERSION PERO AUN ASI ME FALTA ARREGLAR LA PRIEMRA PARTE DE LA CONSULT

SELECT---(SELECT COUNT(*) FROM Factura f1
		--INNER JOIN Cliente c ON c.clie_codigo = f1.fact_cliente
		--ORDER BY f1.fact_total DESC )  as [NUMERO DE ORDEN]
	ISNULL((f.fact_total),0) AS [MONTO TOTAL DEL 2012]
	, ifac.item_cantidad as [unidades totales comprados en 2012]
	FROM Factura f
	INNER JOIN Item_Factura ifac ON f.fact_sucursal+f.fact_tipo+f.fact_numero = ifac.item_sucursal+ifac.item_tipo+ifac.item_numero 
	WHERE YEAR(f.fact_fecha) = '2012'
	GROUP BY f.fact_total, ifac.item_cantidad




-- ==================== TSQL ================

/*
SUPONIENDO QUE SE APLICAN LOS SIGUIENTES CAMBIOS EN EL MODELO DE DATOS

CAMBIO 1) CREATE TABLE PROVINCIA (ID INT PRIMARY KEY, NOMBRE CHAR(100))
CAMBIO 2) ALTER TABLE CLIENTE ADD PCIA_ID INT NULL

CREE EL/LOS OBJETOS NECESARIOS PARA IMPLEMENTAR EL CONCEPTO DE FK ENTRE 2 CLIENTE PROVINCIA

NOTA: NO SE PERMITE AGREGAR UNA CONSTRAINT DE TIPO FK ENTRE LA TABLA Y EL CAMPO AGREGADO
*/


CREATE TABLE provincia(
	id INT primary key identity,
	nombre CHAR(100)
	)


create table cliente_add(
	pcia_id INT
	)
alter table cliente
Add FOREIGN KEY (pcia_id) REFERENCES provincia.id


USE[GD2015C1]
GO

/*
5)
Realizar un procedimiento que complete con los datos existentes en el modelo provisto la tabla de hechos denominada 
Fact_table tiene las siguiente definición:
		Create table Fact_table
			( anio char(4),
			mes char(2),
			familia char(3),
			rubro char(4),
			zona char(3),
			cliente char(6),
			producto char(8),
			cantidad decimal(12,2),
			monto decimal(12,2)
			)
			Alter table Fact_table
			Add constraint primary key(anio,mes,familia,rubro,zona,cliente,producto)
*/

IF OBJECT_ID ('Fact_table','U') IS NOT NULL 
    DROP TABLE Fact_table;  
GO

CREATE TABLE Fact_table
			( anio char(4) NOT NULL, -- ANIO SEGUN FACTURA
			mes char(2) NOT NULL,	-- MES SEGUN FACTURA 
			familia char(3) NOT NULL, -- de la tabla familia o producto.familia (a elegir)
			rubro char(4) NOT NULL,	-- de la tabla rubro o producto.rubro
			zona char(3) NOT NULL, -- de la tabla zona o depa.zona o depo.zona (mirar cual conviene mas)
			cliente char(6) NOT NULL, -- del cliente o fac.cliente
			producto char(8) NOT NULL, -- del producto o item.producto
			cantidad decimal(12,2) NOT NULL, -- de item.cantidad (xq la tabla se llama Fact_table)
			monto decimal(12,2) NOT NULL -- no se si recalcular item.cantidad * item.precio o de fact.total - ver cual tomar
			)
	Alter table Fact_table
	Add constraint pk_Fact_table_ID primary key(anio,mes,familia,rubro,zona,cliente,producto)
GO

IF OBJECT_ID (N'dbo.ejer5_tsql', N'FN') IS NOT NULL 
    DROP PROCEDURE dbo.ejer5_tsql;  
GO
CREATE PROCEDURE ejer5_tsql
AS
BEGIN
	INSERT INTO Fact_table 
		SELECT YEAR(f.fact_fecha),
			   MONTH(f.fact_fecha),
			   p.prod_familia ,
			   p.prod_rubro,
			   d.depa_zona,
			   f.fact_cliente,
			   p.prod_codigo,
			   sum(ifac.item_cantidad),
			   sum(f.fact_total)
			    FROM Factura f
				INNER JOIN Item_Factura ifac ON ifac.item_numero+ifac.item_tipo+ifac.item_sucursal = f.fact_numero+f.fact_tipo+f.fact_sucursal
				INNER JOIN Producto p ON p.prod_codigo = ifac.item_producto
				INNER JOIN Empleado e ON e.empl_codigo = f.fact_vendedor
				INNER JOIN Departamento d ON d.depa_codigo = e.empl_departamento
				GROUP BY year(f.fact_fecha), MONTH(f.fact_fecha),p.prod_familia,p.prod_rubro,d.depa_zona,f.fact_cliente,p.prod_codigo
END
GO
/* ***************************************** FORMA 1 ********************************************************
IF OBJECT_ID('Fact_table','U') IS NOT NULL 
DROP TABLE Fact_table
GO
Create table Fact_table
(
anio char(4) NOT NULL, --YEAR(fact_fecha)
mes char(2) NOT NULL, --RIGHT('0' + convert(varchar(2),MONTH(fact_fecha)),2)
familia char(3) NOT NULL,--prod_familia
rubro char(4) NOT NULL,--prod_rubro
zona char(3) NOT NULL,--depa_zona
cliente char(6) NOT NULL,--fact_cliente
producto char(8) NOT NULL,--item_producto
cantidad decimal(12,2) NOT NULL,--item_cantidad
monto decimal(12,2)--asumo que es item_precio debido a que es por cada producto, 
				   --asumo tambien que el precio ya esta determinado por total y no por unidad (no debe multiplicarse por cantidad)
)
Alter table Fact_table
Add constraint pk_Fact_table_ID primary key(anio,mes,familia,rubro,zona,cliente,producto)
GO

IF OBJECT_ID('Ejercicio5','P') IS NOT NULL
DROP PROCEDURE Ejercicio5
GO

CREATE PROCEDURE Ejercicio5
AS
BEGIN
	INSERT INTO Fact_table
	SELECT YEAR(fact_fecha)
		,RIGHT('0' + convert(varchar(2),MONTH(fact_fecha)),2)
		,prod_familia
		,prod_rubro
		,depa_zona
		,fact_cliente
		,prod_codigo
		,SUM(item_cantidad)
		,sum(item_precio)
	FROM Factura F
		INNER JOIN Item_Factura IFACT
			ON IFACT.item_tipo =f.fact_tipo AND IFACT.item_sucursal = F.fact_sucursal AND IFACT.item_numero = F.fact_numero
		INNER JOIN Producto P
			ON P.prod_codigo = IFACT.item_producto
		INNER JOIN Empleado E
			ON E.empl_codigo = F.fact_vendedor
		INNER JOIN Departamento D
			ON D.depa_codigo = E.empl_departamento
	GROUP BY YEAR(fact_fecha)
		,RIGHT('0' + convert(varchar(2),MONTH(fact_fecha)),2)
		,prod_familia
		,prod_rubro
		,depa_zona
		,fact_cliente
		,prod_codigo
END
GO

*/


/* ********************************** FORMA 2 ************************************************************
IF OBJECT_ID('Fact_table','U') IS NOT NULL 
DROP TABLE Fact_table
GO
Create table Fact_table
(
anio char(4) NOT NULL, --YEAR(fact_fecha)
mes char(2) NOT NULL, --RIGHT('0' + convert(varchar(2),MONTH(fact_fecha)),2)
familia char(3) NOT NULL,--prod_familia
rubro char(4) NOT NULL,--prod_rubro
zona char(3) NOT NULL,--depa_zona
cliente char(6) NOT NULL,--fact_cliente
producto char(8) NOT NULL,--item_producto
cantidad decimal(12,2) NOT NULL,--item_cantidad
monto decimal(12,2)--asumo que es item_precio debido a que es por cada producto, 
				   --asumo tambien que el precio ya esta determinado por total y no por unidad (no debe multiplicarse por cantidad)
)
Alter table Fact_table
Add constraint pk_Fact_table_ID primary key(anio,mes,familia,rubro,zona,cliente,producto)
GO

IF OBJECT_ID('llenar_fact_table','P') IS NOT NULL
DROP PROCEDURE llenar_fact_table
GO

CREATE PROCEDURE llenar_fact_table
AS
BEGIN
	INSERT INTO Fact_table 
	SELECT YEAR(fact_fecha)
		  ,RIGHT('0' + convert(varchar(2),MONTH(fact_fecha)),2)
		  ,prod_familia
		  ,prod_rubro
		  ,depa_zona
		  ,fact_cliente
		  ,item_producto
		  ,sum(item_cantidad)
		  ,sum(item_precio)
	FROM Factura
		 JOIN Item_Factura
			ON fact_sucursal = item_sucursal
			AND fact_tipo = item_tipo
			AND fact_numero=item_numero
		 JOIN Producto ON item_producto=prod_codigo
		 JOIN Empleado ON fact_vendedor=empl_codigo
		 JOIN Departamento ON empl_departamento=depa_codigo
	GROUP BY  YEAR(fact_fecha)
			  ,RIGHT('0' + convert(varchar(2),MONTH(fact_fecha)),2)
			  ,prod_familia
			  ,prod_rubro
			  ,depa_zona
			  ,fact_cliente
			  ,item_producto
END
GO

*/
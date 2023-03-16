USE[GD2C2022]
GO

-- =========== BORRADO GENERAL =============================

IF (EXISTS (SELECT * FROM sys.schemas WHERE name = 'GDD_2022_007')) 
BEGIN

-------- Dropeamos las tablas en caso de que ya existieran
	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'BI_Fact_venta_descuento')) 
		DROP TABLE GDD_2022_007.BI_Fact_venta_descuento
	
	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'BI_Fact_ventaxproducto')) 
		DROP TABLE GDD_2022_007.BI_Fact_ventaxproducto

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'BI_Fact_envios')) 
		DROP TABLE GDD_2022_007.BI_Fact_envios

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'BI_Fact_venta')) 
		DROP TABLE GDD_2022_007.BI_Fact_venta

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'BI_Fact_compraxproducto')) 
		DROP TABLE GDD_2022_007.BI_Fact_compraxproducto

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'BI_Fact_compra_proveedorprecio')) 
		DROP TABLE GDD_2022_007.BI_Fact_compra_proveedorprecio

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'BI_Dim_proveedor')) 
		DROP TABLE GDD_2022_007.BI_Dim_proveedor	

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'BI_Dim_venta_tipodescuento')) 
		DROP TABLE GDD_2022_007.BI_Dim_venta_tipodescuento		
	
	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'BI_Dim_canal_venta')) 
		DROP TABLE GDD_2022_007.BI_Dim_canal_venta

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'BI_Dim_venta_mediopago')) 
		DROP TABLE GDD_2022_007.BI_Dim_venta_mediopago

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'BI_Dim_medio_envio')) 
		DROP TABLE GDD_2022_007.BI_Dim_medio_envio
	
	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'BI_Dim_provincia')) 
		DROP TABLE GDD_2022_007.BI_Dim_provincia

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'BI_Dim_rango_etario')) 
		DROP TABLE GDD_2022_007.BI_Dim_rango_etario

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'BI_Dim_Tiempo')) 
		DROP TABLE GDD_2022_007.BI_Dim_Tiempo
	
	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'BI_Dim_producto')) 
		DROP TABLE GDD_2022_007.BI_Dim_producto

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'BI_Dim_categoria')) 
		DROP TABLE GDD_2022_007.BI_Dim_categoria

-------- Dropeamos los store procedure en caso de que ya existieran
	IF OBJECT_ID('GDD_2022_007.Carga_BI_Dim_categoria', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_BI_Dim_categoria

	IF OBJECT_ID('GDD_2022_007.Carga_BI_Dim_producto', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_BI_Dim_producto

	IF OBJECT_ID('GDD_2022_007.Carga_BI_Dim_Tiempo', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_BI_Dim_Tiempo

	IF OBJECT_ID('GDD_2022_007.Carga_BI_Dim_rango_etario', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_BI_Dim_rango_etario

	IF OBJECT_ID('GDD_2022_007.Carga_BI_Dim_provincia', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_BI_Dim_provincia

	IF OBJECT_ID('GDD_2022_007.Carga_BI_Dim_medio_envio', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_BI_Dim_medio_envio

	IF OBJECT_ID('GDD_2022_007.Carga_BI_Dim_venta_mediopago', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_BI_Dim_venta_mediopago

	IF OBJECT_ID('GDD_2022_007.Carga_BI_Dim_canal_venta', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_BI_Dim_canal_venta

	IF OBJECT_ID('GDD_2022_007.Carga_BI_Dim_venta_tipodescuento', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_BI_Dim_venta_tipodescuento

	IF OBJECT_ID('GDD_2022_007.Carga_BI_Dim_proveedor', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_BI_Dim_proveedor

	IF OBJECT_ID('GDD_2022_007.Carga_BI_Fact_Venta', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_BI_Fact_Venta

	IF OBJECT_ID('GDD_2022_007.Carga_BI_Fact_Ventaxproducto', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_BI_Fact_Ventaxproducto

	IF OBJECT_ID('GDD_2022_007.Carga_BI_Fact_venta_descuento', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_BI_Fact_venta_descuento

	IF OBJECT_ID('GDD_2022_007.Carga_BI_Fact_envios', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_BI_Fact_envios

	IF OBJECT_ID('GDD_2022_007.Carga_BI_Fact_Compraxproducto', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_BI_Fact_Compraxproducto

	IF OBJECT_ID('GDD_2022_007.Carga_BI_Fact_Compra_proveedorprecio', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_BI_Fact_Compra_proveedorprecio

	IF OBJECT_ID('GDD_2022_007.Carga_De_Datos_BI', 'P') IS NOT NULL
		DROP PROCEDURE GDD_2022_007.Carga_De_Datos_BI

-------- Dropeamos las vistas en caso de que ya existieran
	IF OBJECT_ID('GDD_2022_007.BI_V_Ganancias_mensualesxcanaldeventa', 'V') IS NOT NULL
		DROP VIEW GDD_2022_007.BI_V_Ganancias_mensualesxcanaldeventa

	IF OBJECT_ID('GDD_2022_007.BI_V_Productos_Mayor_Rentabilidad_anual', 'V') IS NOT NULL
		DROP VIEW GDD_2022_007.BI_V_Productos_Mayor_Rentabilidad_anual

	IF OBJECT_ID('GDD_2022_007.BI_V_Categoria_masvendidaxrangoetario_mensual', 'V') IS NOT NULL
		DROP VIEW GDD_2022_007.BI_V_Categoria_masvendidaxrangoetario_mensual

	IF OBJECT_ID('GDD_2022_007.BI_V_Ingresos_mediopago_mensual', 'V') IS NOT NULL
		DROP VIEW GDD_2022_007.BI_V_Ingresos_mediopago_mensual

	IF OBJECT_ID('GDD_2022_007.BI_V_Descuentos_por_tipo_canal_mes', 'V') IS NOT NULL
		DROP VIEW GDD_2022_007.BI_V_Descuentos_por_tipo_canal_mes

	IF OBJECT_ID('GDD_2022_007.BI_V_Envios_por_provincia_mes', 'V') IS NOT NULL
		DROP VIEW GDD_2022_007.BI_V_Envios_por_provincia_mes

	IF OBJECT_ID('GDD_2022_007.BI_V_AVG_Valor_Envio_Provincia_Anual', 'V') IS NOT NULL
		DROP VIEW GDD_2022_007.BI_V_AVG_Valor_Envio_Provincia_Anual

	IF OBJECT_ID('GDD_2022_007.BI_V_Productos_Mayor_Reposicion_Por_Cantidad', 'V') IS NOT NULL
		DROP VIEW GDD_2022_007.BI_V_Productos_Mayor_Reposicion_Por_Cantidad

	IF OBJECT_ID('GDD_2022_007.BI_V_AVG_Aumento_Proveedor_Anual', 'V') IS NOT NULL
		DROP VIEW GDD_2022_007.BI_V_AVG_Aumento_Proveedor_Anual

END


/* =================================== CREACIÓN TABLAS DE DIMENSIONES =========================================================*/
--Categoría
CREATE TABLE GDD_2022_007.BI_Dim_categoria(
id BIGINT PRIMARY KEY NOT NULL,
nombre NVARCHAR(255)
)


/*Decisión de diseño: Decidimos representar los productos en forma directa, omitiendo sus diferentes variantes, ya que el requerimiento no especifica dicha necesidad
Se decidió mantener los id originales de las tablas como PK para simplificar la migración de datos sin necesidad de generar nuevos, ya que la estrategia de relación de tablas se mantuvo.
*/

--Producto
CREATE TABLE GDD_2022_007.BI_Dim_producto(
id BIGINT PRIMARY KEY NOT NULL,
nombre NVARCHAR(50),
codigo NVARCHAR(50) UNIQUE,
descripcion NVARCHAR(50)
)


--TIEMPO  
CREATE TABLE GDD_2022_007.BI_Dim_Tiempo(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
anio int,
mes int
)


--RANGO ETARIO
CREATE TABLE GDD_2022_007.BI_Dim_rango_etario(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
rango NVARCHAR(10) UNIQUE,
minimo decimal(18,4) NULL,
maximo decimal(18,4) NULL
)


--provincia
CREATE TABLE GDD_2022_007.BI_Dim_provincia(
id BIGINT PRIMARY KEY NOT NULL,
nombre NVARCHAR(255) 
)


--medio_envio
CREATE TABLE GDD_2022_007.BI_Dim_medio_envio(
id BIGINT PRIMARY KEY NOT NULL,
envio NVARCHAR(255) 
)

--venta_mediopago
CREATE TABLE GDD_2022_007.BI_Dim_venta_mediopago(
id BIGINT PRIMARY KEY NOT NULL, 
medio_pago NVARCHAR(255) 
)


--canal_venta
CREATE TABLE GDD_2022_007.BI_Dim_canal_venta(
id BIGINT PRIMARY KEY NOT NULL,
canal NVARCHAR(2255) 
)

/* Esta tabla posee sus propia PK, ya que se encarga de concentrar los distintos tipos de descuento de distintas fuentes: Medios de pago, cupones, envios, etc  */
CREATE TABLE GDD_2022_007.BI_Dim_venta_tipodescuento(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
concepto NVARCHAR(255) 
)

/*proveedor*/
CREATE TABLE GDD_2022_007.BI_Dim_proveedor(
id BIGINT PRIMARY KEY NOT NULL,
razon_social NVARCHAR(50)
)

/* =================================== CREACIÓN TABLAS DE HECHOS =========================================================
Si bien inicialmente se analizó la posibilidad de emplear un modelo copo de nieve, el cual nos ahorraría espacio de almacenamiento, ya que eliminaríamos la redundancia de datos, optamos
por adoptar una estrategia del tipo estrella, de manera tal de lograr un diseño mas simple y evitando la utilización de multiples joins en nuestras consultas, lo cual nos haría obtener una mejor performance
en las mismas.
Por otro lado, como requerimiento, se solicitaba tener algunas dimensiones en caracter obligatorio, por lo cual optamos por mantener una estrategia de normalizado de datos para items como por ejemplo
producto, categoría, provincia, etc, donde también vemos como ventaja el ahorro significativo de espacio debido al volumen de datos persistidos, aunque esto implique cierta perdida de performance
*/


/*Creamos una tabla de hechos de envíos que concentre todos los envíos realizados, segmentado por fecha, medio de envío y provincia de destino. De esta manera, podremos armar la totalidad de las vistas 
requeridas, reduciendo la cantidad de datos.
Para los precios persistimos la sumatoria total, ya que luego haremos un promedio. Si hubiesemos persistido el precio promedio en lugar del total, luego en las vistas deberíamos
volver a calcular un promedio pero agrupando por provincias, lo cual equivaldría a un promedio de promedios, por lo cual el valor se distorcionaría*/
CREATE TABLE GDD_2022_007.BI_Fact_envios(
id_tiempo BIGINT   NOT NULL,
id_medio_envio BIGINT   NOT NULL, 
id_provincia BIGINT   NOT NULL,
cantidad INT,
envio_precio_Total DECIMAL(18,2)
 ) 

ALTER TABLE GDD_2022_007.BI_Fact_envios
ADD FOREIGN KEY (id_tiempo) REFERENCES GDD_2022_007.BI_Dim_Tiempo(id);

ALTER TABLE GDD_2022_007.BI_Fact_envios
ADD FOREIGN KEY (id_medio_envio) REFERENCES GDD_2022_007.BI_Dim_medio_envio(id);

ALTER TABLE GDD_2022_007.BI_Fact_envios
ADD FOREIGN KEY (id_provincia) REFERENCES GDD_2022_007.BI_Dim_provincia(id);

ALTER TABLE GDD_2022_007.BI_Fact_envios ADD CONSTRAINT PK_BI_Fact_envios PRIMARY key (id_tiempo,id_medio_envio,id_provincia) 
GO

/*La tabla BI_Fact_Venta concentra los totales de ingresos y los costos asociados a la venta, se los independizó de la venta de productos para evitar redundancia, reducir la cantidad de datos a cargar,
mejorando posteriormente la performance de nuestras consultas y simplificando el armado de las vistas, respetando la arquitectura del modelo*/ 
CREATE TABLE GDD_2022_007.BI_Fact_venta(
id_tiempo BIGINT   NOT NULL,
id_canalVenta BIGINT   NOT NULL,  -- FK 
id_medioPago BIGINT  NOT NULL,  -- FK 
mediopago_costo DECIMAL(18,2) NOT NULL,
canal_costo DECIMAL(18,2),
subtotal DECIMAL(18,2) ) 

ALTER TABLE GDD_2022_007.BI_Fact_venta
ADD FOREIGN KEY (id_tiempo) REFERENCES GDD_2022_007.BI_Dim_Tiempo(id);

ALTER TABLE GDD_2022_007.BI_Fact_venta
ADD FOREIGN KEY (id_canalVenta) REFERENCES GDD_2022_007.BI_Dim_canal_venta(id);

ALTER TABLE GDD_2022_007.BI_Fact_venta
ADD FOREIGN KEY (id_medioPago) REFERENCES GDD_2022_007.BI_Dim_venta_mediopago(id);

ALTER TABLE GDD_2022_007.BI_Fact_venta ADD CONSTRAINT PK_BI_Fact_venta PRIMARY key (id_tiempo,id_canalVenta,id_medioPago) 
GO

/*Decidimos crear una tabla de hechos de Ventas por productos agrupando por tiempo, rango etario, producto y categoria, de manera tal de obtener la granularidad mímina y necesaria para realizar las vistas requeridas,
por lo cual ganaremos en performance debido a que la cantidad de datos a analizar es menor. Almacenamos los subtotales ya calculados para mejorar posteriormente la performance de las consultas a dicha tabla
Respecto a la categoría, al utilizar un modelo estrella, decidimos separarla en un campo más, evitando acceder a la misma a través dimensión productos, y generando una relación directa con la dimensión de categorías */ 
CREATE TABLE GDD_2022_007.BI_Fact_ventaxproducto(
id_tiempo BIGINT  NOT NULL,
id_rangoetario BIGINT  NOT NULL,
id_producto BIGINT  NOT NULL,
id_categoria BIGINT  NOT NULL,
cantidad DECIMAL (18,0),
subtotal DECIMAL(18,2)
)

ALTER TABLE GDD_2022_007.BI_Fact_ventaxproducto
ADD FOREIGN KEY (id_producto) REFERENCES GDD_2022_007.BI_Dim_producto(id);

ALTER TABLE GDD_2022_007.BI_Fact_ventaxproducto
ADD FOREIGN KEY (id_tiempo) REFERENCES GDD_2022_007.BI_Dim_tiempo(id);

ALTER TABLE GDD_2022_007.BI_Fact_ventaxproducto
ADD FOREIGN KEY (id_rangoetario) REFERENCES GDD_2022_007.BI_Dim_rango_etario(id);

ALTER TABLE GDD_2022_007.BI_Fact_ventaxproducto
ADD FOREIGN KEY (id_categoria) REFERENCES GDD_2022_007.BI_Dim_categoria(id);

ALTER TABLE GDD_2022_007.BI_Fact_ventaxproducto ADD CONSTRAINT PK_BI_Fact_ventaxproducto PRIMARY key (id_tiempo,id_rangoetario,id_producto,id_categoria) 
GO

/* Para modelar los descuentos, agrupo en una unica tabla de hecho los distintos descuentos, ya sean por medio de pago, cupones u otros. Se agrupa por los campos necesarios para el armado de vistas.*/ 
CREATE TABLE GDD_2022_007.BI_Fact_venta_descuento(
id_tiempo BIGINT NOT NULL,
id_canalVenta BIGINT NOT NULL,   
id_medioPago BIGINT NOT NULL,   
id_ventatipodescuento BIGINT  NOT NULL, 
importe DECIMAL(18,2)
)
ALTER TABLE GDD_2022_007.BI_Fact_venta_descuento
ADD FOREIGN KEY (id_tiempo) REFERENCES GDD_2022_007.BI_Dim_tiempo(id);

ALTER TABLE GDD_2022_007.BI_Fact_venta_descuento
ADD FOREIGN KEY (id_ventatipodescuento) REFERENCES GDD_2022_007.BI_Dim_venta_tipodescuento(id);

ALTER TABLE GDD_2022_007.BI_Fact_venta_descuento
ADD FOREIGN KEY (id_canalVenta) REFERENCES GDD_2022_007.BI_Dim_canal_venta(id);

ALTER TABLE GDD_2022_007.BI_Fact_venta_descuento
ADD FOREIGN KEY (id_medioPago) REFERENCES GDD_2022_007.BI_Dim_venta_mediopago(id);

ALTER TABLE GDD_2022_007.BI_Fact_venta_descuento ADD CONSTRAINT PK_BI_Fact_venta_descuento PRIMARY key (id_tiempo,id_canalVenta,id_medioPago,id_ventatipodescuento) 
GO

/* Generamos una unica tabla de compras por producto agrupando solo por producto y fecha, que necesitaremos posteriormente para el armado de las vistas, reduciendo al mínimo los campos y registros, 
logrando mayor eficiencia a la hora de la carga de datos y posterior armado de consultas.
Almacenamos los subtotales ya calculados para mejorar posteriormente la performance de las consultas a dicha tabla*/
CREATE TABLE GDD_2022_007.BI_Fact_compraxproducto(
id_producto BIGINT  NOT NULL,  
id_tiempo BIGINT  NOT NULL,
cantidad DECIMAL (18,0),
subtotal DECIMAL(18,2)
)

ALTER TABLE GDD_2022_007.BI_Fact_compraxproducto
ADD FOREIGN KEY (id_producto) REFERENCES GDD_2022_007.BI_Dim_producto(id);

ALTER TABLE GDD_2022_007.BI_Fact_compraxproducto
ADD FOREIGN KEY (id_tiempo) REFERENCES GDD_2022_007.BI_Dim_Tiempo(id);

ALTER TABLE GDD_2022_007.BI_Fact_compraxproducto ADD CONSTRAINT PK_BI_Fact_compraxproducto PRIMARY key (id_producto,id_tiempo) 
GO

/*Creamos una tabla de hechos para registrar los máximos y minimos de precios de cada producto segmentado por proveedor a lo largo del tiempo, para posteriormente,
 agrupando por la unidad de tiempo deseada y proveedor, calcular el aumento promedio de precios. Para ello,
 relacionamos esta tabla a la dimensión Proveedor, de manera tal de poder identificar de forma correcta la razon social del proveedor. 
 */
CREATE TABLE GDD_2022_007.BI_Fact_compra_proveedorprecio(
id_producto BIGINT  NOT NULL, -- FK 
id_tiempo BIGINT  NOT NULL,
id_proveedor BIGINT NOT NULL,
precio_minimo DECIMAL (18,2),
precio_maximo DECIMAL(18,2)
)

ALTER TABLE GDD_2022_007.BI_Fact_compra_proveedorprecio
ADD FOREIGN KEY (id_producto) REFERENCES GDD_2022_007.BI_Dim_producto(id);

ALTER TABLE GDD_2022_007.BI_Fact_compra_proveedorprecio
ADD FOREIGN KEY (id_tiempo) REFERENCES GDD_2022_007.BI_Dim_Tiempo(id);

ALTER TABLE GDD_2022_007.BI_Fact_compra_proveedorprecio
ADD FOREIGN KEY (id_proveedor) REFERENCES GDD_2022_007.BI_Dim_Proveedor(id);

ALTER TABLE GDD_2022_007.BI_Fact_compra_proveedorprecio ADD CONSTRAINT PK_BI_Fact_compra_proveedorprecio PRIMARY key (id_producto,id_tiempo, id_proveedor) 
GO

/* =================== CARGA DE DATOS ====================*/
CREATE PROCEDURE GDD_2022_007.Carga_BI_Dim_categoria
AS
BEGIN

	INSERT INTO GDD_2022_007.BI_Dim_categoria
	(id,
	nombre
	)
	SELECT DISTINCT
	id,nombre FROM GDD_2022_007.categoria

END
GO


CREATE PROCEDURE GDD_2022_007.Carga_BI_Dim_producto
AS
BEGIN

	INSERT INTO GDD_2022_007.BI_Dim_producto
	(id,
	nombre,
	codigo,
	descripcion
	)
	SELECT DISTINCT id, nombre, codigo, descripcion FROM GDD_2022_007.producto

END
GO

/* Para crear la dimensión de tiempo, tomo las posibles fechas en las que hubo compras y ventas y las normalizo. El UNION se encarga automaticamente de quitar los duplicados, con 
lo cual me garantizo que no habrá problemas de consistencia*/
CREATE PROCEDURE GDD_2022_007.Carga_BI_Dim_Tiempo
AS
BEGIN


	INSERT INTO GDD_2022_007.BI_Dim_Tiempo
	(
	anio,
	mes
	)
	SELECT DISTINCT year(fecha) anio, cast(CONVERT(nvarchar(6), fecha, 112) as int) mes
	FROM GDD_2022_007.compra
	UNION
	SELECT DISTINCT year(fecha) anio, cast(CONVERT(nvarchar(6), fecha, 112) as int) mes
	FROM GDD_2022_007.venta

END
GO

CREATE PROCEDURE GDD_2022_007.Carga_BI_Dim_rango_etario
AS
BEGIN

	INSERT INTO GDD_2022_007.BI_Dim_rango_etario (rango,minimo,maximo) VALUES ('<25',0,24.9999)
	INSERT INTO GDD_2022_007.BI_Dim_rango_etario (rango,minimo,maximo) VALUES ('25 - 35',25,34.9999)
	INSERT INTO GDD_2022_007.BI_Dim_rango_etario (rango,minimo,maximo) VALUES ('35 - 55',35,55)
	INSERT INTO GDD_2022_007.BI_Dim_rango_etario (rango,minimo,maximo) VALUES ('>55',55.0001,NULL)

END
GO


CREATE PROCEDURE GDD_2022_007.Carga_BI_Dim_provincia
AS
BEGIN

	INSERT INTO GDD_2022_007.BI_Dim_provincia
	(id,
	nombre
	)
	SELECT DISTINCT
	id,nombre FROM GDD_2022_007.provincia

END
GO


CREATE PROCEDURE GDD_2022_007.Carga_BI_Dim_medio_envio
AS
BEGIN

	INSERT INTO GDD_2022_007.BI_Dim_medio_envio
	(id,
	envio
	)
	SELECT DISTINCT
	id,envio FROM GDD_2022_007.medio_envio

END
GO

CREATE PROCEDURE GDD_2022_007.Carga_BI_Dim_venta_mediopago
AS
BEGIN

	INSERT INTO GDD_2022_007.BI_Dim_venta_mediopago
	(id,
	medio_pago
	
	)
	SELECT DISTINCT
	id,
	medio_pago FROM GDD_2022_007.venta_mediopago

END
GO


CREATE PROCEDURE GDD_2022_007.Carga_BI_Dim_canal_venta
AS
BEGIN

	INSERT INTO GDD_2022_007.BI_Dim_canal_venta
	(id,
	canal
	)
	SELECT DISTINCT
	id,canal FROM GDD_2022_007.canal_venta

END
GO


/* Decidimos generar una tabla de dimensiones que concentre los distintos tipos de descuento, cumpliento con los requerimientos mínimos.
Dado que los cupones y envíos no se encontraban incluídos en los conceptos de descuentos homologados en la tabla Venta_tipodescuento, 
decidimos anexarlos manualmente a la misma, normalizando de esta manera los distintos tipos de descuento.*/
CREATE PROCEDURE GDD_2022_007.Carga_BI_Dim_venta_tipodescuento
AS
BEGIN

	INSERT INTO GDD_2022_007.BI_Dim_venta_tipodescuento
	(concepto)
	SELECT DISTINCT
	concepto FROM GDD_2022_007.venta_descuentos

	INSERT INTO GDD_2022_007.BI_Dim_venta_tipodescuento VALUES ('Cupón')

END
GO

/*Se genera una dimensión de proveedores para poder identificar de forma clara 
posteriormente el nombre de los mismos al momento de representar el aumento de precios promedio de cada uno de ellos*/
CREATE PROCEDURE GDD_2022_007.Carga_BI_Dim_proveedor
AS
BEGIN

	INSERT INTO BI_Dim_proveedor(
	id,
	razon_social
	)
	SELECT DISTINCT id, razon_social 
	FROM GDD_2022_007.proveedor 
END
GO
--================================================ CARGA DE HECHOS ==================================================
/*
Decidimos mantener las mismas PK entre las tablas del modelo transanccional y el dimensional, de forma tal de mantener la consistencia entre datos al momento de realizar la carga de los mismos,
y evitando realizar busquedas de nuevas PK que resuelten en consultas más costosas.
*/


CREATE PROCEDURE GDD_2022_007.Carga_BI_Fact_Venta
AS
BEGIN

INSERT INTO GDD_2022_007.BI_Fact_Venta
	(id_tiempo,
	id_canalVenta,  
	id_medioPago,  
	mediopago_costo,
	canal_costo,
	subtotal)
	SELECT 
		   t.id,
		   v.id_canalVenta,
		   v.id_medioPago,
		   sum(mediopago_costo),
		   sum(v.canal_costo),
		   ( select sum(vxp2.subtotal) from GDD_2022_007.ventaxproducto vxp2
								  join GDD_2022_007.venta v2 on v2.id = vxp2.id_venta
									where v2.id_canalVenta = v.id_canalVenta and v2.id_medioPago = v.id_medioPago and YEAR(v2.fecha) = t.anio and t.mes = cast(CONVERT(nvarchar(6), v2.fecha, 112) as int) ) 
	FROM GDD_2022_007.venta v
	JOIN GDD_2022_007.BI_Dim_Tiempo t on t.anio = YEAR(v.fecha) and t.mes = cast(CONVERT(nvarchar(6), v.fecha, 112) as int) 
	group by  t.id,
		   t.anio,
		   t.mes,
		   v.id_canalVenta,
		   v.id_medioPago
END
GO

CREATE PROCEDURE GDD_2022_007.Carga_BI_Fact_Ventaxproducto
AS
BEGIN

	INSERT INTO GDD_2022_007.BI_Fact_ventaxproducto(
		id_tiempo,
		id_rangoetario,
		id_producto,
		id_categoria,
		cantidad,
		subtotal
	)
	SELECT t.id, 
		  re.id,
		  pxv.id_producto,
		  cat.id,
		 sum(vxp.cantidad) Cantidad,
		  sum(vxp.cantidad * vxp.precio) subtotal
	FROM GDD_2022_007.ventaxproducto vxp
	JOIN GDD_2022_007.productoxvariante pxv on vxp.id_productoxvariante = pxv.id
	JOIN GDD_2022_007.producto pro on pro.id = pxv.id_producto
	JOIN GDD_2022_007.categoria cat on cat.id = pro.id_categoria
	JOIN GDD_2022_007.venta v on v.id = vxp.id_venta
	JOIN GDD_2022_007.BI_Dim_Tiempo t on t.anio = YEAR(v.fecha) and t.mes = cast(CONVERT(nvarchar(6), v.fecha, 112) as int) 
	JOIN GDD_2022_007.cliente cli on cli.id = v.id_cliente
	JOIN GDD_2022_007.localidad loc on loc.id = cli.id_localidad
	JOIN GDD_2022_007.BI_Dim_rango_etario re on ( (DATEDIFF(DAY,cli.fecha_nacimiento,v.fecha) / 365.00) between re.minimo and re.maximo)  /*Para calcular el rango etario, tomamos la fecha de la venta, que indica la edad de la persona al momento de la compra*/
												OR  ((DATEDIFF(DAY,cli.fecha_nacimiento,v.fecha) / 365.00) >= re.minimo AND re.maximo is null) 
	group by t.id,
		    re.id,
		  pxv.id_producto,
		  cat.id

END
GO

/*La tabla de hechos de descuentos, concentra todos los tipos de descuentos, ya sean por medio de pago, cupones, u otros. La categoría Otros incluye los envios bonificados y los descuentos especiales */
CREATE PROCEDURE GDD_2022_007.Carga_BI_Fact_venta_descuento
AS
BEGIN

/*Cargo los descuentos por medios de pago y otros, los cuales se encuentran almacenados en la tabla venta_descuentos*/
	INSERT INTO GDD_2022_007.BI_Fact_venta_descuento(
	id_tiempo,
	id_canalVenta,  -- FK 
	id_medioPago,  -- FK 
	id_ventatipodescuento, -- FK 
	importe
	)
	SELECT  t.id
			,v.id_canalVenta
			,v.id_medioPago
			,td.id
		   ,sum(vd.importe)
	FROM GDD_2022_007.venta v
	JOIN GDD_2022_007.venta_descuentos vd on vd.id_venta = v.id
	JOIN GDD_2022_007.BI_Dim_venta_tipodescuento td on td.concepto = vd.concepto
	JOIN GDD_2022_007.BI_Dim_Tiempo t on t.anio = YEAR(v.fecha) and t.mes = cast(CONVERT(nvarchar(6), v.fecha, 112) as int) 
	group by t.id
			,v.id_canalVenta
			,v.id_medioPago
			,td.id
		

/*Cargo los descuentos pertenecientes a cupones */
	INSERT INTO GDD_2022_007.BI_Fact_venta_descuento(
	id_tiempo,
	id_canalVenta,  -- FK 
	id_medioPago,  -- FK 
	id_ventatipodescuento, -- FK 
	importe
	)
	SELECT t.id
			,v.id_canalVenta
			,v.id_medioPago
		   ,td.id
		   ,sum(cxv.importe)
	FROM GDD_2022_007.venta v
	JOIN GDD_2022_007.cuponxventa cxv on cxv.id_venta = v.id
	JOIN GDD_2022_007.BI_Dim_venta_tipodescuento td on td.concepto = 'Cupón'
	JOIN GDD_2022_007.BI_Dim_Tiempo t on t.anio = YEAR(v.fecha) and t.mes = cast(CONVERT(nvarchar(6), v.fecha, 112) as int) 
	group by t.id
			,v.id_canalVenta
			,v.id_medioPago
		    ,td.id
	
END
GO


CREATE PROCEDURE GDD_2022_007.Carga_BI_Fact_envios
AS
BEGIN
	INSERT INTO GDD_2022_007.BI_Fact_envios
	(
	id_tiempo,
	id_medio_envio,-- FK 
	id_provincia,
	cantidad,
	envio_precio_Total
	)SELECT 
		   t.id,
		   v.id_medio_envio,
			loc.id_provincia,
		   count(*),
		   sum(v.envio_precio) 
	FROM GDD_2022_007.venta v
	JOIN GDD_2022_007.cliente cli on cli.id = v.id_cliente
	JOIN GDD_2022_007.localidad loc on loc.id = cli.id_localidad
	JOIN GDD_2022_007.BI_Dim_Tiempo t on t.anio = YEAR(v.fecha) and t.mes = cast(CONVERT(nvarchar(6), v.fecha, 112) as int) 
	group by   t.id,
		   v.id_medio_envio,
			loc.id_provincia
END
GO

CREATE PROCEDURE GDD_2022_007.Carga_BI_Fact_Compraxproducto
AS
BEGIN

	INSERT INTO GDD_2022_007.BI_Fact_Compraxproducto(
	id_producto, -- FK 
	id_tiempo,
	cantidad,
	subtotal
	)
	SELECT pxv.id_producto,
		   t.id,
		   sum(cxp.cantidad),
		   sum(cxp.cantidad * cxp.precio)
	FROM GDD_2022_007.compraxproducto cxp
	JOIN GDD_2022_007.compra c on c.id = cxp.id_compra
	JOIN GDD_2022_007.productoxvariante pxv on cxp.id_productoxvariante = pxv.id
	JOIN GDD_2022_007.producto pro on pro.id = pxv.id_producto
	JOIN GDD_2022_007.BI_Dim_Tiempo t on t.anio = YEAR(c.fecha) and t.mes = cast(CONVERT(nvarchar(6), c.fecha, 112) as int) 
	GROUP BY pxv.id_producto,
		   t.id

END
GO


CREATE PROCEDURE GDD_2022_007.Carga_BI_Fact_Compra_proveedorprecio
AS
BEGIN

	INSERT INTO GDD_2022_007.BI_Fact_compra_proveedorprecio(
	id_producto, -- FK 
	id_tiempo,
	id_proveedor,
	precio_minimo,
	precio_maximo
	)
	SELECT pxv.id_producto,
		   t.id,
		   prov.id,
		   min(cxp.precio),
		   max(cxp.precio)
	FROM GDD_2022_007.compraxproducto cxp
	JOIN GDD_2022_007.compra c on c.id = cxp.id_compra
	JOIN GDD_2022_007.proveedor prov on prov.id = c.id_proveedor
	JOIN GDD_2022_007.productoxvariante pxv on cxp.id_productoxvariante = pxv.id
	JOIN GDD_2022_007.producto pro on pro.id = pxv.id_producto
	JOIN GDD_2022_007.BI_Dim_Tiempo t on t.anio = YEAR(c.fecha) and t.mes = cast(CONVERT(nvarchar(6), c.fecha, 112) as int) 
	GROUP BY pxv.id_producto,
		   t.id,
		   prov.id

END
GO

--================================================ EJECUCION CARGA DE DATOS =========================================

CREATE PROCEDURE GDD_2022_007.Carga_De_Datos_BI
AS
BEGIN

	EXEC GDD_2022_007.Carga_BI_Dim_categoria
	EXEC GDD_2022_007.Carga_BI_Dim_producto
	EXEC GDD_2022_007.Carga_BI_Dim_Tiempo
	EXEC GDD_2022_007.Carga_BI_Dim_rango_etario
	EXEC GDD_2022_007.Carga_BI_Dim_provincia
	EXEC GDD_2022_007.Carga_BI_Dim_medio_envio
	EXEC GDD_2022_007.Carga_BI_Dim_venta_mediopago
	EXEC GDD_2022_007.Carga_BI_Dim_canal_venta
	EXEC GDD_2022_007.Carga_BI_Dim_venta_tipodescuento
	EXEC GDD_2022_007.Carga_BI_Dim_proveedor

	EXEC GDD_2022_007.Carga_BI_Fact_Venta
	EXEC GDD_2022_007.Carga_BI_Fact_Ventaxproducto
	EXEC GDD_2022_007.Carga_BI_Fact_venta_descuento
	EXEC GDD_2022_007.Carga_BI_Fact_envios
	EXEC GDD_2022_007.Carga_BI_Fact_Compraxproducto
	EXEC GDD_2022_007.Carga_BI_Fact_Compra_proveedorprecio
END
GO

EXEC GDD_2022_007.Carga_De_Datos_BI
GO


----================================================ ARMADO DE VISTAS =========================================
/* A raiz de aclaración realizada en el foro, tomamos las ventas, las agrupamos por canal y mes, y le restamos las compras realizadas ese mes. Dado que no estamos filtrando por los productos en las compras,
ni contamos con cierta trazabilidad para saber qué producto se utilizó en cada venta, nos encontraremos con ganancias negativas.
Para la venta, totamos el total de la venta, que ya posee incluídos los distintos descuentos.*/


CREATE VIEW GDD_2022_007.BI_V_Ganancias_mensualesxcanaldeventa
AS
SELECT cv.canal,
	   t.mes,
	   SUM(v.subtotal) -
	   SUM(v.mediopago_costo) -
	   (select  SUM (subtotal) subtotal
		from GDD_2022_007.BI_Fact_compraxproducto 
		where id_tiempo = v.id_tiempo)  ganancias
	
FROM GDD_2022_007.BI_Dim_canal_venta cv
JOIN GDD_2022_007.BI_Fact_venta v ON v.id_canalventa = cv.id
JOIN GDD_2022_007.BI_Dim_Tiempo t ON t.id = v.id_tiempo
GROUP BY 	 cv.canal,  t.mes, v.id_tiempo
GO


CREATE VIEW GDD_2022_007.BI_V_Productos_Mayor_Rentabilidad_anual
AS

SELECT anio, descripcion, Rentabilidad
FROM
(SELECT ROW_NUMBER() OVER(partition by r.anio order by r.rentabilidad desc) id, R.anio, R.descripcion, R.Rentabilidad FROM 
(SELECT  t.anio ,pro.descripcion, 
	CASE WHEN SUM(vxp.subtotal) <> 0 THEN
		((SUM(vxp.subtotal) -	(select  SUM (subtotal) subtotal from GDD_2022_007.BI_Fact_compraxproducto c where 
							c.id_producto = pro.id AND
							EXISTS(SELECT 1 FROM GDD_2022_007.BI_Dim_Tiempo where anio = t.anio AND id = c.id_tiempo  )))
		/ SUM(vxp.subtotal)) * 100
	ELSE 0 
	END Rentabilidad
FROM  GDD_2022_007.BI_Fact_ventaxproducto vxp
JOIN GDD_2022_007.BI_Dim_producto pro on pro.id = vxp.id_producto
JOIN GDD_2022_007.BI_Dim_Tiempo t ON t.id = vxp.id_tiempo
GROUP BY t.anio, pro.descripcion, pro.id) AS R) AS Result
where id <= 5

GO


/*Buscamos las 5 categorías que más ventas tuvieron por mes*/ 
CREATE VIEW GDD_2022_007.BI_V_Categoria_masvendidaxrangoetario_mensual
AS

Select mes, rango, nombre as categoria, vendidos
FROM
(SELECT ROW_NUMBER() OVER(partition by t.mes,re.rango order by sum(vxp.cantidad) desc) posicion, 
		t.mes,
		re.rango,
		cat.nombre,
		sum(vxp.cantidad) vendidos --La cantidad no es solicitada especificamente, pero decidimos mantenerlo.
FROM  GDD_2022_007.BI_Fact_ventaxproducto vxp
JOIN GDD_2022_007.BI_Dim_Tiempo t ON t.id = vxp.id_tiempo
JOIN GDD_2022_007.BI_Dim_rango_etario re on re.id = vxp.id_rangoetario
JOIN GDD_2022_007.BI_Dim_categoria cat on cat.id = vxp.id_categoria
GROUP BY t.mes, re.rango, cat.nombre ) as CategoriasMasVendidas
WHERE posicion <= 5

GO


--Total de Ingresos por cada medio de pago por mes 
CREATE VIEW GDD_2022_007.BI_V_Ingresos_mediopago_mensual
AS
SELECT DISTINCT  t.mes,
		mp.medio_pago,
		ISNULL(
		sum(V.subtotal)   --Monto vendido bruto
		-sum(mediopago_costo)  --Costos por Medio de Pago
		-(SELECT isnull(sum(vd.importe),0)	--Descuentos por medio de pagos aplicados a las ventas de ese periodo y medio de pago
			FROM GDD_2022_007.BI_Fact_venta_descuento vd
			JOIN GDD_2022_007.BI_Dim_venta_tipodescuento td on td.id = vd.id_ventatipodescuento	 
				WHERE EXISTS(SELECT 1 FROM GDD_2022_007.BI_Dim_venta_mediopago where medio_pago = td.concepto) --Valido que el tipo de descuento pertenezca a los medios de pago.
				AND vd.id_tiempo = t.id and vd.id_medioPago = mp.id	),0)  --Valido que la venta pertenezca al medio de pago y mes
		AS TotalIngresos
FROM  GDD_2022_007.BI_Dim_venta_mediopago mp  --Partimos de los distintos medios de pago para que en caso de que alguno no haya vendido nada, se muestre de todas maneras.
LEFT JOIN GDD_2022_007.BI_Fact_venta v on mp.id = v.id_medioPago
JOIN GDD_2022_007.BI_Dim_Tiempo t ON t.id = v.id_tiempo
group by t.mes, mp.medio_pago, t.id, mp.id

GO


--Importe total en descuentos aplicados según su tipo de descuento
CREATE VIEW GDD_2022_007.BI_V_Descuentos_por_tipo_canal_mes
AS
SELECT t.mes,
	   cv.canal,		 
	   td.concepto,
	   sum(vd.importe) importe
FROM GDD_2022_007.BI_Fact_venta_descuento vd
JOIN GDD_2022_007.BI_Dim_Tiempo t ON t.id = vd.id_tiempo
JOIN GDD_2022_007.BI_Dim_canal_venta cv on cv.id = vd.id_canalVenta
JOIN GDD_2022_007.BI_Dim_venta_tipodescuento td on  td.id = vd.id_ventatipodescuento
GROUP BY t.mes, cv.canal, td.concepto

GO

--Porcentaje de envíos realizados a cada Provincia por mes.
CREATE VIEW GDD_2022_007.BI_V_Envios_por_provincia_mes
AS
SELECT distinct t.mes,
	   p.nombre,
	   sum( cast(e.cantidad as decimal(18,2)))
   /
	  (select sum(cantidad) from GDD_2022_007.BI_Fact_envios where id_tiempo = e.id_tiempo) 
	 * 100 
	    AS EnviosProvincia --envios totales 
FROM  GDD_2022_007.BI_Fact_envios e 
JOIN GDD_2022_007.BI_Dim_Tiempo t ON t.id = e.id_tiempo
JOIN GDD_2022_007.BI_Dim_provincia p on p.id = e.id_provincia
group by t.mes,
	   p.nombre,
	   e.id_tiempo
GO


--Valor promedio de envío por Provincia por Medio De Envío, anual.
CREATE VIEW GDD_2022_007.BI_V_AVG_Valor_Envio_Provincia_Anual   
AS
SELECT distinct t.anio,
	   p.nombre,
	   me.envio,
	   case when SUM(e.cantidad) > 0  --Validamos que la cantidad sea mayor a 0 como protección para evitar divisiones por 0
		THEN sum(e.envio_precio_Total) / SUM(e.cantidad)
	   ELSE 0 
	   END ASCostoPromedio
FROM  GDD_2022_007.BI_Fact_envios e 
JOIN GDD_2022_007.BI_Dim_Tiempo t ON t.id = e.id_tiempo
JOIN GDD_2022_007.BI_Dim_provincia p on p.id = e.id_provincia
JOIN GDD_2022_007.BI_Dim_medio_envio me on me.id = e.id_medio_envio
group by t.anio,
	   p.nombre,
	   me.envio
GO



-- Aumento promedio de precios de cada proveedor anual
CREATE VIEW GDD_2022_007.BI_V_AVG_Aumento_Proveedor_Anual
AS
/*Armamos un subselect que nos devuelva los precios máximos y minimos por producto en el año, 
y con esta información calculamos el aumento de cada producto, y lo promediamos agrupando por proveedor y anio*/
SELECT anio, razon_social , AVG( (precioMaximo - precioMinimo) / precioMinimo * 100  ) AumentoPorcentual
FROM
(SELECT t.anio, p.razon_social, id_producto, MAX(cpp.precio_maximo) precioMaximo, MIN(cpp.precio_minimo) precioMinimo  
FROM GDD_2022_007.BI_Fact_compra_proveedorprecio cpp
JOIN GDD_2022_007.BI_Dim_proveedor P ON P.id = cpp.id_proveedor
JOIN GDD_2022_007.BI_Dim_Tiempo t ON t.id = cpp.id_tiempo
group by t.anio, p.razon_social, id_producto) AS Compras
group by anio, razon_social

GO



--Los 3 productos con mayor cantidad de reposición por mes. 
/*IMPORTANTE: PARA ESTE PUNTO CONSIDERAMOS COMO MAYOR REPOSICION A LA CANTIDAD COMPRADA, ES DECIR, LOS PRODUCTOS MÁS COMPRADOS EN ESE MES. 
EN CASO DE QUE SE QUIERA SABER LA CANTIDAD DE VECES QUE SE COMPRO UN PRODUCTO, HABRÍA QUE REALIZAR UN COUNT(ID_PRODUCTO) SOBRE LA TABLA DE COMPRAXPRODUCTO EN LUGAR DE UN SUM(CANTIDAD)*/
CREATE VIEW GDD_2022_007.BI_V_Productos_Mayor_Reposicion_Por_Cantidad
AS
Select mes, descripcion, comprados
FROM
(SELECT ROW_NUMBER() OVER(partition by t.mes order by cxp.cantidad desc) posicion, 
		t.mes,
		pro.descripcion,
		cxp.cantidad comprados --La cantidad no es solicitada especificamente, pero decidimos mostrarlo.
FROM  GDD_2022_007.BI_Fact_compraxproducto cxp
JOIN GDD_2022_007.BI_Dim_Tiempo t ON t.id = cxp.id_tiempo
JOIN GDD_2022_007.BI_Dim_producto pro ON cxp.id_producto = pro.id
) as ProductosMayorReposicion
WHERE posicion <= 3


/* SELECTS DE VISTAS

	SELECT * FROM GDD_2022_007.BI_V_Ganancias_mensualesxcanaldeventa
	SELECT * FROM GDD_2022_007.BI_V_Productos_Mayor_Rentabilidad_anual
	SELECT * FROM GDD_2022_007.BI_V_Categoria_masvendidaxrangoetario_mensual
	SELECT * FROM GDD_2022_007.BI_V_Ingresos_mediopago_mensual
	SELECT * FROM GDD_2022_007.BI_V_Descuentos_por_tipo_canal_mes
	SELECT * FROM GDD_2022_007.BI_V_Envios_por_provincia_mes
	SELECT * FROM GDD_2022_007.BI_V_AVG_Valor_Envio_Provincia_Anual
	SELECT * FROM GDD_2022_007.BI_V_AVG_Aumento_Proveedor_Anual
	SELECT * FROM GDD_2022_007.BI_V_Productos_Mayor_Reposicion_Por_Cantidad


*/
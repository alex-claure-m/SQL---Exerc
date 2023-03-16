USE[GD2C2022]
GO

-- =========== CREACION SCHEMA =============================
/*
IF (EXISTS (SELECT * FROM sys.schemas WHERE name = 'GDD_2022_007')) 
BEGIN

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'venta_descuentos')) 
		DROP TABLE GDD_2022_007.venta_descuentos

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'cuponxventa')) 
		DROP TABLE GDD_2022_007.cuponxventa

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'cupon')) 
		DROP TABLE GDD_2022_007.cupon

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'ventaxproducto')) 
		DROP TABLE GDD_2022_007.ventaxproducto

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'venta')) 
		DROP TABLE GDD_2022_007.venta

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'cliente')) 
		DROP TABLE GDD_2022_007.cliente

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'venta_mediopago')) 
		DROP TABLE GDD_2022_007.venta_mediopago

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'medioenvioxcodigopostal')) 
		DROP TABLE GDD_2022_007.medioenvioxcodigopostal

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'medio_envio')) 
		DROP TABLE GDD_2022_007.medio_envio

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'canal_venta')) 
		DROP TABLE GDD_2022_007.canal_venta

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'compra_descuento')) 
		DROP TABLE GDD_2022_007.compra_descuento

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'compraxproducto')) 
		DROP TABLE GDD_2022_007.compraxproducto

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'compra')) 
		DROP TABLE GDD_2022_007.compra

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'compra_mediopago')) 
		DROP TABLE GDD_2022_007.compra_mediopago

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'proveedor')) 
		DROP TABLE GDD_2022_007.proveedor

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'codigopostalxlocalidad')) 
		DROP TABLE GDD_2022_007.codigopostalxlocalidad

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'localidad')) 
		DROP TABLE GDD_2022_007.localidad

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'codigo_postal')) 
		DROP TABLE GDD_2022_007.codigo_postal

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'provincia')) 
		DROP TABLE GDD_2022_007.provincia

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'promocion')) 
		DROP TABLE GDD_2022_007.promocion

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'productoxvariante')) 
		DROP TABLE GDD_2022_007.productoxvariante

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'variante')) 
		DROP TABLE GDD_2022_007.variante

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'tipovariante')) 
		DROP TABLE GDD_2022_007.tipovariante

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'producto')) 
		DROP TABLE GDD_2022_007.producto

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'categoria')) 
		DROP TABLE GDD_2022_007.categoria

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'marca')) 
		DROP TABLE GDD_2022_007.marca

	IF (EXISTS (SELECT * FROM sys.objects WHERE name = 'material')) 
		DROP TABLE GDD_2022_007.material

		DROP PROCEDURE GDD_2022_007.INSERTAR_MATERIAL
		DROP PROCEDURE GDD_2022_007.INSERTAR_MARCA
		DROP PROCEDURE GDD_2022_007.INSERTAR_CATEGORIA
		DROP PROCEDURE GDD_2022_007.INSERTAR_TIPOVARIANTE
		DROP PROCEDURE GDD_2022_007.INSERTAR_VARIANTE
		DROP PROCEDURE GDD_2022_007.INSERTAR_PRODUCTO
		DROP PROCEDURE GDD_2022_007.INSERTAR_PRODUCTOXVARIANTE
		DROP PROCEDURE GDD_2022_007.INSERTAR_CODIGO_POSTAL
		DROP PROCEDURE GDD_2022_007.INSERTAR_PROVINCIA
		DROP PROCEDURE GDD_2022_007.INSERTAR_LOCALIDAD
		DROP PROCEDURE GDD_2022_007.INSERTAR_CODIGOPOSTALXLOCALIDAD
		DROP PROCEDURE GDD_2022_007.INSERTAR_PROVEEDOR
		DROP PROCEDURE GDD_2022_007.INSERTAR_COMPRA_MEDIOPAGO
		DROP PROCEDURE GDD_2022_007.INSERTAR_COMPRA
		DROP PROCEDURE GDD_2022_007.INSERTAR_COMPRAXPRODUCTO
		DROP PROCEDURE GDD_2022_007.INSERTAR_COMPRA_DESCUENTO
		DROP PROCEDURE GDD_2022_007.INSERTAR_CANAL_VENTA
		DROP PROCEDURE GDD_2022_007.INSERTAR_MEDIO_ENVIO
		DROP PROCEDURE GDD_2022_007.INSERTAR_MEDIOENVIOXCODIGOPOSTAL
		DROP PROCEDURE GDD_2022_007.INSERTAR_VENTA_MEDIOPAGO
		DROP PROCEDURE GDD_2022_007.INSERTAR_CLIENTE
		DROP PROCEDURE GDD_2022_007.INSERTAR_VENTA
		DROP PROCEDURE GDD_2022_007.INSERTAR_VENTAXPRODUCTO
		DROP PROCEDURE GDD_2022_007.INSERTAR_CUPON
		DROP PROCEDURE GDD_2022_007.INSERTAR_CUPONXVENTA
		DROP PROCEDURE GDD_2022_007.INSERTAR_VENTA_DESCUENTOS
		DROP PROCEDURE GDD_2022_007.MIGRAR
	

	DROP SCHEMA GDD_2022_007
END
GO*/

CREATE SCHEMA GDD_2022_007
GO

-- =================== Creacion de tablas y constrains ===================

--categoria


CREATE TABLE GDD_2022_007.categoria(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
nombre NVARCHAR(255) UNIQUE
)

--marca
CREATE TABLE GDD_2022_007.marca(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
nombre NVARCHAR(255) UNIQUE
)

--material
CREATE TABLE GDD_2022_007.material(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
nombre NVARCHAR(50) UNIQUE
)

--producto
CREATE TABLE GDD_2022_007.producto(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
nombre NVARCHAR(50),
codigo NVARCHAR(50) UNIQUE,
descripcion NVARCHAR(50),
id_material BIGINT, -- FK
id_marca BIGINT, -- FK
id_categoria BIGINT -- FK
)
ALTER TABLE GDD_2022_007.producto
ADD FOREIGN KEY (id_material) REFERENCES GDD_2022_007.material(id);
ALTER TABLE GDD_2022_007.producto
ADD FOREIGN KEY (id_marca) REFERENCES GDD_2022_007.marca(id);
ALTER TABLE GDD_2022_007.producto
ADD FOREIGN KEY (id_categoria) REFERENCES GDD_2022_007.categoria(id);


--tipovariante
CREATE TABLE GDD_2022_007.tipovariante(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
nombre NVARCHAR(50) UNIQUE
)

--variante
CREATE TABLE GDD_2022_007.variante(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
descripcion NVARCHAR(50),
id_tipovariante BIGINT -- FK
)
ALTER TABLE GDD_2022_007.variante
ADD FOREIGN KEY (id_tipovariante) REFERENCES GDD_2022_007.tipovariante(id);

ALTER TABLE GDD_2022_007.variante ADD CONSTRAINT UNIQUE_Var_Tipo UNIQUE (descripcion, id_tipovariante)
GO

--productoxvariante
CREATE TABLE GDD_2022_007.productoxvariante(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
id_producto BIGINT, -- FK 
id_variante BIGINT , -- FK
codigo NVARCHAR(50) NOT NULL, 
precio DECIMAL(18,2),
stock INT,
)
ALTER TABLE GDD_2022_007.productoxvariante
ADD FOREIGN KEY (id_producto) REFERENCES GDD_2022_007.producto(id);
ALTER TABLE GDD_2022_007.productoxvariante
ADD FOREIGN KEY (id_variante) REFERENCES GDD_2022_007.variante(id);

ALTER TABLE GDD_2022_007.productoxvariante ADD CONSTRAINT UNIQUE_Prod_Var UNIQUE (id_producto, id_variante)
GO

--promocion
CREATE TABLE GDD_2022_007.promocion(
id_productoxvariante BIGINT NOT NULL,
precio DECIMAL(18,2) NOT NULL,
fecha_desde date NOT NULL,
fecha_hasta date NOT NULL
)
ALTER TABLE GDD_2022_007.promocion
ADD FOREIGN KEY (id_productoxvariante) REFERENCES GDD_2022_007.productoxvariante(id);


--provincia
CREATE TABLE GDD_2022_007.provincia(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
nombre NVARCHAR(255) unique
)

--codigo_postal
CREATE TABLE GDD_2022_007.codigo_postal(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
codigopostal decimal(18,0) unique
)

--localidad
CREATE TABLE GDD_2022_007.localidad(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
nombre NVARCHAR(255),
id_provincia BIGINT
)
ALTER TABLE GDD_2022_007.localidad
ADD FOREIGN KEY (id_provincia) REFERENCES GDD_2022_007.provincia(id);

ALTER TABLE GDD_2022_007.localidad ADD CONSTRAINT UNIQUE_Loc_Prov UNIQUE (nombre, id_provincia)
GO


--codigopostalxlocalidad
CREATE TABLE GDD_2022_007.codigopostalxlocalidad(
id_codigopostal BIGINT  NOT NULL, -- PK Y FK tambien
id_localidad BIGINT  NOT NULL, -- PK Y FK 
tiempo DECIMAL (18,2),
precio DECIMAL(18,2)

PRIMARY KEY(id_codigopostal, id_localidad)
)
ALTER TABLE GDD_2022_007.codigopostalxlocalidad
ADD FOREIGN KEY (id_codigopostal) REFERENCES GDD_2022_007.codigo_postal(id);
ALTER TABLE GDD_2022_007.codigopostalxlocalidad
ADD FOREIGN KEY (id_localidad) REFERENCES GDD_2022_007.localidad(id);

ALTER TABLE GDD_2022_007.codigopostalxlocalidad ADD CONSTRAINT UNIQUE_CP_Loc UNIQUE (id_codigopostal, id_localidad)
GO

--proveedor
CREATE TABLE GDD_2022_007.proveedor(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
razon_social NVARCHAR(50),
cuit NVARCHAR(50),
domicilio NVARCHAR(50),
mail NVARCHAR(50), 
id_codigopostal BIGINT,
id_localidad BIGINT
)
ALTER TABLE GDD_2022_007.proveedor
ADD FOREIGN KEY (id_codigopostal) REFERENCES GDD_2022_007.codigo_postal(id);
ALTER TABLE GDD_2022_007.proveedor
ADD FOREIGN KEY (id_localidad) REFERENCES GDD_2022_007.localidad(id);

ALTER TABLE GDD_2022_007.proveedor ADD CONSTRAINT UNIQUE_Proveedor_RazonSocial UNIQUE (razon_social, cuit)
GO

--compra_mediopago

CREATE TABLE GDD_2022_007.compra_mediopago(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
medio_pago NVARCHAR(255) UNIQUE
)

--compra
CREATE TABLE GDD_2022_007.compra(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
nro_compra DECIMAL(19,0) UNIQUE,
id_mediopago BIGINT , -- FK
total DECIMAL(18,2),
fecha DATE,
id_proveedor BIGINT , -- FK
)
ALTER TABLE GDD_2022_007.compra
ADD FOREIGN KEY (id_proveedor) REFERENCES GDD_2022_007.proveedor(id);
ALTER TABLE GDD_2022_007.compra
ADD FOREIGN KEY (id_mediopago) REFERENCES GDD_2022_007.compra_mediopago(id);

--compraxproducto
CREATE TABLE GDD_2022_007.compraxproducto(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
id_compra BIGINT  NOT NULL, --FK
id_productoxvariante BIGINT  NOT NULL, --  FK 
cantidad DECIMAL (18,0),
precio DECIMAL(18,2)

)
ALTER TABLE GDD_2022_007.compraxproducto
ADD FOREIGN KEY (id_compra) REFERENCES GDD_2022_007.compra(id);
ALTER TABLE GDD_2022_007.compraxproducto
ADD FOREIGN KEY (id_productoxvariante) REFERENCES GDD_2022_007.productoxvariante(id);

--compra_descuento
CREATE TABLE GDD_2022_007.compra_descuento(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
id_compra BIGINT, --FK
codigo DECIMAL(19,0),
valor DECIMAL(18,2)
)
ALTER TABLE GDD_2022_007.compra_descuento
ADD FOREIGN KEY (id_compra) REFERENCES GDD_2022_007.compra(id);

--canal_venta
CREATE TABLE GDD_2022_007.canal_venta(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
canal NVARCHAR(2255),
costo decimal(18,2)
)
GO

--medio_envio
CREATE TABLE GDD_2022_007.medio_envio(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
envio NVARCHAR(255)
)

--medioenvioxcodigopostal
CREATE TABLE GDD_2022_007.medioenvioxcodigopostal(
id_medioenvio BIGINT  NOT NULL, -- PK Y FK tambien
id_codigopostal BIGINT  NOT NULL, -- PK Y FK 

PRIMARY KEY(id_codigopostal, id_medioenvio)
)
ALTER TABLE GDD_2022_007.medioenvioxcodigopostal
ADD FOREIGN KEY (id_medioenvio) REFERENCES GDD_2022_007.medio_envio(id);
ALTER TABLE GDD_2022_007.medioenvioxcodigopostal
ADD FOREIGN KEY (id_codigopostal) REFERENCES GDD_2022_007.codigo_postal(id);

ALTER TABLE GDD_2022_007.medioenvioxcodigopostal ADD CONSTRAINT UNIQUE_Env_CP UNIQUE (id_medioenvio, id_codigopostal)
GO

--venta_mediopago
CREATE TABLE GDD_2022_007.venta_mediopago(
id BIGINT IDENTITY PRIMARY KEY NOT NULL, 
medio_pago NVARCHAR(255) UNIQUE,
costo DECIMAL(18,2),
descuento DECIMAL(18,2)
)

--cliente
CREATE TABLE GDD_2022_007.cliente(
id BIGINT IDENTITY PRIMARY KEY NOT NULL, 
nombre NVARCHAR(255),
apellido NVARCHAR(255),
dni DECIMAL(18,0),
direccion NVARCHAR(255),
telefono DECIMAL(18,0),
email NVARCHAR(255),
fecha_nacimiento date,
id_localidad BIGINT,  -- FK 
id_codigopostal BIGINT --FK
)
ALTER TABLE GDD_2022_007.cliente
ADD FOREIGN KEY (id_localidad) REFERENCES GDD_2022_007.localidad(id);
ALTER TABLE GDD_2022_007.cliente
ADD FOREIGN KEY (id_codigopostal) REFERENCES GDD_2022_007.codigo_postal(id);
GO

--venta

CREATE TABLE GDD_2022_007.venta(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
codigo decimal(19,0) UNIQUE,
fecha date,
id_canalVenta BIGINT,  -- FK 
id_medioPago BIGINT,  -- FK 
id_cliente BIGINT,  -- FK 
id_medio_envio BIGINT,  -- FK 
envio_precio DECIMAL(18,2),
mediopago_costo DECIMAL(18,2),
canal_costo decimal(18,2),
subtotal decimal(18,2)
)

ALTER TABLE GDD_2022_007.venta
ADD FOREIGN KEY (id_canalVenta) REFERENCES GDD_2022_007.canal_venta(id);
ALTER TABLE GDD_2022_007.venta
ADD FOREIGN KEY (id_medioPago) REFERENCES GDD_2022_007.venta_mediopago(id);
ALTER TABLE GDD_2022_007.venta
ADD FOREIGN KEY (id_cliente) REFERENCES GDD_2022_007.cliente(id);
ALTER TABLE GDD_2022_007.venta
ADD FOREIGN KEY (id_medio_envio) REFERENCES GDD_2022_007.medio_envio(id);
go


--ventaxproducto
CREATE TABLE GDD_2022_007.ventaxproducto(
id BIGINT IDENTITY PRIMARY KEY NOT NULL,
id_venta BIGINT  NOT NULL, -- FK tambien
id_productoxvariante BIGINT  NOT NULL, -- FK 
cantidad DECIMAL (18,0),
precio DECIMAL(18,2),
subtotal as cantidad * precio --UTILIZAMOS UNA COLUMNA CALCULADA, YA QUE ENTENDEMOS QUE ESTA COLUMNA, AL GENERARSE A PARTIR DE DATOS DE OTRAS COLUMNAS, NO ES NECESARIO PERSISTIRLA.
								-- OTRA OPCIONES CALCULARLA NUEVAMENTE CON UN TRIGGER CADA VEZ QUE SE HAGA UN INSERT O UN UPDATE, PERO POR LA SIMPLICIDAD DE LA MISMA, ENTENDEMOS QUE LA COLUMNA CALCULADA ES SUFICIENTE
)
ALTER TABLE GDD_2022_007.ventaxproducto
ADD FOREIGN KEY (id_venta) REFERENCES GDD_2022_007.venta(id);
ALTER TABLE GDD_2022_007.ventaxproducto
ADD FOREIGN KEY (id_productoxvariante) REFERENCES GDD_2022_007.productoxvariante(id);
GO



--cupon
CREATE TABLE GDD_2022_007.cupon(
id BIGINT IDENTITY PRIMARY KEY NOT NULL, -- PK
codigo NVARCHAR(255) UNIQUE,
fecha_desde date,
fecha_hasta date,
valor decimal(18,2),
tipo nvarchar(50)
)

--cuponxventa

CREATE TABLE GDD_2022_007.cuponxventa(
id_venta BIGINT  NOT NULL, -- PK Y FK tambien
id_cupon BIGINT  NOT NULL, -- PK Y FK 
importe DECIMAL (18,2),

PRIMARY KEY(id_venta, id_cupon)
)
ALTER TABLE GDD_2022_007.cuponxventa
ADD FOREIGN KEY (id_venta) REFERENCES GDD_2022_007.venta(id);
ALTER TABLE GDD_2022_007.cuponxventa
ADD FOREIGN KEY (id_cupon) REFERENCES GDD_2022_007.cupon(id);
--UN MISMO CUPON PUEDE ESTAR APLICADO A UNA MISMA VENTA VARIAS VECES?

ALTER TABLE GDD_2022_007.cuponxventa ADD CONSTRAINT UNIQUE_Cupon_Venta UNIQUE (id_venta, id_cupon)
GO

--venta_descuentos

CREATE TABLE GDD_2022_007.venta_descuentos(
id  BIGINT IDENTITY PRIMARY KEY NOT NULL, -- PK Y FK tambien
id_venta BIGINT  NOT NULL, -- FK
importe DECIMAL (18,2),
concepto NVARCHAR(255)
)
ALTER TABLE GDD_2022_007.venta_descuentos
ADD FOREIGN KEY (id_venta) REFERENCES GDD_2022_007.venta(id)
GO


--=================== CREACION TRIGGERS ============

--DEBIDO A LA LONGITUD DE ALGUNOS KEY QUE DESEAMOS NO TENER DUPLICADOS, UTILIZAMOS TRIGGERS PARA ASEGURARNOS SU CORRECTO FUNCIONAMIENTO
CREATE TRIGGER GDD_2022_007.TR_UNIQUE_CLIENTE ON GDD_2022_007.cliente
AFTER INSERT,UPDATE
AS
BEGIN TRANSACTION
	DECLARE @Cliente nvarchar(2255)
	DECLARE mi_cursor CURSOR
	FOR
		SELECT DISTINCT nombre + '_' + apellido + '_' + CAST(dni AS NVARCHAR(MAX)) as nuevoCliente FROM INSERTED

	OPEN mi_cursor
	FETCH mi_cursor INTO @Cliente

	WHILE @@FETCH_STATUS = 0
	BEGIN
	IF (select COUNT(*) from GDD_2022_007.cliente c WHERE c.nombre + '_' + c.apellido + '_' + CAST(c.dni AS NVARCHAR(MAX))= @Cliente) > 1
		BEGIN
			PRINT ('Cliente duplicado')
			rollback transaction  
		END

		FETCH mi_cursor INTO @Cliente
	END
	CLOSE mi_cursor
	DEALLOCATE mi_cursor
COMMIT 
GO



CREATE TRIGGER GDD_2022_007.TR_UNIQUE_CANAL ON GDD_2022_007.canal_venta
AFTER INSERT,UPDATE
AS
BEGIN TRANSACTION
	DECLARE @Canal nvarchar(2255)
	DECLARE mi_cursor CURSOR
	FOR
		SELECT DISTINCT CANAL FROM INSERTED


	OPEN mi_cursor
	FETCH mi_cursor INTO @Canal

	WHILE @@FETCH_STATUS = 0
	BEGIN
	IF (select COUNT(*) from GDD_2022_007.canal_venta WHERE GDD_2022_007.canal_venta.canal= @Canal) > 1
		BEGIN
			PRINT ('Canal duplicado')
			rollback transaction  
		END

		FETCH mi_cursor INTO @Canal
	END
	CLOSE mi_cursor
	DEALLOCATE mi_cursor
COMMIT 
GO


-- ================== MIGRACION ===================

-- MATERIAL
CREATE PROCEDURE GDD_2022_007.INSERTAR_MATERIAL
AS
BEGIN
INSERT INTO GDD_2022_007.material(
nombre
) 
SELECT DISTINCT m.PRODUCTO_MATERIAL FROM gd_esquema.Maestra m
END
GO

-- MARCA
CREATE PROCEDURE GDD_2022_007.INSERTAR_MARCA
AS
BEGIN
INSERT INTO GDD_2022_007.marca(
nombre
)
SELECT DISTINCT m.PRODUCTO_MARCA FROM gd_esquema.Maestra m WHERE m.PRODUCTO_MARCA IS NOT NULL
END
GO

-- CATEGORIA
CREATE PROCEDURE GDD_2022_007.INSERTAR_CATEGORIA
AS
BEGIN
INSERT INTO GDD_2022_007.categoria(
nombre
)
SELECT DISTINCT m.PRODUCTO_CATEGORIA FROM gd_esquema.Maestra m WHERE m.PRODUCTO_CATEGORIA IS NOT NULL
END
GO


-- TIPOVARIANTE
CREATE PROCEDURE GDD_2022_007.INSERTAR_TIPOVARIANTE
AS
BEGIN
INSERT INTO GDD_2022_007.tipovariante(
nombre
)
SELECT DISTINCT m.PRODUCTO_TIPO_VARIANTE FROM gd_esquema.Maestra m WHERE m.PRODUCTO_TIPO_VARIANTE IS NOT NULL
END
GO


-- VARIANTE
CREATE PROCEDURE GDD_2022_007.INSERTAR_VARIANTE
AS
BEGIN
INSERT INTO GDD_2022_007.variante (
descripcion, 
id_tipovariante
)
SELECT DISTINCT m.PRODUCTO_VARIANTE, (SELECT id FROM GDD_2022_007.tipovariante t WHERE t.nombre = m.PRODUCTO_TIPO_VARIANTE )  FROM gd_esquema.Maestra m WHERE m.PRODUCTO_VARIANTE IS NOT NULL
END
GO

--PRODUCTO
CREATE PROCEDURE GDD_2022_007.INSERTAR_PRODUCTO
AS
BEGIN
INSERT INTO GDD_2022_007.producto(
nombre ,
codigo ,
descripcion ,
id_material,
id_marca,
id_categoria
)
SELECT DISTINCT m.PRODUCTO_NOMBRE, m.PRODUCTO_CODIGO, m.PRODUCTO_DESCRIPCION, 
				(select id from GDD_2022_007.material mat where mat.nombre = m.PRODUCTO_MATERIAL), 
				(select id from GDD_2022_007.marca mar where mar.nombre = m.PRODUCTO_MARCA), 
				(select id from GDD_2022_007.categoria cat where cat.nombre = m.PRODUCTO_CATEGORIA) 
FROM gd_esquema.Maestra m WHERE m.PRODUCTO_NOMBRE IS NOT NULL
END
GO

CREATE PROCEDURE GDD_2022_007.INSERTAR_PRODUCTOXVARIANTE
AS
BEGIN
INSERT INTO GDD_2022_007.productoxvariante(
id_producto,
id_variante,
codigo,
precio,
stock
)
SELECT DISTINCT P.ID id_producto,
				(SELECT id FROM GDD_2022_007.variante v 
				  WHERE v.descripcion = M.PRODUCTO_VARIANTE and v.id_tipovariante = (select id from GDD_2022_007.tipovariante tv where tv.nombre = m.PRODUCTO_TIPO_VARIANTE )) id_variante,
				M.PRODUCTO_CODIGO,
				null, --Tenemos el campo precio de venta, y cuando se concreta una venta, este valor debe ser insertado en la tabla de ventas, contemplando por un lado que vamos a tener un precio vigente, y en el registro de ventas, el precio de cuando se vendió
				null -- Dejamos el campo stock, quizas contemplando a futuro que se va a querer llevar un registro del mismo, aunque la consigna no lo solicite
FROM gd_esquema.Maestra m
JOIN GDD_2022_007.producto P ON P.codigo = M.PRODUCTO_CODIGO 
WHERE m.PRODUCTO_CODIGO IS NOT NULL
END 
GO


-- codigo_postal
CREATE PROCEDURE GDD_2022_007.INSERTAR_CODIGO_POSTAL
AS
BEGIN
INSERT INTO GDD_2022_007.codigo_postal(
codigopostal
)
SELECT DISTINCT cp.codigopostal --INGRESAMOS LOS DOS CODIGOS POSTALES, DE CLIENTES Y PROVEEDORES PARA YA TENER LA MAXIMA CANTIDAD DE CP REGISTRADOS Y ASOCIADOS
FROM
(SELECT  m.CLIENTE_CODIGO_POSTAL as codigopostal
FROM gd_esquema.Maestra M WHERE m.CLIENTE_CODIGO_POSTAL is not null
UNION 
SELECT  m.PROVEEDOR_CODIGO_POSTAL as codigopostal
FROM gd_esquema.Maestra M WHERE m.PROVEEDOR_CODIGO_POSTAL is not null) as cp
END
GO

--provincia
CREATE PROCEDURE GDD_2022_007.INSERTAR_PROVINCIA
AS
BEGIN
INSERT INTO GDD_2022_007.provincia(
nombre
)SELECT DISTINCT pro.provincia --INGRESAMOS LAS PROVINCIAS, DE CLIENTES Y PROVEEDORES PARA YA TENER LA MAXIMA CANTIDAD DE PROVINCIAS REGISTRADOS Y ASOCIADOS
FROM
(SELECT  m.CLIENTE_PROVINCIA as provincia
FROM gd_esquema.Maestra M WHERE m.CLIENTE_PROVINCIA is not null
UNION 
SELECT  m.PROVEEDOR_PROVINCIA as provincia
FROM gd_esquema.Maestra M WHERE m.PROVEEDOR_PROVINCIA is not null) as pro
END
GO
--localidad
CREATE PROCEDURE GDD_2022_007.INSERTAR_LOCALIDAD
AS
BEGIN
INSERT INTO GDD_2022_007.localidad(
nombre,
id_provincia
)
select distinct loc.localidad, loc.id
FROM
(SELECT m.CLIENTE_LOCALIDAD localidad, (select id from GDD_2022_007.provincia p where p.nombre = m.CLIENTE_PROVINCIA) id
FROM gd_esquema.Maestra M WHERE m.CLIENTE_LOCALIDAD IS NOT NULL AND m.CLIENTE_PROVINCIA IS NOT NULL
UNION
SELECT m.PROVEEDOR_LOCALIDAD localidad, (select id from GDD_2022_007.provincia p where p.nombre = m.PROVEEDOR_PROVINCIA) id
FROM gd_esquema.Maestra M WHERE m.PROVEEDOR_LOCALIDAD IS NOT NULL AND m.PROVEEDOR_PROVINCIA IS NOT NULL) as loc
END
GO

--codigopostalxlocalidad
CREATE PROCEDURE GDD_2022_007.INSERTAR_CODIGOPOSTALXLOCALIDAD
AS
BEGIN
INSERT INTO GDD_2022_007.codigopostalxlocalidad   --Tomamos tanto datos de proveedores y clientes para tener ya normalizados la mayor cantidad posible de registros y completas las tablas de clientes y proveedores
(
id_codigopostal,
id_localidad,
tiempo, --no contamos con esta información en la tabla maestra
precio  --Tenemos este campo para tener el campo de precio envíos vigente, y cuando se concreta una venta, este valor debe ser insertado en la tabla de ventas, contemplando por un lado que vamos a tener un precio vigente, y en el registro de ventas, el precio de cuando se vendió
)
SELECT DISTINCT CPXPRO.id_codigopostal, CPXPRO.id_localidad, null,null
FROM 
(SELECT (select id from GDD_2022_007.codigo_postal p where p.codigopostal = m.CLIENTE_CODIGO_POSTAL) id_codigopostal, 
	   (select l.id from GDD_2022_007.localidad l
	   JOIN GDD_2022_007.PROVINCIA p on l.id_provincia = p.id
		where l.nombre = M.CLIENTE_LOCALIDAD and p.nombre = m.CLIENTE_PROVINCIA) id_localidad
FROM gd_esquema.Maestra M where m.CLIENTE_CODIGO_POSTAL is not null and m.CLIENTE_PROVINCIA is not null
UNION
SELECT (select id from GDD_2022_007.codigo_postal p where p.codigopostal = m.PROVEEDOR_CODIGO_POSTAL) id_codigopostal, 
	   (select l.id from GDD_2022_007.localidad l
	   JOIN GDD_2022_007.PROVINCIA p on l.id_provincia = p.id
		where l.nombre = M.PROVEEDOR_LOCALIDAD and p.nombre = m.PROVEEDOR_PROVINCIA) id_localidad
FROM gd_esquema.Maestra M where m.PROVEEDOR_CODIGO_POSTAL is not null and m.PROVEEDOR_PROVINCIA is not null AND m.PROVEEDOR_LOCALIDAD IS NOT NULL ) AS CPXPRO
END
GO

--proveedor
CREATE PROCEDURE GDD_2022_007.INSERTAR_PROVEEDOR
AS
BEGIN
INSERT INTO GDD_2022_007.proveedor
(
razon_social,
cuit,
domicilio,
mail,
id_codigopostal,
id_localidad  --Grabamos el proveedor a traves de la localidad, y a traves de la misma podemos llegar a la provincia realizando un join entre la tabla localidad y provincia
)
SELECT DISTINCT 
	M.PROVEEDOR_RAZON_SOCIAL,
	M.PROVEEDOR_CUIT,
	M.PROVEEDOR_DOMICILIO,
	M.PROVEEDOR_MAIL,
	(select id from GDD_2022_007.codigo_postal p where p.codigopostal = m.PROVEEDOR_CODIGO_POSTAL) id_codigopostal,
	(select id from GDD_2022_007.localidad l where l.nombre = m.PROVEEDOR_LOCALIDAD AND l.id_provincia = (select id from GDD_2022_007.provincia pro where pro.nombre = M.PROVEEDOR_PROVINCIA)) id_localidad
	FROM gd_esquema.Maestra M where m.PROVEEDOR_RAZON_SOCIAL is not null
END
GO

--Compra medio de pago 
/*--Separamos medio de pago de compra y de venta, porque para la venta quizas se encuentran habilitados algunos y para las compras, los medios de pago dependen de cada proveedor en particular. 
Otra opción era normalizar los mismos e indicar con dos columnas si se encontraban habilitados para usar en compras y/o ventas*/
CREATE PROCEDURE GDD_2022_007.INSERTAR_COMPRA_MEDIOPAGO
AS
BEGIN
INSERT INTO GDD_2022_007.compra_mediopago 
(
medio_pago
)SELECT DISTINCT m.COMPRA_MEDIO_PAGO FROM gd_esquema.Maestra M where m.COMPRA_MEDIO_PAGO is not null
END
GO
--compra
CREATE PROCEDURE GDD_2022_007.INSERTAR_COMPRA
AS
BEGIN
INSERT INTO GDD_2022_007.compra
(
nro_compra,
id_mediopago,
total,
fecha,
id_proveedor
)
SELECT DISTINCT
M.COMPRA_NUMERO,
(select id from GDD_2022_007.compra_mediopago mp where mp.medio_pago = M.COMPRA_MEDIO_PAGO) id_mediopago ,
M.COMPRA_TOTAL,
M.COMPRA_FECHA,
(select id from GDD_2022_007.proveedor p where p.razon_social = M.PROVEEDOR_RAZON_SOCIAL) id_proveedor
FROM gd_esquema.Maestra M 
where m.COMPRA_NUMERO is not null
END
GO

--compraxproducto
CREATE PROCEDURE GDD_2022_007.INSERTAR_COMPRAXPRODUCTO
AS
BEGIN
INSERT INTO GDD_2022_007.compraxproducto
(
id_compra,
id_productoxvariante,
cantidad,
precio
)
SELECT DISTINCT (SELECT ID FROM GDD_2022_007.compra c WHERE c.nro_compra = M.COMPRA_NUMERO) AS id_compra,
(SELECT pv.id FROM GDD_2022_007.productoxvariante pv 
 JOIN GDD_2022_007.variante V ON V.ID = PV.id_variante
 JOIN GDD_2022_007.producto P ON P.ID = PV.id_producto
 where v.descripcion = M.PRODUCTO_VARIANTE and P.Codigo = M.PRODUCTO_CODIGO) as id_productoxvariante,
M.COMPRA_PRODUCTO_CANTIDAD AS cantidad, --INICIALMENTE UTILIZABAMOS PK COMPUESTA POR ID_COMPRA E ID_PRODUCTOVARIANTE, PERO DETECTAMOS QUE QUIZAS POR ALGUNA PROMOCIÓN O SIMILAR,
											--UN PROVEEDOR PODIA ENVIARNOS CIERTAS CANTIDADES DE UN PRODUCTO Y OTRAS CANTIDADES CON OTRO PRECIO, POR LO CUAL DECIDIMOS MANTENER ESTA FLEXIBILIDAD Y PERMITIR INGRESAR 
											--MUCHAS VECES EL MISMO PRODUCTOVARIANTE PARA LA MISMA COMPRA.
											
M.COMPRA_PRODUCTO_PRECIO precio
FROM gd_esquema.Maestra M 
where m.COMPRA_NUMERO is not null
AND M.PRODUCTO_CODIGO IS NOT NULL
END 
GO


--compra_descuento
CREATE PROCEDURE GDD_2022_007.INSERTAR_COMPRA_DESCUENTO
AS
BEGIN
INSERT INTO GDD_2022_007.compra_descuento
(
id_compra,
codigo,
valor
)
SELECT DISTINCT (SELECT ID FROM GDD_2022_007.compra c WHERE c.nro_compra = M.COMPRA_NUMERO) AS id_compra,
M.DESCUENTO_COMPRA_CODIGO,
M.DESCUENTO_COMPRA_VALOR
FROM gd_esquema.Maestra M 
where m.COMPRA_NUMERO is not null
AND M.DESCUENTO_COMPRA_CODIGO IS NOT NULL
END
GO

--canal_venta
CREATE PROCEDURE GDD_2022_007.INSERTAR_CANAL_VENTA
AS
BEGIN
INSERT INTO  GDD_2022_007.canal_venta
(
canal,
costo  --Si bien tenemos el costo del canal vigente y el histórico en el registro de ventas. Optamos por dejar el valor en null para que posteriormente sea parametrizado por los administradores del sistema
)
SELECT DISTINCT 
VENTA_CANAL canal,
NULL costo
FROM gd_esquema.Maestra M 
where VENTA_CANAL is not null
END
GO

--medio_envio
CREATE PROCEDURE GDD_2022_007.INSERTAR_MEDIO_ENVIO
AS
BEGIN
INSERT INTO GDD_2022_007.medio_envio
(
envio
)SELECT DISTINCT M.VENTA_MEDIO_ENVIO
FROM gd_esquema.Maestra M 
where VENTA_MEDIO_ENVIO is not null
END
GO

--medioenvioxcodigopostal 
/*
Esta tabla tiene como finalidad recuperar los medios de envío disponibles para una determinada reción. 
Si bien esta tabla decidimos completarla con los datos existentes de ventas previas, también persistimos en la tabla ventas qué medio de envío se utilizó al momento de originarse la misma,
ya que el mismo posteriormente puede ser discontinuado para una determinada region y no se debe perder la trazabilidad.
*/
CREATE PROCEDURE GDD_2022_007.INSERTAR_MEDIOENVIOXCODIGOPOSTAL
AS
BEGIN
INSERT INTO GDD_2022_007.medioenvioxcodigopostal 
(
	id_medioenvio,
	id_codigopostal
)
SELECT DISTINCT 
(select id from GDD_2022_007.medio_envio me where me.envio = M.VENTA_MEDIO_ENVIO) id_medioenvio, 
(select id from GDD_2022_007.codigo_postal cp where cp.codigopostal = M.CLIENTE_CODIGO_POSTAL) id_codigopostal
FROM gd_esquema.Maestra M 
where VENTA_MEDIO_ENVIO is not null
and m.CLIENTE_CODIGO_POSTAL is not null
END
GO

--venta_mediopago
CREATE PROCEDURE GDD_2022_007.INSERTAR_VENTA_MEDIOPAGO
AS
BEGIN
INSERT INTO  GDD_2022_007.venta_mediopago
(
medio_pago,
costo,   -- Decidimos 
descuento -- Decidimos mantener los campos de costos y descuentos en null, para que el mismo sea posteriormente configurado por los usuarios como solicita la consigna.
		  -- Este campo, también se registra al momento de generar una venta, manteniendo un registro histórico del descuento aplicado
)
SELECT  DISTINCT 
M.VENTA_MEDIO_PAGO,
NULL,
NULL
FROM gd_esquema.Maestra M 
where VENTA_MEDIO_PAGO is not null
END
GO

--cliente
CREATE PROCEDURE GDD_2022_007.INSERTAR_CLIENTE
AS
BEGIN
INSERT INTO GDD_2022_007.cliente
(
nombre,
apellido,
dni,
direccion,
telefono,
email,
fecha_nacimiento,
id_localidad,
id_codigopostal
)SELECT DISTINCT m.CLIENTE_NOMBRE, M.CLIENTE_APELLIDO, M.CLIENTE_DNI, M.CLIENTE_DIRECCION, M.CLIENTE_TELEFONO, M.CLIENTE_MAIL, M.CLIENTE_FECHA_NAC,
	(select id from GDD_2022_007.localidad l where l.nombre = M.CLIENTE_LOCALIDAD AND l.id_provincia = (select id from GDD_2022_007.provincia pro where pro.nombre = M.CLIENTE_PROVINCIA)) id_localidad,
	(select id from GDD_2022_007.codigo_postal p where p.codigopostal = M.CLIENTE_CODIGO_POSTAL) id_codigopostal
FROM gd_esquema.Maestra M 
where M.CLIENTE_NOMBRE IS NOT NULL
END
GO

--Venta. 
CREATE PROCEDURE GDD_2022_007.INSERTAR_VENTA
AS
BEGIN
INSERT INTO GDD_2022_007.venta(
codigo,
fecha,
id_canalVenta,
id_medioPago,
id_cliente,
id_medio_envio,
envio_precio,
mediopago_costo,
canal_costo,
subtotal
)
SELECT DISTINCT M.VENTA_CODIGO, M.VENTA_FECHA,
cv.id id_canalVenta,
mp.id id_medioPago,
cli.id id_cliente,
me.id,
M.VENTA_ENVIO_PRECIO,
M.VENTA_MEDIO_PAGO_COSTO,
M.VENTA_CANAL_COSTO,
M.VENTA_TOTAL
FROM gd_esquema.Maestra M 
JOIN GDD_2022_007.cliente cli ON cli.dni =  M.CLIENTE_DNI and cli.apellido = M.CLIENTE_APELLIDO and cli.nombre = M.CLIENTE_NOMBRE
JOIN GDD_2022_007.venta_mediopago mp ON mp.medio_pago = M.VENTA_MEDIO_PAGO
JOIN GDD_2022_007.canal_venta cv ON CV.canal = M.VENTA_CANAL
JOIN GDD_2022_007.medio_envio me on me.envio = M.VENTA_MEDIO_ENVIO
where M.VENTA_CODIGO IS NOT NULL
END 
GO

--ventaxproducto
CREATE PROCEDURE GDD_2022_007.INSERTAR_VENTAXPRODUCTO
AS
BEGIN
INSERT INTO GDD_2022_007.ventaxproducto(
id_venta,
id_productoxvariante,
cantidad,
precio
)
SELECT  V.ID id_venta, pxv.id,
M.VENTA_PRODUCTO_CANTIDAD cantidad , --Al igual que en compras, decidimos mantener la flexibilidad 
									 --y darle al sistema la posibilidad de manejar para un mismo productovariante x venta varios precios distintos, por ejemplo para alguna promocion
M.VENTA_PRODUCTO_PRECIO precio
FROM gd_esquema.Maestra M 
LEFT JOIN GDD_2022_007.venta v ON v.codigo = M.VENTA_CODIGO
LEFT JOIN GDD_2022_007.producto P ON P.codigo = M.PRODUCTO_CODIGO
LEFT JOIN GDD_2022_007.variante va ON va.descripcion = M.PRODUCTO_VARIANTE
LEFT JOIN GDD_2022_007.productoxvariante pxv on pxv.id_producto = p.id and pxv.id_variante = va.id
where M.VENTA_CODIGO IS NOT NULL and VENTA_PRODUCTO_CANTIDAD is not null
END
GO

--cupon
CREATE PROCEDURE GDD_2022_007.INSERTAR_CUPON
AS
BEGIN
INSERT INTO GDD_2022_007.cupon(
codigo,
fecha_desde,
fecha_hasta,
valor,
tipo  --Al contar con solo dos tipos de cupones, decidimos tratar esto como un Enum y no separarlo en dos tablas distintas.
)SELECT DISTINCT M.VENTA_CUPON_CODIGO, M.VENTA_CUPON_FECHA_DESDE, M.VENTA_CUPON_FECHA_HASTA, M.VENTA_CUPON_VALOR, M.VENTA_CUPON_TIPO
FROM gd_esquema.Maestra M 
WHERE VENTA_CUPON_CODIGO IS NOT NULL
END
GO
--cuponxventa
/*
En esta tabla se persisten los cupones aplicados a la compra
*/
CREATE PROCEDURE GDD_2022_007.INSERTAR_CUPONXVENTA
AS
BEGIN
INSERT INTO GDD_2022_007.cuponxventa
(
id_venta,
id_cupon,
importe
) 
SELECT DISTINCT v.id id_venta, C.id id_cupon, M.VENTA_CUPON_IMPORTE
FROM gd_esquema.Maestra M 
JOIN GDD_2022_007.venta v on v.codigo = m.VENTA_CODIGO
JOIN GDD_2022_007.cupon c on c.codigo = m.VENTA_CUPON_CODIGO
WHERE VENTA_CUPON_IMPORTE IS NOT NULL
END
GO

--venta_descuentos
/*
En esta tabla se persisten los descuentos aplicados a la venta, salvo lo de cupones, ya sea por medio de pago o por descuento especial a cargo del vendedor
*/
CREATE PROCEDURE GDD_2022_007.INSERTAR_VENTA_DESCUENTOS
AS
BEGIN
INSERT INTO GDD_2022_007.venta_descuentos
(
id_venta,
importe,
concepto
)SELECT DISTINCT v.id id_venta, m.VENTA_DESCUENTO_IMPORTE, m.VENTA_DESCUENTO_CONCEPTO
FROM gd_esquema.Maestra M 
JOIN GDD_2022_007.venta v on v.codigo = m.VENTA_CODIGO
WHERE m.VENTA_DESCUENTO_IMPORTE IS NOT NULL and m.VENTA_DESCUENTO_CONCEPTO IS NOT NULL
END
GO



--=== EJECUCION DE MIGRACION ===

CREATE PROCEDURE GDD_2022_007.MIGRAR
AS
BEGIN
	EXEC GDD_2022_007.INSERTAR_MATERIAL
	EXEC GDD_2022_007.INSERTAR_MARCA
	EXEC GDD_2022_007.INSERTAR_CATEGORIA
	EXEC GDD_2022_007.INSERTAR_TIPOVARIANTE
	EXEC GDD_2022_007.INSERTAR_VARIANTE
	EXEC GDD_2022_007.INSERTAR_PRODUCTO
	EXEC GDD_2022_007.INSERTAR_PRODUCTOXVARIANTE
	EXEC GDD_2022_007.INSERTAR_CODIGO_POSTAL
	EXEC GDD_2022_007.INSERTAR_PROVINCIA
	EXEC GDD_2022_007.INSERTAR_LOCALIDAD
	EXEC GDD_2022_007.INSERTAR_CODIGOPOSTALXLOCALIDAD
	EXEC GDD_2022_007.INSERTAR_PROVEEDOR
	EXEC GDD_2022_007.INSERTAR_COMPRA_MEDIOPAGO
	EXEC GDD_2022_007.INSERTAR_COMPRA
	EXEC GDD_2022_007.INSERTAR_COMPRAXPRODUCTO
	EXEC GDD_2022_007.INSERTAR_COMPRA_DESCUENTO
	EXEC GDD_2022_007.INSERTAR_CANAL_VENTA
	EXEC GDD_2022_007.INSERTAR_MEDIO_ENVIO
	EXEC GDD_2022_007.INSERTAR_MEDIOENVIOXCODIGOPOSTAL
	EXEC GDD_2022_007.INSERTAR_VENTA_MEDIOPAGO
	EXEC GDD_2022_007.INSERTAR_CLIENTE
	EXEC GDD_2022_007.INSERTAR_VENTA
	EXEC GDD_2022_007.INSERTAR_VENTAXPRODUCTO
	EXEC GDD_2022_007.INSERTAR_CUPON
	EXEC GDD_2022_007.INSERTAR_CUPONXVENTA
	EXEC GDD_2022_007.INSERTAR_VENTA_DESCUENTOS

END
GO

EXEC GDD_2022_007.MIGRAR
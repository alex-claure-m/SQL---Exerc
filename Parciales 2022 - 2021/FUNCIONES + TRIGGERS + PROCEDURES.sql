USE [Clase]
GO

CREATE TABLE bancos(
banc_codigo INT PRIMARY KEY,
banc_cuit CHAR(13) NOT NULL,
banc_nom VARCHAR(50) NOT NULL,
banc_estado BIT NOT NULL
)
GO

CREATE TABLE sucursales(
sucu_id INT PRIMARY KEY,
banc_codigo INT NOT NULL REFERENCES bancos,
sucu_dir VARCHAR(50) NOT NULL,
sucu_nombre VARCHAR(50),
sucu_num SMALLINT,
sucu_estado BIT NOT NULL
)
GO 

CREATE TABLE clientes(
clie_id BIGINT PRIMARY KEY IDENTITY(5501,1),
clie_nombres NVARCHAR(50),
clie_apellido_rs NVARCHAR(50) NOT NULL,
clie_cuitl CHAR(13) CONSTRAINT uq_clie_cuitl UNIQUE NOT NULL,
clie_recomendado BIGINT REFERENCES clientes,
clie_alta DATE,
clie_baja DATETIME
)
GO 

CREATE TABLE cuentas(
cue_numero CHAR(12) PRIMARY KEY,
cue_saldo NUMERIC(10,2) DEFAULT 0,
sucu_id INT REFERENCES sucursales,
clie_id BIGINT
)
GO

CREATE TABLE movimientos(
mov_fecha DATETIME NOT NULL,
mov_monto NUMERIC(10,2) NOT NULL,
cue_id CHAR(12) NOT NULL REFERENCES cuentas,
tipo VARCHAR(7) NOT NULL,
mov_detalle VARCHAR(50),
CONSTRAINT ck_movi_tipo CHECK (tipo IN ('Debito','Credito')),
CONSTRAINT ck_movi_monto CHECK (mov_monto > 0)
)
GO

CREATE TABLE usuarios(
usuario CHAR(8) PRIMARY KEY, 
clave VARBINARY (32)
)
GO

CREATE TABLE segmentos(
idsegmento INT PRIMARY KEY,
descripcion VARCHAR(20)
)
GO

CREATE TABLE UsuariosXsegmentos(
usuario CHAR(8) REFERENCES usuarios,
idsegmento INT REFERENCES segmentos,
CONSTRAINT pk_user_segm PRIMARY KEY (usuario, idsegmento)
) 
GO

CREATE TABLE Transferencias(
idlog INT IDENTITY(1,1),
cuen_origen CHAR(12) REFERENCES cuentas,
cuen_destino CHAR(12) REFERENCES cuentas,
monto NUMERIC(10,2),
fecha SMALLDATETIME,
usuario VARCHAR(20),
confirmado CHAR(2)
) 
GO


-- Alter table

ALTER TABLE cuentas  
ADD CONSTRAINT fk_cuentas_clie FOREIGN KEY
(clie_id)
REFERENCES clientes (clie_id)
GO

ALTER TABLE sucursales
ALTER COLUMN sucu_nombre VARCHAR(60)
GO

ALTER TABLE usuarios
ADD intentos_fallidos INT
GO 

--------------------------------------------
-- INDICES

CREATE INDEX idx_clientes01 ON clientes (clie_apellido_rs,clie_nombres)
GO

--------------------------------------------
--TABLAS TEMPORALES

SELECT *
INTO #cuentas_saldo_en0
FROM cuentas
WHERE cue_saldo = 0

SELECT *
INTO ##cuentas_saldo_en0
FROM cuentas
WHERE cue_saldo = 0

CREATE TABLE #cuentas_saldo_en0
(cue_numero CHAR(12) PRIMARY KEY,
cue_saldo NUMERIC(10,2),
sucu_id INT,
clie_id BIGINT)

--------------------------------------------
--VISTAS

CREATE VIEW vw_sucursales_bancos AS
SELECT  
b.banc_codigo, b.banc_cuit, b.banc_nom,
s.sucu_id, s.sucu_dir, ISNULL(s.sucu_num,0) as sucu_num
FROM bancos b INNER JOIN sucursales s
ON b.banc_codigo = s.banc_codigo 
WHERE banc_estado = 1
AND sucu_estado = 1
GO

CREATE VIEW vw_clientes AS
SELECT  
clie_apellido_rs, clie_nombres, 
clie_cuitl, clie_alta FROM clientes
WHERE clie_alta IS NOT NULL
WITH CHECK OPTION
GO

SELECT c.cue_numero, c.cue_saldo, s.banc_nom, s.sucu_id, s.sucu_num
FROM vw_sucursales_bancos s
INNER JOIN cuentas c
ON s.sucu_id = c.sucu_id
WHERE cue_saldo > 0
ORDER BY 1

--------------------------------------------
-- SCALAR VALUED FUNCTION

CREATE FUNCTION fx_vigente (@fecha DATETIME)
RETURNS VARCHAR(2) AS 
BEGIN

	IF @fecha IS NULL 
	BEGIN
		RETURN 'SI'
	END
	IF DATEDIFF(DAY, CAST(@fecha AS DATE), CAST(GETDATE() AS DATE)) < 31 
		RETURN 'SI'
RETURN 'NO'

END
GO

CREATE FUNCTION fx_get_cliente (@cuitl CHAR(13))
RETURNS NVARCHAR(MAX) AS 
BEGIN
	DECLARE @retorno NVARCHAR(105) = ''

	SELECT @retorno = clie_apellido_rs + ' ' + ISNULL(clie_nombres,'')
	FROM clientes WHERE clie_cuitl = @cuitl

	SET @retorno = UPPER(@retorno)

	RETURN @retorno
END
GO

CREATE FUNCTION fx_calcula_interes (@numeroCuenta CHAR(12))
RETURNS REAL AS 
BEGIN
	DECLARE @retorno REAL = 0, @cont INT = 0, @porc REAL = 0.57,  @importe REAL

	SELECT @importe = cue_saldo
	FROM cuentas WHERE cue_numero = @numeroCuenta

	WHILE @importe > 0
	BEGIN
		SET @retorno = @retorno + round((@importe / 100) * @porc, 2)
		SET @importe = @importe - 10000
		SET @porc = @porc + 0.03
		SET @cont = @cont + 1
		IF @cont = 5  
		   BREAK
		   
	END

	RETURN @retorno

END
GO

CREATE FUNCTION fx_calcula_descubierto (@numeroCuenta CHAR(12))
RETURNS INT AS
BEGIN

	DECLARE @retorno INT = 0

	SELECT @retorno = CASE WHEN DATEDIFF(DAY,clie_alta,CAST(GETDATE() AS DATE)) BETWEEN 2 AND 5 THEN -100 
	WHEN DATEDIFF(DAY,clie_alta,CAST(GETDATE() AS DATE)) > 5 THEN -1000
	ELSE 0 END
	FROM cuentas cu
	INNER JOIN clientes cl ON cu.clie_id = cl.clie_id
	WHERE cl.clie_baja IS NULL
	AND cl.clie_alta IS NOT NULL
	AND cu.cue_saldo IS NOT NULL
	AND cu.cue_numero = @numeroCuenta

	RETURN @retorno

END
GO

CREATE FUNCTION fx_valida_usuario (@login CHAR(8), @clave VARCHAR(12))
RETURNS BIT AS 
BEGIN
	
	DECLARE @retorno BIT = 0
	IF EXISTS (SELECT 1 FROM usuarios WHERE usuario = @login AND HASHBYTES('SHA2_256',@clave) = clave)
		SET @retorno = 1
	
	RETURN @retorno

END
GO

SELECT dbo.fx_get_cliente(clie_cuitl) AS nombre, 
SUBSTRING(CONVERT(varchar(30), clie_baja, 120), 1, 10) AS fechaBaja
FROM clientes
WHERE dbo.fx_vigente(clie_baja) = 'NO'
ORDER BY 1

--------------------------------------------
-- TABLE VALUED FUNCTION

CREATE FUNCTION fx_totalesSucursal (@bancoid int)
RETURNS TABLE
AS
RETURN 
(
	SELECT s.sucu_num, s.sucu_dir, 
	SUM(ISNULL(c.cue_saldo,0)) AS 'Total'
	FROM sucursales s
	INNER JOIN cuentas c
	ON s.sucu_id = c.sucu_id
	WHERE sucu_estado = 1
	AND s.banc_codigo = @bancoid
	GROUP BY s.sucu_num, s.sucu_dir
)
GO

SELECT f.sucu_dir, f.sucu_num, f.Total, s.sucu_nombre 
FROM fx_totalesSucursal (40) f
INNER JOIN sucursales s
ON f.sucu_num = s.sucu_num 
ORDER BY 3 DESC, 2

--------------------------------------------
--PROCEDURES

CREATE PROCEDURE pr_alta_y_mody 
(@cuit CHAR(13), @rSocial NVARCHAR(50)) AS 
BEGIN
	MERGE INTO Clientes A
    USING (
		SELECT @cuit cuit, 
		@rSocial rsocial) B
    ON (A.clie_cuitl = B.cuit)
    WHEN NOT MATCHED THEN
		INSERT VALUES (NULL, B.rsocial, B.cuit, NULL, GETDATE(), null)
    WHEN MATCHED THEN
        UPDATE SET A.clie_apellido_rs = B.rsocial;
END
GO

CREATE PROCEDURE pr_alta_usuario 
(@usuario CHAR(8), @clave VARCHAR(50)) AS 
	INSERT INTO Usuarios 
	(usuario, clave)  VALUES 
	(LOWER(@usuario), HASHBYTES('SHA2_256',@clave))
GO

CREATE PROCEDURE pr_cursores AS 
BEGIN
	DECLARE @idlog INT, @monto NUMERIC(10,2)

	DECLARE c_transfer CURSOR FOR 
	SELECT idlog, monto
	FROM Transferencias
	WHERE confirmado = 'NO'
	ORDER BY idlog DESC

	OPEN c_transfer
	FETCH NEXT FROM c_transfer INTO @idlog, @monto
	WHILE (@@FETCH_STATUS = 0)
	BEGIN

		PRINT CONCAT('ID: ',REPLICATE('0', 10 - LEN(CAST(@idlog AS VARCHAR))),CAST(@idlog AS VARCHAR),SPACE(1), CAST(@monto AS VARCHAR))

		FETCH NEXT FROM c_transfer INTO @idlog, @monto
	END
	CLOSE c_transfer
	DEALLOCATE c_transfer

END
GO

CREATE PROCEDURE pr_calcula_interes 
(@numeroCuenta CHAR(12)) AS 
BEGIN

	DECLARE @interes NUMERIC(10,2)

	EXEC @interes = dbo.fx_calcula_interes @numeroCuenta

	IF @interes < 0.01   
		RETURN 1

	INSERT INTO movimientos 
	(mov_fecha, mov_monto, cue_id, tipo, mov_detalle)
	VALUES
	(GETDATE(), @interes, @numeroCuenta, 'Credito', 'Intereses ganados')

	UPDATE cuentas SET cue_saldo = cue_saldo + @interes
	WHERE cue_numero = @numeroCuenta

END
GO

CREATE PROCEDURE pr_transferencia 
(@origen CHAR(12), @destino CHAR(12), @monto REAL, @retorno VARCHAR(5000) OUTPUT) AS 
BEGIN
	DECLARE @id_log NUMERIC(15,0)

	-- C�digo defensivo
	IF (@origen = @destino) OR (@origen IS NULL) OR (@destino IS NULL) OR (@monto <= 0)	BEGIN
		SET @retorno = '1'
		RETURN
	END

	BEGIN TRANSACTION
		INSERT INTO Transferencias
		(cuen_origen, cuen_destino, monto, fecha, usuario, confirmado)
		VALUES (@origen, @destino, @monto, GETDATE(), CURRENT_USER, 'NO')
	COMMIT TRANSACTION

	BEGIN TRY
		BEGIN TRANSACTION
			SET @id_log = @@IDENTITY

			UPDATE cuentas SET cue_saldo = cue_saldo + @monto
			WHERE cue_numero = @destino

				IF @@ROWCOUNT = 0
				BEGIN
					ROLLBACK TRANSACTION
					SET @retorno = '2'
					RETURN
				END

			UPDATE cuentas SET cue_saldo = cue_saldo - @monto
			WHERE cue_numero = @origen

				IF @@ROWCOUNT = 0
				BEGIN
					ROLLBACK TRANSACTION
					SET @retorno = '3'
					RETURN
				END

			INSERT INTO movimientos
			VALUES
			(GETDATE(), @monto, @destino, 'Credito', 'Transferencia')

			INSERT INTO movimientos
			VALUES
			(GETDATE(), @monto, @origen, 'Debito', 'Transferencia')

			UPDATE Transferencias SET confirmado = 'SI'
			WHERE idlog = @id_log

	
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		IF (SELECT COUNT(*) FROM cuentas WHERE cue_saldo - @monto < dbo.fx_calcula_descubierto(cue_numero) 
		AND cue_numero = @origen) > 0 
			SET @retorno = '4'
		ELSE
			SET @retorno = CAST(ERROR_NUMBER() AS VARCHAR) + ': ' + ERROR_MESSAGE()
		RETURN
	END CATCH
	SET @retorno = '0'
END
GO

DECLARE @retorno VARCHAR(5000)
EXECUTE pr_transferencia '302-151891/6', '302-151892/6', 10, @retorno OUTPUT

--------------------------------------------
-- TRIGGERS

CREATE TRIGGER tr_clientes_validacion
ON clientes
AFTER UPDATE
AS
BEGIN
	IF UPDATE (clie_alta)
		IF (SELECT COUNT(*) FROM DELETED 
		WHERE clie_alta IS NOT NULL) > 0 
			ROLLBACK TRANSACTION
END
GO

CREATE TRIGGER tr_sucursales_validacion
ON sucursales
AFTER INSERT, UPDATE
AS
BEGIN

	IF EXISTS(SELECT 1 
	FROM sucursales S
	WHERE sucu_num IS NOT NULL
	AND EXISTS (SELECT 1 FROM INSERTED I
	WHERE S.banc_codigo = I.banc_codigo AND S.sucu_num = I.sucu_num)
	GROUP BY banc_codigo, sucu_num
	HAVING COUNT(*) > 1) 
		ROLLBACK TRANSACTION
END
GO

CREATE TRIGGER tr_cuentas_validacion
ON cuentas
AFTER UPDATE
AS
BEGIN
	IF EXISTS (SELECT 1 FROM INSERTED I INNER JOIN DELETED D ON I.cue_numero = D.cue_numero 
			   WHERE I.cue_saldo < dbo.fx_calcula_descubierto(I.cue_numero)
			   AND   I.cue_saldo < D.cue_saldo)
			ROLLBACK TRANSACTION
END
GO

CREATE TRIGGER tr_bancos_aft_upd
ON bancos
AFTER UPDATE
AS 
BEGIN

	UPDATE sucursales SET sucu_estado = 0
	WHERE sucu_estado = 1 AND 
	banc_codigo IN (SELECT banc_codigo FROM INSERTED WHERE banc_estado = 0)

END
GO

CREATE TRIGGER tr_cuentas_iof_del
ON cuentas
INSTEAD OF DELETE
AS 
BEGIN

	DELETE FROM movimientos
	WHERE cue_id IN (SELECT cue_numero FROM DELETED)

	DELETE FROM cuentas
	WHERE cue_numero IN (SELECT cue_numero FROM DELETED)

END
GO

CREATE TRIGGER tr_bancos_iof_ins
ON bancos
INSTEAD OF INSERT
AS 
BEGIN
	INSERT INTO bancos (banc_codigo, banc_cuit, banc_nom, banc_estado)
	SELECT banc_codigo, banc_cuit, UPPER(banc_nom), 1 FROM INSERTED	
END
GO

CREATE TRIGGER tr_vwsuc_iof_ins
ON vw_sucursales_bancos
INSTEAD OF INSERT
AS 
BEGIN
	INSERT INTO bancos (banc_codigo, banc_cuit, banc_nom)
	SELECT DISTINCT banc_codigo, banc_cuit, banc_nom FROM INSERTED I
	WHERE NOT EXISTS 
	(SELECT 1 FROM bancos B WHERE B.banc_codigo = I.banc_codigo) 

	INSERT INTO sucursales
	(sucu_id, banc_codigo, sucu_dir, sucu_num, sucu_estado)
	SELECT sucu_id, banc_codigo, sucu_dir, sucu_num, 1 FROM INSERTED

END
GO 

INSERT INTO vw_sucursales_bancos (banc_codigo, banc_cuit, banc_nom, sucu_id, sucu_dir, sucu_num)
VALUES (40, '30-12345600-1', 'UTN Banking', 7, 'Mozart 2300', 107)
USE[GD2015C1]
GO

/*
22)

Se requiere recategorizar los rubros de productos, de forma tal que nigun rubro tenga más de 20 productos asignados,
si un rubro tiene más de 20 productos asignados se deberan distribuir en otros rubros que no tengan mas de 20 productos 
y si no entran se debra crear un nuevo rubro en la misma familia con la descirpción “RUBRO REASIGNADO”, 
cree el/los objetos de base de datos necesarios para que dicha regla de negocio quede implementada.


-- RECATEGORIZAR RUBROS DEL PRODUCTO
-- PARA NINGUN RUBRO QUE TENGA + DE 20 PRODUCTOS 
-- si hay un RUBRO, que tiene mas de 20 productos -> distribuirlos en otros rubros que no tengan + de 20 productos
-- SI NO ENTRAN -> crear un nuevo rubro de la MISMA FAMILIA con descripcion "rubro REASIGNADO"

*/

-- BASICAMENTE LO QUE ACA DEBO HACER ES UN STORE PROCEDURE DEBIDO A QUE DEBO CREAR UNA TABLA RUBRO-reasignado
-- pero ademas este store procedure tendra esa logica de verificar los productos y su rubro



-- VERLO LUEGO


CREATE PROC dbo.Ejercicio22
AS
BEGIN
	declare @rubro char(4)
	declare @cantProdRubro int

	declare cursor_rubro CURSOR FOR SELECT R.rubr_id,COUNT(*)
									FROM rubro R
										INNER JOIN Producto P
											ON P.prod_rubro = R.rubr_id
									GROUP BY R.rubr_id
									HAVING COUNT(*) > 20
	OPEN cursor_rubro
	FETCH NEXT FROM cursor_rubro
	INTO @rubro,@cantProdRubro
	WHILE @@FETCH_STATUS = 0
	BEGIN
		declare @cantProdRubroIndividual int = @cantProdRubro
		declare @prodCod char(8)
		declare @rubroLibre char(4)
		declare cursor_productos CURSOR FOR SELECT prod_codigo
											FROM Producto
											WHERE prod_rubro = @rubro
		OPEN cursor_productos
		FETCH NEXT FROM cursor_productos
		INTO @prodCod
		WHILE @@FETCH_STATUS = 0 OR @cantProdRubroIndividual < 21
		BEGIN
			IF EXISTS(
						SELECT TOP 1 rubr_id
						FROM Rubro
							INNER JOIN Producto
								ON prod_rubro = rubr_id
						GROUP BY rubr_id
						HAVING COUNT(*) < 20
						ORDER BY COUNT(*) ASC
						)
			BEGIN
				SET @rubroLibre = (
									SELECT TOP 1 rubr_id
									FROM Rubro
										INNER JOIN Producto
											ON prod_rubro = rubr_id
									GROUP BY rubr_id
									HAVING COUNT(*) < 20
									ORDER BY COUNT(*) ASC
									)

				UPDATE Producto SET prod_rubro = @rubroLibre WHERE prod_codigo = @prodCod
			END
			ELSE
			BEGIN
				IF NOT EXISTS(
						SELECT rubr_id
						FROM Rubro
						WHERE rubr_detalle = 'Rubro reasignado'
						)  
				INSERT INTO Rubro (RUBR_ID,rubr_detalle) VALUES ('xx','Rubro reasignado')
				UPDATE Producto set prod_rubro = (
													SELECT rubr_id
													FROM Rubro
													WHERE rubr_detalle = 'Rubro reasignado'
												)
				WHERE prod_codigo = @prodCod
			END
			SET @cantProdRubroIndividual -= 1
		FETCH NEXT FROM cursor_productos
		INTO @prodCod
		END
		CLOSE cursor_productos
		DEALLOCATE cursor_productos
	FETCH NEXT FROM cursor_rubro
	INTO @rubro,@cantProdRubro
	END
	CLOSE cursor_rubro
	DEALLOCATE cursor_productos
END
GO
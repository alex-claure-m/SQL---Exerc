ESTOS SON LOS EJERICICOS CORRESPONDIENTE AL 2D0 CUATRIMESTRE
DE GDD
- exitira 2 carpetas 
SQL es SQL que val del ejercicio 1 - 35 (creo - a actualizar)
-- HASTA EL MOMENTO HICE HASTA EL 28 NO INCLUSIVE

T-SQL es Transaction SQL 
-- hasta el ejercicio 16

https://github.com/Danymmereles/GDD-2022

https://github.com/alexclaureM/Exercices-sql/tree/master
---------------------------------------------------------------------------------------

SQL
9)
Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del
mismo y la cantidad de depósitos que ambos tienen asignados.
 ======== lo interesante es el calculo de depositos segun jefe y empleado, por seaprado ===========


10)
Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos 
vendidos en la historia. Además mostrar de esos productos, quien fue el cliente que 
mayor compra realizo.

======================== interesante es el UNION ==========================

12)
Mostrar nombre de producto, cantidad de clientes distintos que lo compraron importe 
promedio pagado por el producto, cantidad de depósitos en los cuales hay stock del 
producto y stock actual del producto en todos los depósitos. Se deberán mostrar 
aquellos productos que hayan tenido operaciones en el año 2012 y los datos deberán 
ordenarse de mayor a menor por monto vendido del producto.
======================= NO ES JODIDO PERO INTERESANTE POR LAS DUDAS ==============


14)
Escriba una consulta que retorne una estadística de ventas por cliente. Los campos que 
debe retornar son:

-Código del cliente
-Cantidad de veces que compro en el último año
-Promedio por compra en el último año
-Cantidad de productos diferentes que compro en el último año
-Monto de la mayor compra que realizo en el último año
Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en 
el último año.
No se deberán visualizar NULLs en ninguna columna

==================== LO INTERESANTE ES LA ULTIMA CONDICION QUE SE DEBE RETORNAR CLIENTES ORDENADOS X CANTIDAD DE VECES Q COMPRO



16)

Con el fin de lanzar una nueva campaña comercial para los clientes que menos compran 
en la empresa, se pide una consulta SQL que retorne aquellos clientes cuyas ventas son 
inferiores a 1/3 del promedio de ventas del producto que más se vendió en el 2012.
Además mostrar
1. Nombre del Cliente
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
3. Código de producto que mayor venta tuvo en el 2012 (en caso de existir más de 1, 
mostrar solamente el de menor código) para ese cliente.

Aclaraciones:
	*La composición es de 2 niveles, es decir, un producto compuesto solo se compone de 
	productos no compuestos.
	
================= MIRAR SOBRE TODO EL PUNTO 3 ======================



17)
Escriba una consulta que retorne una estadística de ventas por año y mes para cada
producto.
La consulta debe retornar:
	PERIODO: Año y mes de la estadística con el formato YYYYMM
	PROD: Código de producto
	DETALLE: Detalle del producto
	CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo
	VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del periodo pero del año anterior
	CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el  periodo

La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada 
por periodo y código de producto

======================= LO INTERESANTE ES VER COMO CALCULE EL PERIODO =========================



	-- ES EXCELENTE ESTE PARA HACER TANTO AL TOP1 - ME REFIERO AL PRODUCTO 1 Y PRODUCTO 2

18)

Escriba una consulta que retorne una estadística de ventas para todos los rubros.
La consulta debe retornar:
	DETALLE_RUBRO: Detalle del rubro
	VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
	PROD1: Código del producto más vendido de dicho rubro
	PROD2: Código del segundo producto más vendido de dicho rubro
	CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30 días



La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada 
por cantidad de productos diferentes vendidos del rubro


==================================================

19)
En virtud de una recategorizacion de productos referida a la familia de los mismos se 
solicita que desarrolle una consulta sql que retorne para todos los productos:
	 Codigo de producto
	 Detalle del producto
	 Codigo de la familia del producto
	 Detalle de la familia actual del producto
	 Codigo de la familia sugerido para el producto
	 Detalla de la familia sugerido para el producto
La familia sugerida para un producto es la que poseen la mayoria de los productos cuyo 
detalle coinciden en los primeros 5 caracteres.

En caso que 2 o mas familias pudieran ser sugeridas se debera seleccionar la de menor 
codigo. Solo se deben mostrar los productos para los cuales la familia actual sea 
diferente a la sugerida
Los resultados deben ser ordenados por detalle de producto de manera ascendente

=============== POR EL TEMA DE LA FMAILIA Y CODIGO FAMILIA SUGERIDA==================


20)

Escriba una consulta sql que retorne un ranking de los mejores 3 empleados del 2012
Se debera retornar legajo, nombre y apellido, anio de ingreso, puntaje 2011, puntaje 
2012. El puntaje de cada empleado se calculara de la siguiente manera: para los que 
hayan vendido al menos 50 facturas el puntaje se calculara como la cantidad de facturas 
que superen los 100 pesos que haya vendido en el año, para los que tengan menos de 50
facturas en el año el calculo del puntaje sera el 50% de cantidad de facturas realizadas 
por sus subordinados directos en dicho año

============ MIRAR EL TEMA DEL PUNTAJE, MUY ROMPEBOLA PERO SIRVE MUCHO EL CASE THEN


23)
 Realizar una consulta SQL que para cada año muestre :
	 Año
	 El producto con composición más vendido para ese año.
	 Cantidad de productos que componen directamente al producto más vendido
	 La cantidad de facturas en las cuales aparece ese producto.
	El código de cliente que más compro ese producto.
	El porcentaje que representa la venta de ese producto respecto al total de venta del año.
El resultado deberá ser ordenado por el total vendido por año en forma descendente.

===================== ACA LO INTERESANTE ES SOBRE EL CALCULO DEL PRODUCTO COMPUESTO + VENDIDO PARA ESE AÑO========



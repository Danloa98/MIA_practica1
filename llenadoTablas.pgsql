create table TEMPORAL(
    NOMBRE_CLIENTE VARCHAR,
    CORREO_CLIENTE VARCHAR,
    CLIENTE_ACTIVO VARCHAR,
    FECHA_CREACION VARCHAR,
    TIENDA_PREFERIDA VARCHAR,
    DIRECCION_CLIENTE VARCHAR,
    CODIGO_POSTAL_CLIENTE VARCHAR,
    CIUDAD_CLIENTE VARCHAR,
    PAIS_CLIENTE VARCHAR,
    FECHA_RENTA VARCHAR,
    FECHA_RETORNO VARCHAR,
    MONTO_A_PAGAR VARCHAR,
    FECHA_PAGO VARCHAR,
    NOMBRE_EMPLEADO VARCHAR,
    CORREO_EMPLEADO VARCHAR,
    EMPLEADO_ACTIVO VARCHAR,
    TIENDA_EMPLEADO VARCHAR,
    USUARIO_EMPLEADO VARCHAR,
    PASSWORD_EMPLEADO VARCHAR,
    DIRECCION_EMPLEADO VARCHAR,
    CODIGO_POSTAL_EMPLEADO VARCHAR,
    CIUDAD_EMPLEADO VARCHAR,
    PAIS_EMPLEADO VARCHAR,
    NOMBRE_TIENDA VARCHAR,
    ENCARGADO_TIENDA VARCHAR,
    DIRECCION_TIENDA VARCHAR,
    CODIGO_POSTAL_TIENDA VARCHAR,
    CIUDAD_TIENDA VARCHAR,
    PAIS_TIENDA VARCHAR,
    TIENDA_PELICULA VARCHAR,
    NOMBRE_PELICULA VARCHAR,
    DESCRIPCION_PELICULA VARCHAR,
    LANZAMIENTO VARCHAR,
    DIAS_RENTA VARCHAR,
    COSTO_RENTA VARCHAR,
    DURACION VARCHAR,
    COSTO_POR_DANO VARCHAR,
    CLASIFICACION VARCHAR,
    LENGUAJE_PELICULA VARCHAR,
    CATEGORIA_PELICUL VARCHAR,
    ACTOR_PELICULA VARCHAR
);



select distinct NOMBRE_PELICULA from temporal ;
SELECT * FROM temporal WHERE  DIAS_RENTA ='5';


SELECT * FROM temporal WHERE LANZAMIENTO = '2006';
SELECT * FROM temporal WHERE NOMBRE_PELICULA LIKE '%A';-- #peliculas que terminan con A

SELECT NOMBRE_EMPLEADO FROM temporal WHERE CODIGO_POSTAL_EMPLEADO IS not NULL;

SELECT NOMBRE_EMPLEADO FROM temporal WHERE CODIGO_POSTAL_EMPLEADO != '-';
SELECT * FROM NOMBRE_EMPLEADO WHERE CODIGO_POSTAL_EMPLEADO != ''  AND ACTOR_PELICULA ='Lady Gaga';

select NOMBRE_EMPLEADO from temporal order by NOMBRE_EMPLEADO;
select PAIS_CLIENTE,PAIS_EMPLEADO,PAIS_TIENDA from temporal;

insert into pais(nombre) values( (select distinct PAIS_CLIENTE from temporal ), (select distinct PAIS_EMPLEADO from temporal ), (select distinct PAIS_TIENDA from temporal )) ;









select distinct PAIS_CLIENTE from temporal where PAIS_CLIENTE <> '-';




--LLENAR TABLA PAIS

  INSERT INTO pais (nombre)
  select distinct PAIS_CLIENTE FROM temporal where PAIS_CLIENTE <> '-'
  UNION
  SELECT  distinct PAIS_EMPLEADO from temporal where PAIS_EMPLEADO <> '-'
  union
   SELECT  distinct PAIS_TIENDA from temporal where PAIS_TIENDA <> '-' ;
  select * from pais p ;
  ALTER SEQUENCE Pais_id_pais_seq   RESTART WITH 1;
  truncate table pais cascade;


  --Llenar Tabla Ciudad
---------------------------------------

INSERT
    INTO ciudad (NOMBRE, ID_PAIS)
SELECT
    NOMBREC, ID_PAIS
FROM
    (
    SELECT
        DISTINCT  CIUDAD_EMPLEADO AS NOMBREC, ID_PAIS
    FROM
        TEMPORAL
    INNER JOIN
        PAIS
    ON
        PAIS_EMPLEADO = NOMBRE
    UNION
    SELECT
        DISTINCT  CIUDAD_TIENDA AS NOMBREC, ID_PAIS
    FROM
        TEMPORAL
    INNER JOIN
        PAIS
    ON
        PAIS_TIENDA = NOMBRE
    UNION
    SELECT
        DISTINCT  CIUDAD_CLIENTE AS NOMBREC, ID_PAIS
    FROM
        TEMPORAL
    INNER JOIN
        PAIS
    ON
        PAIS_CLIENTE = NOMBRE
    ) SUB
WHERE
    NOMBREC
IS NOT
    NULL;


   select * from ciudad ;
 truncate table ciudad cascade;
ALTER SEQUENCE Ciudad_id_ciudad_seq   RESTART WITH 1;
select nombre from ciudad where nombre ='Lethbridge';
-------------------------------------------




--------------------TABLA Direccion-------------------------------
--CAST(DURACION AS int)

insert into direccion(codigo_postal,id_ciudad, direccion)
select distinct CAST(CODIGO_POSTAL_CLIENTE AS int),
ciudad.id_ciudad,
DIRECCION_CLIENTE
from temporal
inner join ciudad ON temporal.ciudad_cliente =ciudad.nombre
where CODIGO_POSTAL_CLIENTE <> '-'

union

select distinct CAST(CODIGO_POSTAL_EMPLEADO AS int),
ciudad.id_ciudad,
DIRECCION_EMPLEADO
from temporal
inner join ciudad ON temporal.ciudad_cliente =ciudad.nombre
where CODIGO_POSTAL_EMPLEADO <> '-'

union

select distinct CAST(CODIGO_POSTAL_TIENDA AS int),
ciudad.id_ciudad,
DIRECCION_TIENDA
from temporal
inner join ciudad ON temporal.ciudad_cliente =ciudad.nombre
where CODIGO_POSTAL_TIENDA <> '-';


insert into direccion (id_ciudad, direccion)
select distinct ciudad.id_ciudad,
DIRECCION_TIENDA
from temporal
inner join ciudad  on temporal.ciudad_tienda =ciudad.nombre
where nombre_tienda <> '-';


insert into direccion (id_ciudad, direccion)
select distinct ciudad.id_ciudad,
DIRECCION_EMPLEADO
from temporal
inner join ciudad  on temporal.ciudad_empleado =ciudad.nombre
where nombre_empleado <> '-';






--como hago para que tambien me tome las idrecciones sin codigo postal?




select * from direccion d ;


DELETE FROM direccion ;



ALTER TABLE direccion
ADD direccion varchar;

ALTER SEQUENCE Direccion_id_direccion_seq   RESTART WITH 1;

select * from direccion ;



-----------ACTOR-----

insert
    into actor (nombre , apellido)
select
    distinct
    (select A[1] from REGEXP_SPLIT_TO_ARRAY(ACTOR_PELICULA, ' ') AS DT(A)) AS nombre ,
    (SELECT A[2] FROM REGEXP_SPLIT_TO_ARRAY(ACTOR_PELICULA, ' ') AS DT(A)) AS apellido
FROM
    TEMPORAL
WHERE
    ACTOR_PELICULA
IS NOT
    null and ACTOR_PELICULA <> '-';

 truncate table actor cascade;
select * from  actor;
ALTER SEQUENCE Actor_id_Actor_seq   RESTART WITH 1;


-------CLASIFICACION----------

insert into clasificacion (tipo)
select distinct CLASIFICACION from temporal
where CLASIFICACION is not null and CLASIFICACION <> '-';

select * from clasificacion;
truncate table clasificacion cascade;
ALTER SEQUENCE Clasificacion_id_clasificacion_seq   RESTART WITH 1;


--------CATEGORIA-----------

insert into categoria (categoria)
select distinct CATEGORIA_PELICUL from temporal
where CATEGORIA_PELICUL is not null and CATEGORIA_PELICUL <> '-';

select * from categoria c ;
ALTER SEQUENCE Categoria_id_categoria_seq   RESTART WITH 1;
truncate table categoria cascade;

--------PELICULA--------------

insert into pelicula (titulo,descripcion,anio_lanzamiento,duracion,dias_renta,costo_renta,costo_damage,id_clasificacion,idioma)
select distinct  NOMBRE_PELICULA, DESCRIPCION_PELICULA , cast (LANZAMIENTO as int), cast(DURACION as int),
cast (DIAS_RENTA as int),
cast (COSTO_RENTA as decimal(10,2)),
cast (COSTO_POR_DANO as decimal(10,2)),
Clasificacion.id_clasificacion,
LENGUAJE_PELICULA
from temporal
inner join clasificacion on temporal.clasificacion=clasificacion.tipo
where LANZAMIENTO <> '-' AND DIAS_RENTA  <> '-' and  DURACION <> '-' and  COSTO_RENTA <> '-' and  COSTO_POR_DANO <> '-';

select * from pelicula ;
ALTER SEQUENCE pelicula_id_pelicula_seq   RESTART WITH 1;
truncate table pelicula;
DELETE FROM pelicula;

-----CATEGORIA PELICULA------



insert into categoriapelicula(id_categoria,id_pelicula)
select distinct cat.id_categoria ,
p.id_pelicula from temporal t
inner join categoria cat
	on cat.categoria  = t.categoria_pelicul
inner join pelicula p
	on p.titulo = t.nombre_pelicula;


select * from categoriapelicula c ;
--------------TRADUCCION----------------------

insert into traduccion (traduccion,id_pelicula)
select distinct LENGUAJE_PELICULA, pelicula.id_pelicula
from temporal
inner join pelicula on temporal.lenguaje_pelicula =pelicula.idioma
where LENGUAJE_PELICULA <> '-';


-------------ACTORPELICULA--------------

insert into actorpelicula (id_actor,id_pelicula)
select distinct cat.id_actor,
p.id_pelicula from temporal t
inner join actor cat
	on concat( cat.nombre, ' ',cat.apellido )= t.actor_pelicula
inner join pelicula p
	on p.titulo = t.nombre_pelicula;


--------------TIENDA------------------------

insert into tienda (id_direccion, nombre)
select distinct d.id_direccion, NOMBRE_TIENDA
from temporal
inner join direccion d on temporal.direccion_tienda= d.direccion
where NOMBRE_TIENDA <> '-';

select * from tienda;


select * from direccion d ;


-------------INVENTARIO--------------------

insert into inventario (id_tienda,id_pelicula)
select distinct cat.id_tienda ,
p.id_pelicula from temporal t
inner join tienda cat
	on cat.nombre  = t.nombre_tienda
inner join pelicula p
	on p.titulo = t.nombre_pelicula;


--***********************

select * from inventario i ;

delete from inventario ;

ALTER SEQUENCE inventario_id_pelicula_seq   RESTART WITH 1;
select * from  pelicula p ;

select id_pelicula ,titulo from pelicula where titulo ='SUGAR WONKA';

--860 no esta en tienda 2
--910 TREATMENT JEKYLL

-------------TABLA EMPLEADO-------


insert into empleado (nombre,apellido,id_direccion,correo,estado,username,ppassword,id_tienda)
select distinct
    (select A[1] from REGEXP_SPLIT_TO_ARRAY(NOMBRE_EMPLEADO, ' ') AS DT(A)) AS nombre ,
    (SELECT A[2] FROM REGEXP_SPLIT_TO_ARRAY(NOMBRE_EMPLEADO, ' ') AS DT(A)) AS apellido,
    direccion.id_direccion ,
    CORREO_EMPLEADO,
    EMPLEADO_ACTIVO,
    USUARIO_EMPLEADO,
    PASSWORD_EMPLEADO,
    tienda.id_tienda
    from temporal
    inner join direccion on temporal.direccion_empleado =direccion.direccion
    inner join tienda on temporal.tienda_empleado = tienda.nombre
    where nombre_empleado <> '-';

   select * from empleado;

  delete from empleado ;


  ALTER SEQUENCE Direccion_id_direccion_seq   RESTART WITH 1;

---------------------TABLA PUESTO------------------------------------

----------------TABLA CLIENTE------------------------------------

 insert into cliente (nombre,apellido,correo,id_direccion,fecha_registro,estado,id_tienda)
 select distinct
      (select A[1] from REGEXP_SPLIT_TO_ARRAY(NOMBRE_CLIENTE, ' ') AS DT(A)) AS nombre ,
      (SELECT A[2] FROM REGEXP_SPLIT_TO_ARRAY(NOMBRE_CLIENTE, ' ') AS DT(A)) AS apellido,
      CORREO_CLIENTE,
      direccion.id_direccion,
      cast(FECHA_CREACION as date),
      CLIENTE_ACTIVO,
      tienda.id_tienda
      from temporal
      inner join direccion on temporal.direccion_cliente= direccion.direccion
      inner join tienda on temporal.tienda_preferida = tienda.nombre
      where nombre_cliente <> '-' and CORREO_CLIENTE <> '-' and CLIENTE_ACTIVO <> '-';

     select * from cliente;
      select distinct nombre, apellido from cliente c ;

    delete from cliente ;
     ALTER SEQUENCE Cliente_id_cliente_seq   RESTART WITH 1;

    SELECT concat( nombre, ' ',apellido ) , COUNT(concat( nombre, ' ',apellido ))
FROM cliente
GROUP BY concat( nombre, ' ',apellido )
HAVING COUNT(concat( nombre, ' ',apellido ))>1

--Mattie Hoffman
  --    Cecil Vines estan repetidos por alguna razon xd en total son 599 clientes :D podria eliminar los repeated clientes?


 select distinct nombre_Cliente from temporal t ;


 ---------------TABLA RENTA----------------------------


insert into renta (monto,fecha_pago,id_empleado,fecha_renta,fecha_devolucion,id_cliente,id_pelicula)
select distinct cast (MONTO_A_PAGAR as decimal(10,2)),
cast (FECHA_PAGO as date),
empleado.id_empleado,
cast(FECHA_RENTA as date),
cast(FECHA_RETORNO as date),
cliente.id_cliente,
pelicula.id_pelicula
from temporal
inner join empleado on temporal.nombre_empleado = concat( empleado.nombre, ' ',empleado.apellido )
inner join cliente on temporal.nombre_cliente = concat( cliente.nombre, ' ',cliente.apellido )
inner join pelicula on temporal.nombre_pelicula =pelicula.titulo
where nombre_empleado <> '-' and nombre_cliente <> '-' and nombre_pelicula <> '-' and FECHA_RENTA <> '-' and FECHA_RETORNO <> '-' and MONTO_A_PAGAR <> '-'
and FECHA_PAGO <> '-';

select * from renta ;
select count(*) from renta ;

    delete from renta ;
     ALTER SEQUENCE Renta_id_renta_seq   RESTART WITH 1;


SELECT
    monto,fecha_pago,fecha_renta,fecha_devolucion COUNT (monto,fecha_pago,fecha_renta,fecha_devolucion)
FROM
    renta
GROUP BY
    monto,fecha_pago,fecha_renta,fecha_devolucion
HAVING
    COUNT(*) > 1;


-------------------------------------












 --CONSULTA 1------
SELECT count(titulo)
FROM inventario
inner join pelicula  on pelicula.id_pelicula=inventario.id_pelicula
WHERE titulo = 'SUGAR WONKA';

























select dist, cod_postal,id_ciudad from(
select distinct direccion_empleado as dist, codigo_postal_empleado as cod_postal , id_ciudad from temporal
    inner join ciudad
    on ciudad_empleado = nombre)X
where dist <> '-' and cod_postal <> '-';


select dist, cod_postal,id_ciudad from(
select distinct direccion_tienda as dist, CODIGO_POSTAL_TIENDA as cod_postal , id_ciudad from temporal
    inner join ciudad
    on ciudad_tienda = nombre)X
where dist <> '-' and cod_postal <> '-';


select  direccion_tienda from temporal ;
select  distinct direccion_tienda from temporal  where nombre_tienda  <> '-';



select * from temporal t ;



select  distinct temporal.direccion_empleado from temporal where nombre_empleado <> '-';


--NO tomemo en cuenta el codigo postal de la tienda alv thats the fucking KEY

select distinct temporal.direccion_tienda from temporal where nombre_tienda <> '-';

select distinct temporal.codigo_postal_empleado from temporal where codigo_postal_empleado <> '-' and nombre_empleado <>'-';

select distinct temporal.direccion_cliente from temporal where codigo_postal_cliente <> '-' and nombre_cliente <>'-';
select distinct temporal.direccion_empleado from temporal where nombre_empleado <>'-';






























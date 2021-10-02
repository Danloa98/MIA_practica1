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


 truncate table ciudad cascade;
ALTER SEQUENCE Ciudad_id_ciudad_seq   RESTART WITH 1;
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

select * from direccion d ;


 truncate table ciudad cascade;
ALTER SEQUENCE Ciudad_id_ciudad_seq   RESTART WITH 1;

DELETE FROM direccion ;



ALTER TABLE direccion
ADD direccion varchar;

ALTER SEQUENCE Direccion_id_direccion_seq   RESTART WITH 1;



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

insert into categoriapelicula (id_pelicula,id_categoria)
select distinct pelicula.id_pelicula , categoria.id_categoria
from pelicula
inner join pelicula on pelicula.id_pelicula=pelicula.id_pelicula
inner join categoria on categoria.id_categoria =categoria.id_categoria ;



--------------TRADUCCION----------------------

insert into traduccion (traduccion,id_pelicula)
select distinct LENGUAJE_PELICULA, pelicula.id_pelicula
from temporal
inner join pelicula on temporal.lenguaje_pelicula =pelicula.idioma
where LENGUAJE_PELICULA <> '-';


---------------------------









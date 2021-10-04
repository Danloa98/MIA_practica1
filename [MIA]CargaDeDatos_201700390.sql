---------LLENAR TABLA PAIS------

  INSERT INTO pais (nombre)
  select distinct PAIS_CLIENTE FROM temporal where PAIS_CLIENTE <> '-'
  UNION         
  SELECT  distinct PAIS_EMPLEADO from temporal where PAIS_EMPLEADO <> '-'
  union
   SELECT  distinct PAIS_TIENDA from temporal where PAIS_TIENDA <> '-' ;
   
   
   
---------------CIUDAD-------------

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
    
    
    
    
    
    
    --------------------TABLA Direccion-------------------------------


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
    
    
    
    -------CLASIFICACION----------

insert into clasificacion (tipo)
select distinct CLASIFICACION from temporal 
where CLASIFICACION is not null and CLASIFICACION <> '-';


--------CATEGORIA-----------

insert into categoria (categoria)
select distinct CATEGORIA_PELICUL from temporal 
where CATEGORIA_PELICUL is not null and CATEGORIA_PELICUL <> '-'; 


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




-----CATEGORIA PELICULA------



insert into categoriapelicula(id_categoria,id_pelicula)
select distinct cat.id_categoria ,
p.id_pelicula from temporal t
inner join categoria cat 
	on cat.categoria  = t.categoria_pelicul
inner join pelicula p
	on p.titulo = t.nombre_pelicula;



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


-------------INVENTARIO--------------------

insert into inventario (id_tienda,id_pelicula)
select distinct cat.id_tienda ,
p.id_pelicula from temporal t
inner join tienda cat 
	on cat.nombre  = t.nombre_tienda 
inner join pelicula p
	on p.titulo = t.nombre_pelicula;
	
	
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

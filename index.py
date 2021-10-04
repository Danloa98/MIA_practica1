from flask import Flask,jsonify,json
from flask_sqlalchemy import SQLAlchemy
import psycopg2
from psycopg2._json import Json
from psycopg2.extensions import register_adapter
import decimal


#connect to the db
from psycopg2.extras import RealDictCursor

con=psycopg2.connect(
    host="localhost",
    database="miaPractica1",
    user="postgres",
    password="password")


app=Flask(__name__)

@app.route('/')

@app.route('/test',methods=['GET'])

def test():
    cur=con.cursor(cursor_factory=RealDictCursor)
    cur.execute("select * from TEMPORAL limit 10;")
    rows = cur.fetchall()
    result=jsonify(rows)

    return result


@app.route('/eliminarTemporal',methods=['GET'])
def eliminarTemporal():
    cur=con.cursor(cursor_factory=RealDictCursor)
    cur.execute("TRUNCATE TABLE TEMPORAL;")
    con.commit()
    cur.close()
    return {'status':'temporal elminada con exito'}




@app.route('/cargarTemporal',methods=['GET'])
def cargarTemporal():
    cur = con.cursor(cursor_factory=RealDictCursor)

    cur.execute(
        "copy TEMPORAL FROM '/home/daniel/Desktop/PRACTICA1/BlockbusterData.csv' DELIMITER ';' CSV HEADER ENCODING 'WIN1252';")
    con.commit()
    cur.close()
    return {'status': 'temporal cargada con exito'}



@app.route('/eliminarModelo',methods=['GET'])
def eliminarModelo():
    cur=con.cursor(cursor_factory=RealDictCursor)
    cur.execute("""
    
drop table renta;
drop table cliente;
drop table puesto;
drop table empleado;
drop table inventario;
drop table tienda;
drop table direccion;
drop table ciudad;
drop table pais;
drop table actorpelicula;
drop table actor;
drop table categoriapelicula;
drop table categoria;
drop table traduccion;
drop table pelicula;
drop table clasificacion;
    
    """)
    con.commit()
    cur.close()
    con.close()
    return {'status':'modelo elminado con exito'}



@app.route('/cargarModelo',methods=['GET'])
def cargarModelo():
    cur = con.cursor(cursor_factory=RealDictCursor)

    cur.execute(
        """
      create table Pais(
id_pais serial primary key,
nombre varchar(50)
);

create table Ciudad(
id_ciudad serial primary key,
nombre varchar(50),
id_pais int,
foreign key (id_pais) references Pais(id_pais)
);

create table Direccion(
id_direccion serial primary key,
distrito varchar(50),
codigo_postal int,
id_ciudad int,
foreign key (id_ciudad) references Ciudad(id_ciudad)
);

ALTER TABLE direccion 
ADD direccion varchar; 


create table Actor(
id_actor serial primary key,
nombre varchar(50),
apellido varchar(50)
);

create table Clasificacion(
id_clasificacion serial primary key,
tipo varchar(50)
);

create table Categoria(
id_categoria serial primary key,
categoria varchar(50)
);

create table Pelicula(
id_pelicula serial primary key,
titulo varchar(50),
descripcion varchar(500),
anio_lanzamiento int,
duracion int,
dias_renta int,
costo_renta decimal(10,2),
costo_damage decimal(10,2),
id_clasificacion int,
idioma varchar (50),
foreign key (id_clasificacion) references Clasificacion(id_clasificacion)
);

create table CategoriaPelicula(
id_pelicula int,
id_categoria int,
primary key(id_pelicula,id_categoria),
foreign key (id_pelicula) references Pelicula(id_pelicula),
foreign key (id_categoria) references Categoria(id_categoria)
);


create table Traduccion (
id_traduccion serial primary key,
traduccion varchar(20),
id_pelicula int,
foreign key (id_pelicula) references Pelicula(id_pelicula)
);


create table actorpelicula(
id_actor int not null,
id_pelicula int not null,
primary key(id_actor,id_pelicula),
foreign key (id_actor) references Actor(id_actor),
foreign key (id_pelicula) references Pelicula(id_pelicula)
);


create table Tienda(
id_tienda serial primary key,
id_direccion int,
nombre varchar(50),
foreign key (id_direccion) references Direccion(id_direccion)
);


create table Inventario(
id_tienda int,
id_pelicula int,
primary key (id_tienda,id_pelicula),
foreign key (id_tienda) references Tienda(id_tienda),
foreign key (id_pelicula) references Pelicula(id_pelicula)
);


create table Empleado(
id_empleado serial primary key,
nombre varchar(50),
apellido varchar(50),
id_direccion int,
correo varchar(100),
estado varchar(10),
username varchar(50),
ppassword varchar(100),
id_tienda int,
foreign key (id_direccion) references Direccion(id_direccion),
foreign key (id_tienda) references Tienda(id_tienda)
);

create table Puesto(
id_tienda int,
id_empleado int,
puesto varchar(50),
primary key(id_tienda,id_empleado),
foreign key (id_tienda) references Tienda(id_tienda),
foreign key (id_empleado) references Empleado(id_empleado)
);



create table Cliente(
id_cliente serial primary key,
nombre varchar(50),
apellido varchar(50),
correo varchar(100),
id_direccion int,
fecha_registro date,
estado varchar(10),
id_tienda int,
foreign key (id_direccion) references Direccion(id_direccion),
foreign key (id_tienda) references Tienda(id_tienda)
);


create table Renta(
id_renta serial primary key,
monto decimal(10,2),
fecha_pago date,
id_empleado int,
fecha_renta date,
fecha_devolucion date,
id_cliente int,
id_pelicula int,
foreign key (id_empleado) references Empleado(id_empleado),
foreign key (id_cliente) references Cliente(id_cliente),
foreign key (id_pelicula) references Pelicula(id_pelicula)
);



---------LLENAR TABLA PAIS

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
    
        """)
    con.commit()
    cur.close()
    return {'status': 'Modelo cargado con exito'}




@app.route('/consulta1',methods=['GET'])
def consulta1():
    try:
        cur = con.cursor(cursor_factory=RealDictCursor)
        cur.execute("""SELECT count(titulo) FROM inventario 
        inner join pelicula  on pelicula.id_pelicula=inventario.id_pelicula
         WHERE titulo = 'SUGAR WONKA';""")
        rows = cur.fetchall()
        result = jsonify(rows)
        con.commit()
        cur.close()
        return result
    except:
        return {'status': 'Query no fue posible realizar'}



@app.route('/consulta2',methods=['GET'])
def consulta2():
    cur = con.cursor(cursor_factory=RealDictCursor)

    cur.execute("""select distinct cliente.nombre, cliente.apellido,
    cast(Sum(renta.monto)as float)as TOTAL,
    count(renta.id_cliente) As CANTIDAD_RENTADA from renta, cliente
where cliente.id_cliente=renta.id_cliente 
group by  
    renta.id_cliente, cliente.nombre, cliente.apellido
HAVING
	count(renta.id_cliente) >= 40 ; """)
    rows = cur.fetchall()
    result=json.jsonify(rows)
    con.commit()
    cur.close()
    return result



@app.route('/consulta3',methods=['GET'])
def consulta3():
    cur = con.cursor(cursor_factory=RealDictCursor)

    cur.execute("""
        select 
    concat( actor.nombre, ' ' ,actor.apellido) as Actor
from 
    actor
where 
    actor.apellido like '%son%'
group by 
    actor.nombre, actor.apellido 
order by
    actor.nombre
;
    
    """)
    rows = cur.fetchall()
    result=json.jsonify(rows)
    con.commit()
    cur.close()
    return result








@app.route('/consulta4',methods=['GET'])
def consulta4():
    cur = con.cursor(cursor_factory=RealDictCursor)

    cur.execute("""
    

select distinct
    actor.nombre as nombre,
    actor.apellido as apellido,
    pelicula.anio_lanzamiento,
    pelicula.titulo
from
    actor,
    pelicula,
    actorpelicula
where
    actorpelicula.id_pelicula=pelicula.id_pelicula and
    lower(pelicula.descripcion) like '%crocodile%' and
    lower(pelicula.descripcion) like '%shark%' and
    actor.id_actor =actorpelicula.id_actor

group by
    actor.nombre,
    actor.apellido,
    pelicula.anio_lanzamiento,
    pelicula.titulo
order by
    actor.apellido asc

;

    
    
    """)
    rows = cur.fetchall()
    result=jsonify(rows)
    con.commit()
    cur.close()
    return result





@app.route('/consulta5',methods=['GET'])
def consulta5():
    cur = con.cursor(cursor_factory=RealDictCursor)

    cur.execute("""
    
    select T.Nombre,
T.pais,
T.rentas,
concat((T.rentas*100)/(select
  cast(COUNT(renta.id_cliente) as decimal(10,2)) AS rentadas
FROM
  renta
inner join cliente
	on cliente.id_cliente = renta.id_cliente
inner join direccion
	on direccion.id_direccion = cliente.id_direccion
inner join ciudad
	on ciudad.id_ciudad = direccion.id_ciudad
inner join pais
	on pais.id_pais = ciudad.id_pais
	where pais.nombre = T.pais),' ','%') Porcentaje
from (
SELECT
  renta.id_cliente as id_renta,
  cliente.nombre as Nombre,
  pais.nombre as Pais,
  COUNT(renta.id_cliente) rentas
FROM
  renta
inner join cliente
	on cliente.id_cliente = renta.id_cliente
inner join direccion
	on direccion.id_direccion = cliente.id_direccion
inner join ciudad
	on ciudad.id_ciudad = direccion.id_ciudad
inner join pais
	on pais.id_pais = ciudad.id_pais
GROUP BY
 renta.id_cliente,
 cliente.nombre,
 pais.nombre
ORDER BY
  rentas desc)T
 group by T.pais,
T.Nombre,
T.rentas
order by
T.rentas desc
limit 1;
    

     
     """)
    rows = cur.fetchall()
    result=jsonify(rows)
    con.commit()
    cur.close()
    return result


@app.route('/consulta6', methods=['GET'])
def consulta6():
    cur = con.cursor(cursor_factory=RealDictCursor)

    cur.execute("""
select T.Nombre,
T.pais,
T.ciudad,
T.rentas,
concat((T.rentas*100)/(select
  cast(COUNT(renta.id_cliente) as decimal(10,2)) AS rentadas
FROM
  renta 
inner join cliente
	on cliente.id_cliente = renta.id_cliente
inner join direccion
	on direccion.id_direccion = cliente.id_direccion
inner join ciudad
	on ciudad.id_ciudad = direccion.id_ciudad
inner join pais
	on pais.id_pais = ciudad.id_pais
	where pais.nombre = T.pais),' ','%') Porcentaje
from ( 
SELECT
  renta.id_cliente as id_renta,
  cliente.nombre as Nombre,
  pais.nombre as Pais,
  ciudad.nombre as ciudad,
  COUNT(renta.id_cliente) rentas
FROM
  renta 
inner join cliente
	on cliente.id_cliente = renta.id_cliente
inner join direccion
	on direccion.id_direccion = cliente.id_direccion
inner join ciudad
	on ciudad.id_ciudad = direccion.id_ciudad
inner join pais
	on pais.id_pais = ciudad.id_pais 
GROUP BY 
 renta.id_cliente, 
 cliente.nombre,
 pais.nombre,
 ciudad.nombre
ORDER BY 
  rentas desc)T
 group by T.pais,
T.Nombre,
T.rentas,
T.ciudad
order by 
T.rentas desc;


    """)
    rows = cur.fetchall()
    result = json.jsonify(rows)
    con.commit()
    cur.close()
    return result


@app.route('/consulta7', methods=['GET'])
def consulta7():
    cur = con.cursor(cursor_factory=RealDictCursor)

    cur.execute("""

------consulta 7------------
select T.pais pais,
T.ciudad ciudad,
(select
  COUNT(renta.id_cliente) AS rentadas
FROM
  renta
inner join cliente
	on cliente.id_cliente = renta.id_cliente
inner join direccion
	on direccion.id_direccion = cliente.id_direccion
inner join ciudad
	on ciudad.id_ciudad = direccion.id_ciudad
inner join pais
	on pais.id_pais = ciudad.id_pais
where ciudad.nombre = T.ciudad)
/
(select x.cont from (
select T2.pais,cast(count(T2.ciudad) as float) cont from(
select distinct p.nombre Pais,
c.nombre Ciudad
from renta r
inner join cliente cli
	on cli.id_cliente = r.id_cliente
inner join direccion d
	on d.id_direccion = cli.id_cliente
inner join ciudad c
	on c.id_ciudad = d.id_ciudad
inner join pais p
	on p.id_pais = c.id_pais)T2
where T2.pais = T.pais
group by T2.pais)x) Media from

(select distinct p.nombre Pais,
c.nombre Ciudad
from renta r
inner join cliente cli
	on cli.id_cliente = r.id_cliente
inner join direccion d
	on d.id_direccion = cli.id_cliente
inner join ciudad c
	on c.id_ciudad = d.id_ciudad
inner join pais p
	on p.id_pais = c.id_pais)T
group by
T.pais,
T.ciudad;


    """)
    rows = cur.fetchall()
    result = json.jsonify(rows)
    con.commit()
    cur.close()
    return result




@app.route('/consulta9', methods=['GET'])
def consulta9():
    cur = con.cursor(cursor_factory=RealDictCursor)

    cur.execute("""


select t.pais,
t.ciudad,
t.rentadas from( 
select
  pais.nombre pais,
  ciudad.nombre ciudad,
  COUNT(renta.id_cliente) AS rentadas
FROM
  renta 
inner join cliente
	on cliente.id_cliente = renta.id_cliente
inner join direccion
	on direccion.id_direccion = cliente.id_direccion
inner join ciudad
	on ciudad.id_ciudad = direccion.id_ciudad
inner join pais
	on pais.id_pais = ciudad.id_pais
where lower(pais.nombre) = 'united states' and lower(ciudad.nombre) <> 'dayton'
group by ciudad.nombre,
pais.nombre) t
where t.rentadas > (select
	  COUNT(renta.id_cliente) AS rentadas
	FROM
	  renta 
	inner join cliente
		on cliente.id_cliente = renta.id_cliente
	inner join direccion
		on direccion.id_direccion = cliente.id_direccion
	inner join ciudad
		on ciudad.id_ciudad = direccion.id_ciudad
	inner join pais
		on pais.id_pais = ciudad.id_pais
	where lower(pais.nombre) = 'united states' and lower(ciudad.nombre) = 'dayton')
group by t.pais,
t.ciudad,
t.rentadas;



    """)
    rows = cur.fetchall()
    result = jsonify(rows)
    con.commit()
    cur.close()
    return result


if __name__=='__main__':
    app.run(debug=True)









#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
-----CONSULTA 1----

SELECT count(titulo)
FROM inventario
inner join pelicula  on pelicula.id_pelicula=inventario.id_pelicula
WHERE titulo = 'SUGAR WONKA';






---CONSULTA 2------



---------consulta como tal----------------
select distinct renta.id_cliente ,
    cliente.nombre, cliente.apellido,
    Sum(renta.monto)as total,
    count(renta.id_cliente) As cantidad
from
    renta,
    cliente
where
    cliente.id_cliente=renta.id_cliente
group by
    renta.id_cliente, cliente.nombre, cliente.apellido
HAVING
	count(renta.id_cliente) >= 40 ;
--------------------------------------------------------





---------------CONSULTA 3----------------------

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



---------------CONSULTA 4------------------------------

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




--------------CONSULTA 5------------------------

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






------- CONSULTA 6------



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





------------CONSULTA 8---------------------






------------CONSULTA 9 ---------------------


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






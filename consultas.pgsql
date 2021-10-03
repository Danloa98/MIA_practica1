-----CONSULTA 1----

SELECT count(titulo)
FROM inventario
inner join pelicula  on pelicula.id_pelicula=inventario.id_pelicula
WHERE titulo = 'SUGAR WONKA';






---CONSULTA 2------

SELECT id_cliente , COUNT(id_cliente)
FROM renta
GROUP BY id_cliente
HAVING COUNT(id_cliente)>=40;

select * from renta ;



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
--shaw, peters, dean, hunt, seal, bull


SELECT renta.id_cliente
FROM renta
inner join cliente on cliente.id_cliente =renta.id_cliente
WHERE concat(nombre,' ', apellido ) = 'Mattie Hoffman';

---id 91 y 92

---id 404 y  403 para mattie hoffman

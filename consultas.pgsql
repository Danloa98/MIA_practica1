-----CONSULTA 1----

SELECT count(titulo)
FROM inventario
inner join pelicula  on pelicula.id_pelicula=inventario.id_pelicula
WHERE titulo = 'SUGAR WONKA';



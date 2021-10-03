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


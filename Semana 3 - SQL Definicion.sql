-- CREAR BASE DE DATOS
CREATE DATABASE Ventas_Tech_DB;
GO
USE Ventas_Tech_DB;
GO

--CREAR TABLAS
CREATE TABLE categorias (
	id_categoria INT PRIMARY KEY,
	nombre_categoria VARCHAR(50) NOT NULL,
	descripcion VARCHAR(200)
	);

CREATE TABLE productos (
	id_producto INT PRIMARY KEY,
	nombre_producto VARCHAR(100) NOT NULL,
	id_categoria INT,
	precio DECIMAL(10,2) NOT NULL,
	stock INT DEFAULT 0,
	activo BIT DEFAULT 1, --1 Activo 0 Inactivo
	FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
	);

CREATE TABLE ventas (
	id_venta INT PRIMARY KEY,
	id_cliente INT,
	id_producto INT,
	cantidad INT NOT NULL,
	precio_unitario DECIMAL(10,2) NOT NULL,
	fecha_venta DATE NOT NULL,
	FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
	FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
	);

CREATE TABLE clientes (
	id_cliente INT PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL,
	ciudad VARCHAR(50),
	fecha_registro DATE NOT NULL	
	);

-- INSERTAR DATOS EN LA BD

-- 1er insercion
INSERT INTO categorias VALUES(1,'Computacion','Laptop, PC, Monitores');

INSERT INTO productos VALUES(1,'Laptop Pro 15 Lenovo',1,1200.00,15,1)

INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio) VALUES (2,'MOUSE',1,12.00); 

SELECT * FROM productos

--DML y TCL

-- SEGURO
UPDATE productos SET precio = 1150 WHERE id_producto = 1;
SELECT * FROM productos;

-- PELIGROSO
BEGIN TRANSACTION;
UPDATE productos SET precio = 10.99; --sin WHERE
SELECT * FROM productos;

-- La salvacion
ROLLBACK;
SELECT * FROM productos;

-- ALTER TABLE

ALTER TABLE clientes ADD telefono VARCHAR(20);
SELECT * FROM clientes;


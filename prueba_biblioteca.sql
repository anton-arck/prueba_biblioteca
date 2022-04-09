------------------------------------------Prueba Modulo 7 Biblioteca-----------------
-- Creación de base de datos
CREATE DATABASE biblioteca;

-- Creación de tablas: socios, libros, historial_prestamo. 

CREATE TABLE socios(
        rut VARCHAR(10) PRIMARY KEY,
        nombre VARCHAR(20) NOT NULL,
        apellido VARCHAR(20) NOT NULL,
        direccion VARCHAR(50) NOT NULL,
        telefono VARCHAR(9) NOT NULL
);


CREATE TABLE libros(
	isbn BIGINT PRIMARY KEY,
	titulo VARCHAR(50) NOT NULL,
	num_pag INT NOT NULL
);

CREATE TABLE autores(
        cod_autor SERIAL PRIMARY KEY,
        nombre_autor VARCHAR(20) NOT NULL,
        apellido_autor VARCHAR(20) NOT NULL,
        ano_nacimiento INT,
		ano_muerte INT,
        tipo_autor VARCHAR(15) NOT NULL
);


CREATE TABLE historial_prestamos(
        id SERIAL PRIMARY KEY,
        rut_id VARCHAR(10) NOT NULL,
        isbn_id BIGINT NOT NULL,
        fecha_prestamo DATE NOT NULL,
        fecha_dev DATE NOT NULL,
        dias_atraso INT,
        multa INT,
        FOREIGN KEY (isbn_id) REFERENCES libros(isbn),
        FOREIGN KEY (rut_id) REFERENCES socios(rut)
);

CREATE TABLE libro_autor(
	isbn_id BIGINT,
	cod_autor_id INT, 
	FOREIGN KEY (isbn_id) REFERENCES libros(isbn),
	FOREIGN KEY (cod_autor_id) REFERENCES autores(cod_autor)
);


-- Ingreso de datos

INSERT INTO libros(isbn,titulo,num_pag)
VALUES
(1111111111111,'CUENTOS DE TERROR',344),
(2222222222222,'POESÍAS CONTEMPORANEAS',167),
(3333333333333,'HISTORIA DE ASIA',511),
(4444444444444,'MANUAL DE MECÁNICA',298);

INSERT INTO socios(rut,nombre,apellido,direccion,telefono)
VALUES
('1111111-1', 'JUAN', 'SOTO', 'AVENIDA 1, SANTIAGO', 911111111),
('2222222-2', 'ANA', 'PÉREZ', 'PASAJE 2, SANTIAGO', 922222222),
('3333333-3', 'SANDRA', 'AGUILAR', 'AVENIDA 2, SANTIAGO', 933333333),
('4444444-4', 'ESTEBAN', 'JEREZ', 'AVENIDA 3, SANTIAGO', 944444444),
('5555555-5', 'SILVANA', 'MUÑOZ', 'PASAJE 3, SANTIAGO', 955555555);

INSERT INTO historial_prestamos(id,rut_id,isbn_id,fecha_prestamo,fecha_dev)
VALUES
(1,'1111111-1',1111111111111,'2020-01-20','2020-01-27'),
(2,'5555555-5',3333333333333,'2020-01-20','2020-01-27'),
(3,'3333333-3',4444444444444,'2020-01-22','2020-01-30'),
(4,'4444444-4',4444444444444,'2020-01-23','2020-01-30'),
(5,'2222222-2',1111111111111,'2020-01-27','2020-02-04'),
(6,'1111111-1',4444444444444,'2020-01-31','2020-02-12'),
(7,'3333333-3',2222222222222,'2020-01-31','2020-02-12');

INSERT INTO autores(cod_autor, nombre_autor, apellido_autor,ano_nacimiento,ano_muerte, tipo_autor)
VALUES
(1, 'ANDRÉS', 'ULLOA', 1982-01-01,NULL,'PRINCIPAL'),
(2,'SERGIO','MARDONES',1950-01-01,2012-01-01,'PRINCIAL'),
(3, 'JOSE', 'SALGADO', 1968-01-01,2020-01-01,'PRINCIPAL'),
(4, 'ANA', 'SALGADO', 1972,NULL,'COAUTOR'),
(5,'MARTIN','PORTA',1976-01-01,NULL,'PRINCIPAL');


-- CONSULTAS A LA BASE DE DATOS
-- a. Mostrar todos los libros que posean menos de 300 páginas.
SELECT * FROM libros WHERE num_pag < 300;



-- b. Mostrar todos los autores que hayan nacido después del 01-01-1970.
SELECT nombre_autor, apellido_autor FROM autores WHERE ano_nacimiento > 1970-01-01;

-- c. ¿Cuál es el libro más solicitado?
SELECT COUNT (historial_prestamos.isbn_id), historial_prestamos.isbn_id, libros.titulo
FROM historial_prestamos
INNER JOIN libros ON historial_prestamos.isbn_id = libros.isbn
GROUP BY historial_prestamos.isbn_id, libros.titulo
ORDER BY count (*)
DESC LIMIT 1;
-- d. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto
-- debería pagar cada usuario que entregue el préstamo después de 7 días.
SELECT rut_id,(((fecha_dev::DATE - fecha_prestamo::DATE)-7)*100) AS Multa
FROM historial_prestamos;

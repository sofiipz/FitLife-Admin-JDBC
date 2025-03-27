DROP DATABASE IF EXISTS FitLife;
CREATE DATABASE FitLife;
USE FitLife;


CREATE TABLE socios (
	id_socio INT PRIMARY KEY AUTO_INCREMENT,
    dni VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    primer_apellido VARCHAR(50) NOT NULL,
    segundo_apellido VARCHAR(50),
    telefono VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    direccion TEXT NOT NULL,
    fecha_inscripcion DATE NOT NULL
);

-- añadir columnas a la tabla socios ya creada
ALTER TABLE socios ADD COLUMN estado ENUM ('Activo', 'Inactivo') NOT NULL;
ALTER TABLE socios ADD COLUMN fecha_inactivo DATE;


CREATE TABLE plan_pago (
	id_plan INT PRIMARY KEY AUTO_INCREMENT,
    tipo_plan ENUM('Básico', 'Premium', 'Familiar') NOT NULL,
    descripcion_plan TEXT NOT NULL,
    precio DECIMAL(10,2) NOT NULL
    
);

-- como socios y plan_pago tienen una relación 1:M, hay que alterar la tabla socios para añadir la FK de plan_pago
ALTER TABLE socios ADD COLUMN id_plan INT;
ALTER TABLE socios ADD FOREIGN KEY (id_plan) REFERENCES plan_pago(id_plan) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE pagos (
	id_pago INT PRIMARY KEY AUTO_INCREMENT,
    cantidad_pago DECIMAL(10,2) NOT NULL,
    fecha_pago DATE NOT NULL,
    metodo_pago ENUM ('Efectivo', 'Tarjeta', 'Transferencia') NOT NULL,
    id_socio INT,
    FOREIGN KEY (id_socio) REFERENCES socios(id_socio) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE entrenadores (
	id_entrenador INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    primer_apellido VARCHAR(50) NOT NULL,
    segundo_apellido VARCHAR(50) NOT NULL,
    especialidad ENUM('Entrenador de sala', 'Entrenador de clase'),
    salario DOUBLE NOT NULL DEFAULT 1.500,
    fecha_contratacion DATE NOT NULL
);

-- Una vez creada la tabla entrenadores, se altera para añadir una columna nueva
ALTER TABLE entrenadores ADD COLUMN fecha_baja DATE;

CREATE TABLE clases (
	id_clase INT PRIMARY KEY AUTO_INCREMENT,
	nombre_clase ENUM('Spinning', 'Pilates', 'HIIT') NOT NULL,
    día ENUM ('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado') NOT NULL,
    hora ENUM ('9:00', '10:00', '11:00', '16:00', '17:00', '18:00') NOT NULL,
    participantes INT NOT NULL DEFAULT 10,
    id_entrenador INT,
    FOREIGN KEY (id_entrenador) REFERENCES entrenadores(id_entrenador) ON DELETE CASCADE ON UPDATE CASCADE
);


-- como las tablas clases y socios tienen una relación M:M, se crea una tabla intermedia con sus FK
CREATE TABLE socio_clase(
	id_socio INT,
    id_clase INT,
    PRIMARY KEY(id_socio, id_clase),
    FOREIGN KEY (id_socio) REFERENCES socios(id_socio) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_clase) REFERENCES clases(id_clase) ON DELETE CASCADE ON UPDATE CASCADE
);

-- segundo ejercicio: insertar datos

-- primero se insertan los datos de la tabla plan_pago para poder utilizar el id_plan en la tabla de socios
INSERT INTO plan_pago(id_plan, tipo_plan, descripcion_plan, precio)
VALUES
	(1, 'Básico', 'Acceso limitado a las instalaciones...', 25.00),
    (2, 'Premium', 'Acceso total a todas las instalaciones...', 50.00),
    (3, 'Familiar', 'Varios miembros de la familia...', 75.00);
    

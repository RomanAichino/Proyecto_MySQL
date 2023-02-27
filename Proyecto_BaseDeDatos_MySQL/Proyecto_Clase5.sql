USE PROYECTO_MYQSL;
 
 -- Creé una tabla que permita realizar el seguimiento de los usuarios que ingresan nuevos registros en fact_venta
 
DROP TABLE IF EXISTS fact_venta_auditoria;
CREATE TABLE IF NOT EXISTS fact_venta_auditoria (
	Fecha				DATE,
	Fecha_Entrega		DATE,
  	IdCanal 			INTEGER,
    IdSucursal			INTEGER,
  	IdProducto 			INTEGER,
    IdCliente 			INTEGER,
  	IdEmpleado 			INTEGER,
    usuario 			VARCHAR(20),
    fechaModificacion 	DATETIME
);

-- Creé una acción que permita la carga de datos en la tabla anterior.

DROP TRIGGER IF EXISTS fanc_venta_auditoria;
CREATE TRIGGER fanc_venta_auditoria AFTER INSERT ON fact_venta
for each row
INSERT INTO fact_venta_auditoria (Fecha, Fecha_Entrega, IdCanal, IdSucursal, IdProducto, IdCliente, IdEmpleado, usuario, fechaModificacion)
VALUES (NEW.Fecha, NEW.FechaEntrega, NEW.IdCanal, NEW.IdSucursal, NEW.IdProducto, NEW.IdCliente, NEW.IdEmpleado, CURRENT_USER,NOW());

-- Creé una tabla que permita registrar la cantidad total registros, luego de cada ingreso la tabla fact_venta

DROP TABLE IF EXISTS fact_venta_registros;
CREATE TABLE IF NOT EXISTS fact_venta_registros (
  	id 	INT NOT NULL AUTO_INCREMENT,
	CantidadRegistros INT,
	Usuario VARCHAR (20),
	Fecha DATETIME,
	PRIMARY KEY (id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Creé una acción que permita la carga de datos en la tabla anterior.
DROP TRIGGER IF EXISTS fact_venta_registros;
CREATE TRIGGER fact_venta_registros AFTER INSERT ON fact_venta
FOR EACH ROW
INSERT INTO fact_inicial_registros (CantidadRegistros,Usuario, Fecha)
VALUES ((SELECT COUNT(*) FROM fact_venta),CURRENT_USER,NOW());

-- Creé una tabla que agrupe los datos de la tabla del item 3, a su vez crear un proceso de carga de los datos agrupados

DROP TABLE IF EXISTS registros_tablas;
CREATE TABLE registros_tablas (
Id INT NOT NULL AUTO_INCREMENT,
Tabla VARCHAR(30),
Fecha DATETIME,
CantidadRegistros INT,
PRIMARY KEY (Id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO registros_tablas (tabla, fecha, cantidadRegistros)
SELECT 'venta', Now(), COUNT(*) FROM venta;
INSERT INTO registros_tablas (tabla, fecha, cantidadRegistros)
SELECT 'gasto', Now(), COUNT(*) FROM gasto;
INSERT INTO registros_tablas (tabla, fecha, cantidadRegistros)
SELECT 'compra', Now(), COUNT(*) FROM compra;

-- SHOW TRIGGERS;

-- Creé una tabla que permita realizar el seguimiento de la actualización de registros de la tabla fact_venta
DROP TABLE IF EXISTS fact_venta_cambios;
CREATE TABLE IF NOT EXISTS fact_venta_cambios (
  	Fecha 			DATE,
  	IdCliente 		INTEGER,
  	IdProducto 		INTEGER,
    Precio 			DECIMAL(15,3),
    Cantidad		INTEGER
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Creé una acción que permita la carga de datos en la tabla anterior, para su actualización
DROP TRIGGER IF EXISTS Auditoria_Cambios;
CREATE TRIGGER Auditoria_Cambios AFTER UPDATE ON fact_venta_cambios
for each row
INSERT INTO fact_venta_cambios (Fecha, IdCliente, IdProducto, Precio, Cantidad)
VALUES (OLD.Fecha,OLD.IdCliente, OLD.IdProducto, OLD.Precio, OLD.Cantidad);

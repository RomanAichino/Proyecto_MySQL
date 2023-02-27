USE PROYECTO_MYQSL;

-- Empezamos arreglando los nombres de algunas de las columnas en las tablas

ALTER TABLE Clientes  CHANGE ID IdCliente INT(11) NOT NULL;
ALTER TABLE Empleados CHANGE IDEMPLEADO IdEmpleado INT(11) NOT NULL;
ALTER TABLE Empleados CHANGE Salario Salario2 VARCHAR(100);
ALTER TABLE Productos CHANGE Concepto Producto VARCHAR(100);
ALTER TABLE Gasto 	  CHANGE IDGasto IdGasto INT(11) NOT NULL;
ALTER TABLE Productos CHANGE IDProducto IdProducto INT(11) NOT NULL;
ALTER TABLE Proveedores CHANGE IDProveedores IdProveedor INT(11) NOT NULL;
ALTER TABLE Proveedores CHANGE City Ciudad VARCHAR(100);
ALTER TABLE Proveedores CHANGE State Provincia VARCHAR(100);
ALTER TABLE Proveedores CHANGE Country Pais VARCHAR(100);
ALTER TABLE Proveedores CHANGE Address Domicilio VARCHAR(100);
ALTER TABLE Proveedores CHANGE Departament Departamento VARCHAR(100);
ALTER TABLE Sucursales CHANGE ID IdSucursal INT(11) NOT NULL;
ALTER TABLE Sucursales CHANGE Latitud Latitud2 VARCHAR(100);
ALTER TABLE Sucursales CHANGE Longitud Longitud2 VARCHAR(100);

-- Aca ademas de arreglar el nombre tambien lo convierto en float, ya que puede resultarnos útil

ALTER TABLE Empleados ADD Salario DECIMAL(10,2) NOT NULL default '0';
UPDATE Empleados SET Salario = REPLACE (Salario2, ',', '.');
ALTER TABLE Empleados Drop Salario2;

ALTER TABLE Sucursales 	ADD Latitud DECIMAL(13,10) NOT NULL DEFAULT '0' AFTER Longitud2, 
						ADD Longitud DECIMAL(13,10) NOT NULL DEFAULT '0' AFTER Latitud;
UPDATE sucursales SET Latitud = REPLACE(Latitud2,',','.');
UPDATE sucursales SET Longitud = REPLACE(Longitud2,',','.');

ALTER TABLE sucursales DROP Latitud2;
ALTER TABLE sucursales DROP Longitud2;

-- Sigo modificando nombres

ALTER TABLE Venta CHANGE IDVenta IdVenta INT(11) NOT NULL;
ALTER TABLE Venta CHANGE IDCanal IdCanal INT(11) NOT NULL;
ALTER TABLE Venta CHANGE IDCliente IdCliente INT(11) NOT NULL;
ALTER TABLE Venta CHANGE IDSucursal IdSucursal INT(11) NOT NULL;
ALTER TABLE Venta CHANGE IDEmpleado IdEmpleado INT(11) NOT NULL;
ALTER TABLE Venta CHANGE IDProducto IdProducto INT(11) NOT NULL;

-- Relleno tablas vacias

UPDATE venta set Precio = 0 WHERE Precio = '';
ALTER TABLE venta CHANGE Precio Precio DECIMAL(15,3) NOT NULL DEFAULT '0';

UPDATE clientes SET Domicilio = 'Sin Dato' WHERE TRIM(Domicilio) = "" OR ISNULL(Domicilio);
UPDATE clientes SET Localidad = 'Sin Dato' WHERE TRIM(Localidad) = "" OR ISNULL(Localidad);
UPDATE clientes SET NombreApellido = 'Sin Dato' WHERE TRIM(NombreApellido) = "" OR ISNULL(NombreApellido);
UPDATE clientes SET Provincia = 'Sin Dato' WHERE TRIM(Provincia) = "" OR ISNULL(Provincia);

UPDATE empleados SET Apellido = 'Sin Dato' WHERE TRIM(Apellido) = "" OR ISNULL(Apellido);
UPDATE empleados SET Nombre = 'Sin Dato' WHERE TRIM(Nombre) = "" OR ISNULL(Nombre);
UPDATE empleados SET Sucursal = 'Sin Dato' WHERE TRIM(Sucursal) = "" OR ISNULL(Sucursal);
UPDATE empleados SET Sector = 'Sin Dato' WHERE TRIM(Sector) = "" OR ISNULL(Sector);
UPDATE empleados SET Cargo = 'Sin Dato' WHERE TRIM(Cargo) = "" OR ISNULL(Cargo);

UPDATE productos SET Producto = 'Sin Dato' WHERE TRIM(Producto) = "" OR ISNULL(Producto);
UPDATE productos SET Tipo = 'Sin Dato' WHERE TRIM(Tipo) = "" OR ISNULL(Tipo);

UPDATE proveedores SET Nombre = 'Sin Dato' WHERE TRIM(Nombre) = "" OR ISNULL(Nombre);
UPDATE proveedores SET Domicilio = 'Sin Dato' WHERE TRIM(Domicilio) = "" OR ISNULL(Domicilio);
UPDATE proveedores SET Ciudad = 'Sin Dato' WHERE TRIM(Ciudad) = "" OR ISNULL(Ciudad);
UPDATE proveedores SET Provincia = 'Sin Dato' WHERE TRIM(Provincia) = "" OR ISNULL(Provincia);
UPDATE proveedores SET Pais = 'Sin Dato' WHERE TRIM(Pais) = "" OR ISNULL(Pais);
UPDATE proveedores SET Departamento = 'Sin Dato' WHERE TRIM(Departamento) = "" OR ISNULL(Departamento);

UPDATE sucursales SET Direccion = 'Sin Dato' WHERE TRIM(Direccion) = "" OR ISNULL(Direccion);
UPDATE sucursales SET Sucursal = 'Sin Dato' WHERE TRIM(Sucursal) = "" OR ISNULL(Sucursal);
UPDATE sucursales SET Provincia = 'Sin Dato' WHERE TRIM(Provincia) = "" OR ISNULL(Provincia);
UPDATE sucursales SET Localidad = 'Sin Dato' WHERE TRIM(Localidad) = "" OR ISNULL(Localidad);

-- Dropeo columnas inútiles

ALTER TABLE clientes DROP col10;

-- Tabla ventas limpieza y normalizacion

UPDATE venta v
JOIN productos p ON (v.IdProducto = p.IdProducto) 
SET v.Precio = p.Precio
WHERE v.Precio = 0;

/*Tabla auxiliar donde se guardarán registros con problemas:
1-Cantidad en Cero
*/
DROP TABLE IF EXISTS aux_venta;
CREATE TABLE IF NOT EXISTS aux_venta (
  IdVenta				INTEGER,
  Fecha 				DATE NOT NULL,
  Fecha_Entrega 		DATE NOT NULL,
  IdCliente				INTEGER, 
  IdSucursal			INTEGER,
  IdEmpleado			INTEGER,
  IdProducto			INTEGER,
  Precio				FLOAT,
  Cantidad				INTEGER,
  Motivo				INTEGER
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

UPDATE venta SET Cantidad = REPLACE(Cantidad, '\r', '');

INSERT INTO aux_venta (IdVenta, Fecha, Fecha_Entrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, Cantidad, Motivo)
SELECT IdVenta, Fecha, FechaEntrega, IdCliente, IdSucursal, IdEmpleado, IdProducto, Precio, 0, 1
FROM venta WHERE Cantidad = '' or Cantidad is null;

UPDATE venta SET Cantidad = '1' WHERE Cantidad = '' or Cantidad is null;
ALTER TABLE venta CHANGE Cantidad Cantidad INTEGER NOT NULL DEFAULT '0';

-- Chequeo de claves duplicadas 
-- SELECT IdCliente, COUNT(*) FROM clientes GROUP BY IdCliente HAVING COUNT(*) > 1;
-- SELECT IdSucursal, COUNT(*) FROM sucursales GROUP BY IdSucursal HAVING COUNT(*) > 1;
-- SELECT IdEmpleado, COUNT(*) FROM empleados GROUP BY IdEmpleado HAVING COUNT(*) > 1;
-- SELECT IdProveedor, COUNT(*) FROM proveedores GROUP BY IdProveedor HAVING COUNT(*) > 1;
-- SELECT IdProducto, COUNT(*) FROM productos GROUP BY IdProducto HAVING COUNT(*) > 1;

-- modificación de columnas en tablas, cambiando nombres por IDs para una mayor optimizacion
ALTER TABLE empleados ADD IdSucursal INT NULL DEFAULT '0' AFTER Sucursal;

UPDATE empleados e
JOIN sucursales s ON (e.Sucursal = s.Sucursal)
SET e.IdSucursal = s.IdSucursal;

ALTER TABLE empleados DROP Sucursal;

ALTER TABLE empleados ADD CodigoEmpleado INT NULL DEFAULT '0' AFTER IdEmpleado;

UPDATE empleados SET CodigoEmpleado = IdEmpleado;
UPDATE empleados SET IdEmpleado = (IdSucursal * 1000000) + CodigoEmpleado; /*esto es para poder diferenciar los empleados 
																			que trabajan en distintas sucursales*/
                                                                            
-- Chequeo de claves duplicadas
-- SELECT IdEmpleado, COUNT(*) FROM empleados GROUP BY IdEmpleado HAVING COUNT(*) > 1;

UPDATE venta SET IdEmpleado = (IdSucursal * 1000000) + IdEmpleado;

-- Normalizacion tabla empleado
DROP TABLE IF EXISTS cargo;
CREATE TABLE IF NOT EXISTS cargo (
  IdCargo integer NOT NULL AUTO_INCREMENT,
  Cargo varchar(50) NOT NULL,
  PRIMARY KEY (IdCargo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

DROP TABLE IF EXISTS sector;
CREATE TABLE IF NOT EXISTS sector (
  IdSector INTEGER NOT NULL AUTO_INCREMENT,
  Sector VARCHAR(50) NOT NULL,
  PRIMARY KEY (IdSector)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO cargo (Cargo) SELECT DISTINCT Cargo FROM empleados ORDER BY 1;
INSERT INTO sector (Sector) SELECT DISTINCT Sector FROM empleados ORDER BY 1;

ALTER TABLE empleados 	ADD IdSector INT NOT NULL DEFAULT '0' AFTER IdSucursal, 
						ADD IdCargo INT NOT NULL DEFAULT '0' AFTER IdSector;

UPDATE empleados e JOIN cargo c ON (c.Cargo = e.Cargo) SET e.IdCargo = c.IdCargo;
UPDATE empleados e JOIN sector s ON (s.Sector = e.Sector) SET e.IdSector = s.IdSector;

ALTER TABLE empleados DROP Cargo;
ALTER TABLE empleados DROP Sector;

-- Normalización tabla producto

ALTER TABLE productos ADD IdTipoProducto INT NOT NULL DEFAULT '0' AFTER Precio;

DROP TABLE IF EXISTS tipo_producto;
CREATE TABLE IF NOT EXISTS tipo_producto (
  IdTipoProducto int(11) NOT NULL AUTO_INCREMENT,
  TipoProducto varchar(50) NOT NULL,
  PRIMARY KEY (IdTipoProducto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO tipo_producto (TipoProducto) SELECT DISTINCT Tipo FROM productos ORDER BY 1;

UPDATE productos p JOIN tipo_producto t ON (p.Tipo = t.TipoProducto) SET p.IdTipoProducto = t.IdTipoProducto;

ALTER TABLE productos DROP Tipo;

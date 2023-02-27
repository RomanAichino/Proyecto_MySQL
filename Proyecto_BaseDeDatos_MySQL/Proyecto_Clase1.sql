CREATE DATABASE PROYECTO_MYQSL;
USE PROYECTO_MYQSL;

-- SELECT @@global.secure_file_priv; -----> (Esto lo hice para enviar las tablas a una carpeta donde me permitiera posteriormente cargar las tablas)

CREATE TABLE CanalDeVenta (
	ID INT,
    Descripcion VARCHAR(40),
    primary key (ID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CanalDeVenta.csv'
INTO TABLE CanalDeVenta
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1
LINES (ID, Descripcion);

-- 

CREATE TABLE Clientes (
	ID INT,
    Provincia VARCHAR(70),
    NombreApellido VARCHAR (80),
	Domicilio VARCHAR (250),
    Telefono VARCHAR(30),
    Edad INT,
    Localidad VARCHAR(80),
    X VARCHAR(30),
    Y VARCHAR(30),
    Col10 VARCHAR (30),
    primary key (ID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Clientes.csv'
INTO TABLE Clientes
FIELDS TERMINATED BY ';' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1
LINES (ID, Provincia, NombreApellido, Domicilio, Telefono, Edad, Localidad, X, Y, Col10);

-- 

CREATE TABLE Compra (
	ID INT,
    Fecha DATE,
    IDProducto INT,
	Cantidad INT,
    Precio DOUBLE,
    IDProveedor INT,
    primary key (ID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Compra.csv'
INTO TABLE Compra
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1
LINES (ID, Fecha, IDProducto, Cantidad, Precio, IDProveedor);

-- 

CREATE TABLE Empleados (
	IDEmpleado INT,
    Apellido VARCHAR(50),
    Nombre VARCHAR(50),
    Sucursal VARCHAR(50),
    Sector VARCHAR(50),
    Cargo VARCHAR(70),
    Salario varchar(30)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Empleados1.csv'
INTO TABLE Empleados
FIELDS TERMINATED BY '|' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1
LINES (IDEmpleado, Apellido, Nombre, Sucursal, Sector, Cargo, Salario);

-- 

CREATE TABLE Gasto (
	IDGasto INT,
    IDSucursal INT,
    IDTipoGasto INT,
    Fecha DATE,
    Monto DOUBLE,
    primary key (IDGasto)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Gasto.csv'
INTO TABLE Gasto
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1
LINES (IDGasto, IDSucursal, IDTipoGasto, Fecha, Monto);

-- 

CREATE TABLE Productos (
	IDProducto INT,
    Concepto VARCHAR(80),
    Tipo VARCHAR(50),
    Precio DOUBLE,
    primary key (IDProducto)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Productos.csv'
INTO TABLE Productos
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1
LINES (IDProducto, Concepto, Tipo, Precio);

-- 

CREATE TABLE Proveedores (
	IDProveedores INT,
    Nombre VARCHAR(70),
    Address VARCHAR(70),
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    Departament VARCHAR(50),
    primary key (IDProveedores)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Proveedores.csv'
INTO TABLE Proveedores
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1
LINES (IDProveedores, Nombre, Address, City, State, Country, Departament);

-- 

CREATE TABLE Sucursales (
	ID INT,
    Sucursal VARCHAR(40),
    Direccion VARCHAR(80),
    Localidad VARCHAR(60),
    Provincia VARCHAR(60),
    Latitud VARCHAR(20),
    Longitud VARCHAR(20),
    primary key (ID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Sucursales.csv'
INTO TABLE Sucursales
FIELDS TERMINATED BY ';' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1
LINES (ID, Sucursal, Direccion, Localidad, Provincia, Latitud, Longitud);	

-- 

CREATE TABLE TiposDeGasto (
	IDTipoGasto INT,
    Descripcion VARCHAR(30),
    MontoAproximado INT,
    primary key (IDTipoGasto)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\TiposDeGasto.csv'
INTO TABLE TiposDeGasto
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1
LINES (IDTipoGasto, Descripcion, MontoAproximado);

-- 

CREATE TABLE Venta (
	IDVenta INT,
    Fecha DATE,
    FechaEntrega DATE,
	IDCanal INT,
    IDCliente INT,
    IDSucursal INT,
    IDEmpleado INT,
    IDProducto INT,
    Precio VARCHAR(30),
    Cantidad VARCHAR(30),
    primary key (IDVenta)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Venta.csv'
INTO TABLE Venta
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY ''
LINES TERMINATED BY '\n' IGNORE 1
LINES (IDVenta, Fecha, FechaEntrega, IDCanal, IDCliente, IDSucursal, IDEmpleado, IDProducto, Precio, Cantidad);

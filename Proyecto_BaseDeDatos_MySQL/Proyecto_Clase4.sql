USE PROYECTO_MYQSL;
-- Empiezo creando algunas Querys para probar el rendimiento de la base de datos

/* 
1
Select count(e.idEmpleado) as Cantidad, s.Sector as Sector
FROM Empleados e
JOIN Sector s ON (e.IdSector = s.IdSector)
Group BY e.IdSector
Order by Cantidad DESC;

2
SELECT count(v.IdCanal) as Cantidad, c.Descripcion as Canal
FROM Venta v
Join CanalDeVenta c ON (v.IdCanal = c.ID)
Group by v.IdCanal
Order by Cantidad DESC;

3
SELECT count(v.IdVenta) as 'Cantidad de ventas', c.RangoEdad as 'Rango de edad de los clientes', SUM(Precio) as 'Dinero de las ventas', sum(Cantidad) as 'Cantidad de productos vendidos'
FROM Clientes c
JOIN Venta v ON (c.IdCliente = v.IdCliente)
Group by c.RangoEdad;
*/

-- Agregar primary key a las tablas que no lo tengan

ALTER TABLE Empleados ADD PRIMARY KEY (IdEmpleado);
ALTER TABLE Clientes  CHANGE IdLocalidad IdLocalidad INT(11) NOT NULL;
ALTER TABLE proveedores  CHANGE IdLocalidad IdLocalidad INT(11) NOT NULL;
ALTER TABLE proveedores  CHANGE IdProvincia IdProvincia INT(11) NOT NULL;
ALTER TABLE Sucursales  CHANGE IdLocalidad IdLocalidad INT(11) NOT NULL;
ALTER TABLE Sucursales  CHANGE IdProvincia IdProvincia INT(11) NOT NULL;
-- Comienzo a añadir indices
CREATE INDEX FECHA1 ON Venta (Fecha);
CREATE INDEX Cliente ON Venta (IdCliente);
CREATE INDEX Canal ON Venta (IdCanal);
CREATE INDEX Sucursal ON Venta (IdSucursal);
CREATE INDEX Empleado ON Venta (IdEmpleado);

CREATE INDEX Fecha ON Compra (Fecha);
CREATE INDEX Producto ON Compra (IdProducto);
CREATE INDEX Proveedor ON Compra (IdProveedor);

CREATE INDEX Sucursal ON Empleados (IdSucursal);
CREATE INDEX Sector ON Empleados (IdSector);
CREATE INDEX Cargo ON Empleados (IdCargo);

CREATE INDEX TipoProducto ON Productos (IdTipoProducto);

-- y ahora vuelvo a probar las Querys, obteniendo un resultado con un 50% de rendimiento a favor

-- nueva tabla para almacenar datos de ventas
DROP TABLE IF EXISTS fact_venta;
CREATE TABLE fact_venta (
	IdVenta INT NOT NULL auto_increment,
	Fecha date,
    FechaEntrega date,
    IdCanal INT,
	IdSucursal INT,
	IdProducto INT,
	IdCliente int,
    IdEmpleado INT,
	Precio DOUBLE,
	Cantidad INT,
	Primary key (Idventa)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;


INSERT INTO fact_venta (Fecha, FechaEntrega,IdCanal,  IdSucursal, IdProducto, IdCliente, IdEmpleado, Precio, Cantidad)
SELECT Fecha, FechaEntrega,IdCanal, IdSucursal, IdProducto, IdCliente, IdEmpleado, Precio, Cantidad
FROM Venta;

-- Ahora relaciono las tablas con FOREIGN KEYs
ALTER TABLE venta ADD CONSTRAINT venta_fk_cliente FOREIGN KEY (IdCliente) REFERENCES clientes (IdCliente) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT venta_fk_sucursa FOREIGN KEY (IdSucursal) REFERENCES sucursales (IdSucursal) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT venta_fk_producto FOREIGN KEY (IdProducto) REFERENCES productos (IdProducto) ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ALTER TABLE venta ADD CONSTRAINT venta_fk_empleado FOREIGN KEY (IdEmpleado) REFERENCES empleados (IdEmpleado) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE venta ADD CONSTRAINT venta_fk_canal FOREIGN KEY (IdCanal) REFERENCES canaldeventa (ID) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE productos ADD CONSTRAINT producto_fk_tipoproducto FOREIGN KEY (IdTipoProducto) REFERENCES tipo_producto (IdTipoProducto) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE empleados ADD CONSTRAINT empleado_fk_sector FOREIGN KEY (IdSector) REFERENCES sector (IdSector) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE empleados ADD CONSTRAINT empleado_fk_cargo FOREIGN KEY (IdCargo) REFERENCES cargo (IdCargo) ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ALTER TABLE empleados ADD CONSTRAINT empleado_fk_sucursal FOREIGN KEY (IdSucursal) REFERENCES sucursales (IdSucursal) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE clientes ADD CONSTRAINT cliente_fk_localidad FOREIGN KEY (IdLocalidad) REFERENCES localidades (IdLocalidad) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE proveedores ADD CONSTRAINT proveedor_fk_localidad FOREIGN KEY (IdLocalidad) REFERENCES localidades (IdLocalidad) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE sucursales ADD CONSTRAINT sucursal_fk_localidad FOREIGN KEY (IdLocalidad) REFERENCES localidades (IdLocalidad) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE localidades ADD CONSTRAINT localidad_fk_provincia FOREIGN KEY (IdProvincia) REFERENCES provincias (IdProvincia) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE compra ADD CONSTRAINT compra_fk_producto FOREIGN KEY (IdProducto) REFERENCES productos (IdProducto) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE compra ADD CONSTRAINT compra_fk_proveedor FOREIGN KEY (IdProveedor) REFERENCES proveedores (IdProveedor) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE gasto ADD CONSTRAINT gasto_fk_sucursal FOREIGN KEY (IdSucursal) REFERENCES sucursales (IdSucursal) ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE gasto ADD CONSTRAINT gasto_fk_tipogasto FOREIGN KEY (IdTipoGasto) REFERENCES tiposdegasto (IdTipoGasto) ON DELETE RESTRICT ON UPDATE RESTRICT;

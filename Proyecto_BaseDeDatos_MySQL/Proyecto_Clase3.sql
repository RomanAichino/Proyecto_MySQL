USE PROYECTO_MYQSL;

CREATE TABLE Localidades (
IdLocalidad INT NOT NULL AUTO_INCREMENT,
Localidad VARCHAR (100),
Provincia Varchar (60),
primary key (IdLocalidad)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;


-- Normalizar los nombres de todas las provincias y ciudades...

UPDATE Proveedores
SET Provincia = 'Buenos Aires'
WHERE Provincia = 'CABA';
UPDATE Proveedores
SET Provincia = 'Buenos Aires'
WHERE Provincia = 'BUENOS AIRES';

UPDATE Sucursales
SET Provincia = 'Buenos Aires'
WHERE Provincia like '%CABA%';
UPDATE Sucursales
SET Provincia = 'Buenos Aires'
WHERE Provincia like '%BUENOS AIRES%';
UPDATE Sucursales
SET Provincia = 'Buenos Aires'
WHERE Provincia like '%BS AS%';
UPDATE Sucursales
SET Provincia = 'Buenos Aires'
WHERE Provincia like '%bs as%';
UPDATE Sucursales
SET Provincia = 'Buenos Aires'
WHERE Provincia like '%B.%';
UPDATE Sucursales
SET Provincia = 'Buenos Aires'
WHERE Provincia like '%Bs%';


-- Paso todas las Provincias y Localidades a mayuscula para una mayor legibilidad
UPDATE Sucursales
SET Provincia = upper(Provincia);
UPDATE clientes
SET Provincia = upper(Provincia);
UPDATE proveedores
SET Provincia = upper(Provincia);
UPDATE Sucursales
SET Localidad = upper(Localidad);


UPDATE Sucursales
SET Provincia = 'CORDOBA'
WHERE Provincia = 'CÓRDOBA';

UPDATE Sucursales
SET Localidad = 'CABA'
WHERE Localidad like '%BUENOS%';
UPDATE Sucursales
SET Localidad = 'CABA'
WHERE Localidad like '%CAP%';
UPDATE Sucursales
SET Localidad = 'CORDOBA'
WHERE Localidad like '%OBA%';

-- Cargar la tabla Localidades
INSERT INTO Localidades (Localidad, Provincia)
SELECT DISTINCT Localidad, Provincia
FROM sucursales;

INSERT INTO Localidades (Localidad, Provincia) 
SELECT DISTINCT Ciudad, Provincia
FROM Proveedores WHERE NOT EXISTS(select 1 from Localidades Where Localidad= Ciudad AND Provincia= Provincia);-- sos un capo por hacer esto

ALTER TABLE Clientes CHANGE Localidad Ciudad VARCHAR(100);
INSERT INTO Localidades (Localidad, Provincia) 
SELECT DISTINCT Ciudad, Provincia
FROM Clientes WHERE NOT EXISTS(select 1 from Localidades Where Localidad= Ciudad AND Provincia= Provincia);

-- Discretizo la edad de los clientes para una mayor privacidad

ALTER TABLE Clientes ADD RangoEdad VARCHAR(15) NULL DEFAULT '0' AFTER Edad;
Update Clientes
Set RangoEdad = 'Menor a 25'
WHERE Edad <= 25;
Update Clientes
Set RangoEdad = '26-35'
WHERE Edad > 25 and Edad <= 35;
Update Clientes
Set RangoEdad = '36-45'
WHERE Edad > 35 and Edad <= 45;
Update Clientes
Set RangoEdad = '46-55'
WHERE Edad > 45 and Edad <= 55;
Update Clientes
Set RangoEdad = 'Mayor a 55'
WHERE Edad > 55;

ALTER TABLE Clientes
DROP Edad;

-- creo una tabla de provincias para normalizar 

CREATE TABLE Provincias (
	IdProvincia INT NOT NULL AUTO_INCREMENT,
	Provincia VARCHAR(50) not null,
	Primary KEY (IdProvincia)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

INSERT INTO Provincias (Provincia)
SELECT DISTINCT Provincia
FROM Localidades;

ALTER TABLE Localidades ADD IdProvincia INT NOT NULL DEFAULT 0 AFTER Localidad;
UPDATE Localidades l
JOIN Provincias p ON (l.Provincia = p.Provincia)
SET l.IdProvincia = p.IdProvincia;

UPDATE Sucursales s
JOIN Localidades l ON (s.Provincia = l.Provincia)
SET s.Provincia = l.IdProvincia;
ALTER TABLE Sucursales CHANGE Provincia IdProvincia VARCHAR(100);
ALTER TABLE Sucursales CHANGE Localidad IdLocalidad VARCHAR(100);

UPDATE Clientes s
JOIN Localidades l ON (s.Provincia = l.Provincia)
SET s.Provincia = l.IdProvincia;
ALTER TABLE Clientes CHANGE Provincia IdProvincia VARCHAR(100);
ALTER TABLE Clientes CHANGE Ciudad IdLocalidad VARCHAR(100);

UPDATE Proveedores s
JOIN Localidades l ON (s.Provincia = l.Provincia)
SET s.Provincia = l.IdProvincia;
ALTER TABLE Proveedores CHANGE Provincia IdProvincia VARCHAR(100);
ALTER TABLE Proveedores CHANGE Ciudad IdLocalidad VARCHAR(100);

UPDATE Clientes s
JOIN Localidades l ON (s.IdLocalidad = l.Localidad)
SET s.IdLocalidad = l.IdLocalidad;

UPDATE Sucursales s
JOIN Localidades l ON (s.IdLocalidad = l.Localidad)
SET s.IdLocalidad = l.IdLocalidad;

UPDATE Proveedores s
JOIN Localidades l ON (s.IdLocalidad = l.Localidad)
SET s.IdLocalidad = l.IdLocalidad;


-- Detección de Outliers   --------->  (ESTA PARTE NO LA ENTENDÍ DEL TODO BIEN, ASÍ QUE ES COPIADA)   <---------
/* 
SELECT v.*, o.promedio, o.maximo, o.minimo
from venta v
JOIN (SELECT IdProducto, avg(Precio) as promedio, avg(Precio) + (3 * stddev(Precio)) as maximo,
						avg(Precio) - (3 * stddev(Precio)) as minimo
	from venta
	GROUP BY IdProducto) o
ON (v.IdProducto = o.IdProducto)
WHERE v.Precio > o.maximo OR v.Precio < minimo;

SELECT *
FROM venta
WHERE IdProducto = 42890;

SELECT v.*, o.promedio, o.maximo, o.minimo 
from venta v
JOIN (SELECT IdProducto, avg(Cantidad) as promedio, avg(Cantidad) + (3 * stddev(Cantidad)) as maximo,
						avg(Cantidad) - (3 * stddev(Cantidad)) as minimo
	from venta
	GROUP BY IdProducto) o
ON (v.IdProducto = o.IdProducto)
WHERE v.Cantidad > o.maximo OR v.Cantidad < o.minimo;

SELECT *
FROM venta
WHERE IdProducto = 42883;

Select cantidad, count(*)
from venta
group by cantidad
ORDER BY 1;

-- Introducimos los outliers de cantidad en la tabla aux_venta

INSERT into aux_venta
select v.IdVenta, v.Fecha, v.Fecha_Entrega, v.IdCliente, v.IdSucursal, v.IdEmpleado,
v.IdProducto, v.Precio, v.Cantidad, 2
from venta v
JOIN (SELECT IdProducto, avg(Cantidad) as promedio, stddev(Cantidad) as Desv
	from venta
	GROUP BY IdProducto) v2
ON (v.IdProducto = v2.IdProducto)
WHERE v.Cantidad > (v2.Promedio + (3*v2.Desv)) OR v.Cantidad < (v2.Promedio - (3*v2.Desv)) OR v.Cantidad < 0;

-- Introducimos los outliers de precio en la tabla aux_venta

INSERT into aux_venta
select v.IdVenta, v.Fecha, v.Fecha_Entrega, v.IdCliente, v.IdSucursal,
v.IdEmpleado, v.IdProducto, v.Precio, v.Cantidad, 3
from venta v
JOIN (SELECT IdProducto, avg(Precio) as promedio, stddev(Precio) as Desv
	from venta
	GROUP BY IdProducto) v2
ON (v.IdProducto = v2.IdProducto)
WHERE v.Precio > (v2.Promedio + (3*v2.Desv)) OR v.Precio < (v2.Promedio - (3*v2.Desv)) OR v.Precio < 0;

-- Agrego 0 a los outliers en la tabla venta
ALTER TABLE venta ADD Outlier TINYINT  NOT NULL DEFAULT '1' AFTER Cantidad;

UPDATE venta v
JOIN aux_venta a
ON (v.IdVenta = a.IdVenta AND a.Motivo IN (2,3))
SET v.Outlier = 0;

-- Ventas con y sin outliers

SELECT 	co.TipoProducto,
		co.PromedioVentaConOutliers,
        so.PromedioVentaSinOutliers
FROM
	(SELECT tp.TipoProducto, AVG(v.Precio * v.Cantidad) as PromedioVentaConOutliers
	FROM venta v
    JOIN producto p ON (v.IdProducto = p.IdProducto)
	JOIN tipo_producto tp ON (p.IdTipoProducto = tp.IdTipoProducto)
	GROUP BY tp.TipoProducto) co
JOIN
	(SELECT tp.TipoProducto, AVG(v.Precio * v.Cantidad) as PromedioVentaSinOutliers
	FROM venta v
    JOIN producto p ON (v.IdProducto = p.IdProducto and v.Outlier = 1)
	JOIN tipo_producto tp ON (p.IdTipoProducto = tp.IdTipoProducto)
	GROUP BY tp.TipoProducto) so
ON co.TipoProducto = so.TipoProducto;

-- KPI: Margen de Ganancia por producto superior a 20%   ----> (Esto tampoco lo pude hacer solo) <-----

SELECT 	venta.Producto, 
		venta.SumaVentas, 
        venta.CantidadVentas, 
        venta.SumaVentasOutliers,
        compra.SumaCompras, 
        compra.CantidadCompras,
        ((venta.SumaVentas / compra.SumaCompras - 1) * 100) as margen
FROM
	(SELECT p.Producto, SUM(v.Precio * v.Cantidad * v.Outlier) as SumaVentas,
			SUM(v.Outlier) as CantidadVentas,
			SUM(v.Precio * v.Cantidad) as SumaVentasOutliers,
			COUNT(*) as CantidadVentasOutliers
	FROM venta v
    JOIN productos p ON (v.IdProducto = p.IdProducto AND YEAR(v.Fecha) = 2019)
	GROUP BY p.Producto) AS venta
JOIN
	(SELECT p.Producto, SUM(c.Precio * c.Cantidad) as SumaCompras, COUNT(*) as CantidadCompras
	FROM compra c
    JOIN productos p ON (c.IdProducto = p.IdProducto AND YEAR(c.Fecha) = 2019)
	GROUP BY p.Producto) as compra
ON (venta.Producto = compra.Producto);
*/
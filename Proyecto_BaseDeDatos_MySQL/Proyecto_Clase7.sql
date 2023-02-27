USE PROYECTO_MYQSL;

-- En esta clase solo resolví ejercicios de Querys

-- 1 Obtener un listado del nombre y apellido de cada cliente que haya adquirido algun producto junto al id del producto y su respectivo precio.
SELECT c.NombreApellido AS 'Nombre del cliente', v.IdProducto, v.Precio
FROM Clientes c
INNER JOIN Venta v ON (c.IdCliente = v.IdCliente);

-- 2 Obteber un listado de clientes con la cantidad de productos adquiridos, incluyendo aquellos que nunca compraron algún producto.
SELECT c.NombreApellido AS 'Nombre del cliente', SUM(v.Cantidad) AS 'Cantidad de productos comprados'
FROM Clientes c
LEFT JOIN Venta v ON (c.IdCliente = v.IdCliente)
GROUP BY c.IdCliente
ORDER BY SUM(v.Cantidad) DESC;

-- 3  Obtener un listado de cual fue el volumen de compra (cantidad) por año de cada cliente.
SELECT c.NombreApellido AS 'Nombre del cliente', SUM(v.Cantidad) AS 'Cantidad de productos comprados', year(V.Fecha) as AÑO
FROM Clientes c
LEFT JOIN Venta v ON (c.IdCliente = v.IdCliente)
GROUP BY c.IdCliente, year(V.Fecha)
ORDER BY c.NombreApellido ASC, AÑO ASC;

-- 4 Obtener un listado del nombre y apellido de cada cliente que haya adquirido algun producto 
-- junto al id del producto, la cantidad de productos adquiridos y el precio promedio.
SELECT c.IdCliente, c.NombreApellido AS 'Nombre del cliente', v.IdProducto, sum(v.Cantidad) as Cantidad, AVG(v.Precio * v.Cantidad) as Promedio
FROM Clientes c
INNER JOIN Venta v ON (c.IdCliente = v.IdCliente)
GROUP BY v.IdProducto, c.IdCliente;

-- 5 Cacular la cantidad de productos vendidos y la suma total de ventas para cada localidad, 
-- presentar el análisis en un listado con el nombre de cada localidad.
SELECT l.IdLocalidad, l.Localidad, l.Provincia, count(v.Cantidad) as 'productos vendidos', sum(v.Precio * v.Cantidad) as MontoRecaudado
FROM Venta v
INNER JOIN Sucursales s ON (v.IdSucursal = s.IdSucursal)
INNER JOIN Localidades l ON (s.IdLocalidad = l.IdLocalidad)
GROUP BY l.IdLocalidad, l.Provincia;

-- 6 Cacular la cantidad de productos vendidos y la suma total de ventas para cada provincia, 
-- presentar el análisis en un listado con el nombre de cada provincia, pero solo en aquellas 
-- donde la suma total de las ventas fue superior a $100.000.
SELECT l.Provincia, count(v.Cantidad) as 'productos vendidos', sum(v.Precio * v.Cantidad) as MontoRecaudado
FROM Venta v
INNER JOIN Sucursales s ON (v.IdSucursal = s.IdSucursal)
INNER JOIN Localidades l ON (s.IdLocalidad = l.IdLocalidad)
GROUP BY l.Provincia
HAVING sum(v.Precio*v.Cantidad) > 100000;

-- 7 Obtener un listado de cantidad de productos vendidos por rango etario y las ventas totales en base a esta misma dimensión.
SELECT c.RangoEdad, count(v.IdProducto) as ProductosVendidos, sum(v.Cantidad) as VentasTotales
FROM Venta v
INNER JOIN Clientes c ON (v.IdCliente = c.IdCliente)
GROUP BY c.RangoEdad;

-- 8 Obtener la cantidad de clientes por provincia.
SELECT COUNT(IdCliente) as CantidadClientes, p.Provincia
FROM Clientes c
INNER JOIN Localidades l ON (c.IdLocalidad = l.IdLocalidad)
INNER JOIN Provincias p ON (l.IdProvincia = p.IdProvincia)
GROUP BY p.IdProvincia
ORDER BY CantidadClientes DESC;

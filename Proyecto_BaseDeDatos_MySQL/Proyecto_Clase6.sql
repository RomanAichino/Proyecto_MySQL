USE PROYECTO_MYQSL;

-- Cree un procedimiento que recibe como parametro una fecha y muestre el listado de productos que se vendieron en esa fecha
DROP PROCEDURE IF EXISTS ListadoEj1;
DELIMITER $$
CREATE PROCEDURE ListadoEj1 (Fechasi DATE)
BEGIN
	SELECT DISTINCT p.Producto AS Productos
    FROM fact_venta fc
    JOIN Productos p ON (fc.IdProducto = p.IdProducto)
    WHERE fc.Fecha = Fechasi;
END $$
DELIMITER ;

-- call ListadoEj1 ('2020-05-05'); <----- para corroborar su funcionamiento

SET GLOBAL log_bin_trust_function_creators = 1; --     <------- no entendi para que es, pero sino no funciona

-- Creé una función que calcule el valor nominal de un margen bruto determinado por el usuario a partir del precio de lista de los productos
DROP FUNCTION IF EXISTS margenBruto;
DELIMITER $$
CREATE FUNCTION margenBruto(precio DECIMAL(15,3), margen DECIMAL (9,2)) RETURNS DECIMAL (15,3)
BEGIN
	DECLARE margenBruto DECIMAL (15,3);
    
    SET margenBruto = precio * margen;
    
    RETURN margenBruto;
END $$
DELIMITER ;

-- SELECT margenBruto(1450.5, 1.2);   <----- para corroborar su funcionamiento

/* ejercicio del bootcamp
Creé una función que calcule el valor nominal de un margen bruto determinado por el usuario a partir del precio de lista de los productos

SELECT p.Precio as Precio, p.Producto as Producto, p.Precio + (p.precio/100*20) as 'Precio + 20%'
FROM Tipo_Producto tp
JOIN Productos p ON (tp.IdTipoProducto = p.IdTipoProducto)
WHERE tp.TipoProducto = 'IMPRESION';
*/

-- Creé un procedimiento que permita listar los productos vendidos desde fact_venta a partir de un "Tipo" que determine el usuario

DROP PROCEDURE IF EXISTS ListadoEj4;
DELIMITER $$
CREATE PROCEDURE ListadoEj4 (TipoElegido VARCHAR(25))
BEGIN
	SELECT p.Producto AS 'Productos del tipo'
    FROM fact_venta fc 
    JOIN Productos p ON (fc.IdProducto = p.IdProducto)
    JOIN tipo_producto tp on (p.IdTipoProducto = tp.IdTipoProducto And tp.TipoProducto  collate utf8mb4_spanish_ci = TipoElegido); 
    
END $$
DELIMITER ;

-- call ListadoEj4('AUDIO');   <----- para corroborar su funcionamiento

/* Esta función fue extraida de google y sirve para modificar un texto, lo que hace es modificar la 
primera letra de cada palabra y pasarla a mayuscula, mientras que el resto del texto queda en minuscula */

SET GLOBAL log_bin_trust_function_creators = 1;
DROP FUNCTION IF EXISTS `UC_Words`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `UC_Words`( str VARCHAR(255) ) RETURNS varchar(255) CHARSET utf8
BEGIN  
  DECLARE c CHAR(1);  
  DECLARE s VARCHAR(255);  
  DECLARE i INT DEFAULT 1;  
  DECLARE bool INT DEFAULT 1;  
  DECLARE punct CHAR(17) DEFAULT ' ()[]{},.-_!@;:?/';  
  SET s = LCASE( str );  
  WHILE i < LENGTH( str ) DO  
     BEGIN  
       SET c = SUBSTRING( s, i, 1 );  
       IF LOCATE( c, punct ) > 0 THEN  
        SET bool = 1;  
      ELSEIF bool=1 THEN  
        BEGIN  
          IF c >= 'a' AND c <= 'z' THEN  
             BEGIN  
               SET s = CONCAT(LEFT(s,i-1),UCASE(c),SUBSTRING(s,i+1));  
               SET bool = 0;  
             END;  
           ELSEIF c >= '0' AND c <= '9' THEN  
            SET bool = 0;  
          END IF;  
        END;  
      END IF;  
      SET i = i+1;  
    END;  
  END WHILE;  
  RETURN s;  
END$$
DELIMITER ;

-- Aquí aplicamos la anterior función a algunas columnas de mis tablas
UPDATE clientes SET  Domicilio = UC_Words(TRIM(Domicilio)),
                    NombreApellido = UC_Words(TRIM(NombreApellido));
					
UPDATE sucursales SET Direccion = UC_Words(TRIM(Direccion)),
                    Sucursal = UC_Words(TRIM(Sucursal));
					
UPDATE proveedores SET Nombre = UC_Words(TRIM(Nombre)),
                    Domicilio = UC_Words(TRIM(Domicilio));

UPDATE productos SET Producto = UC_Words(TRIM(Producto));

UPDATE tipo_producto SET TipoProducto = UC_Words(TRIM(TipoProducto));
					
UPDATE empleados SET Nombre = UC_Words(TRIM(Nombre)),
                    Apellido = UC_Words(TRIM(Apellido));

UPDATE sector SET Sector = UC_Words(TRIM(Sector));

UPDATE cargo SET Cargo = UC_Words(TRIM(Cargo));
                    
UPDATE localidades SET Localidad = UC_Words(TRIM(Localidad));
UPDATE localidades SET Provincia = UC_Words(TRIM(Provincia));

UPDATE provincias SET Provincia = UC_Words(TRIM(Provincia));

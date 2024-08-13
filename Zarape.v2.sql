DROP DATABASE IF EXISTS RestauranteElZarape;
CREATE DATABASE RestauranteElZarape;
USE RestauranteElZarape;

CREATE TABLE Usuarios (
    usuario_id INT AUTO_INCREMENT,
    nombre_usuario VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    contraseña VARBINARY(100) NOT NULL,
    CONSTRAINT pk_usuario PRIMARY KEY (usuario_id)
);

CREATE TABLE Usuario_empleado (
    usuarioempleado_id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    contraseña VARBINARY(100) NOT NULL,
    tipo_usuario ENUM('Administrador', 'Personal de Cocina', 'Cliente') NOT NULL,
    CONSTRAINT pk_usuarioempleado PRIMARY KEY (usuarioempleado_id)
);

CREATE TABLE Clientes (
    cliente_id INT auto_increment,
    nombre varchar(100),
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    usuario int,
    CONSTRAINT pk_cliente PRIMARY KEY (cliente_id),
	CONSTRAINT fk_usuario FOREIGN KEY (usuario) REFERENCES Usuarios(usuario_id)
);

CREATE TABLE Empleado (
    empleado_id INT auto_increment,
    telefono VARCHAR(20),
    usuarioempleado int,
    CONSTRAINT pk_empleado PRIMARY KEY (empleado_id),
    CONSTRAINT fk_usuarioempleado FOREIGN KEY (usuarioempleado) REFERENCES Usuario_empleado(usuarioempleado_id)
);

CREATE TABLE Sucursales (
    sucursal_id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    CONSTRAINT pk_sucursal PRIMARY KEY (sucursal_id)
);

CREATE TABLE Producto(
    producto_id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_producto PRIMARY KEY (producto_id)
);

CREATE TABLE Menus (
    menu_id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    sucursal_id INT,
    CONSTRAINT pk_menu PRIMARY KEY (menu_id),
    CONSTRAINT fk_menu_sucursal FOREIGN KEY (sucursal_id) REFERENCES Sucursales(sucursal_id)
);

CREATE TABLE Platillos (
    platillo_id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    menu_id INT,
    producto_id int,
    CONSTRAINT pk_platillo PRIMARY KEY (platillo_id),
    CONSTRAINT fk_platillo_menu FOREIGN KEY (menu_id) REFERENCES Menus(menu_id),
    CONSTRAINT fk_platillo_producto FOREIGN KEY (producto_id) REFERENCES Producto(producto_id)
);

CREATE TABLE Bebida(
    bebida_id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    menu_id INT,
    producto_id int,
    CONSTRAINT pk_bebida PRIMARY KEY (bebida_id),
    CONSTRAINT fk_bebida_menu FOREIGN KEY (menu_id) REFERENCES Menus(menu_id),
    CONSTRAINT fk_bebida_producto FOREIGN KEY (producto_id) REFERENCES Producto(producto_id)
);

CREATE TABLE Combos (
    combo_id INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    menu_id INT,
    producto_id int,
    CONSTRAINT pk_combo PRIMARY KEY (combo_id),
    CONSTRAINT fk_combo_menu FOREIGN KEY (menu_id) REFERENCES Menus(menu_id),    
    CONSTRAINT fk_combo_producto FOREIGN KEY (producto_id) REFERENCES Producto(producto_id)
);

CREATE TABLE Pedidos (
    pedido_id INT AUTO_INCREMENT,
    cliente_id INT,
    sucursal_id INT,
    fecha_pedido DATETIME NOT NULL,
    estado ENUM('Pendiente', 'En Proceso', 'Completado', 'Cancelado') NOT NULL,
    CONSTRAINT pk_pedido PRIMARY KEY (pedido_id),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id),
    CONSTRAINT fk_pedido_sucursal FOREIGN KEY (sucursal_id) REFERENCES Sucursales(sucursal_id)
);

CREATE TABLE Reservas (
    reserva_id INT AUTO_INCREMENT,
    cliente_id INT,
    mesa_id INT,
    fecha_reserva DATETIME NOT NULL,
    CONSTRAINT pk_reserva PRIMARY KEY (reserva_id),
    CONSTRAINT fk_reserva_cliente FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

CREATE TABLE Pagos (
    pago_id INT AUTO_INCREMENT,
    pedido_id INT,
    monto DECIMAL(10, 2) NOT NULL,
    fecha_pago DATETIME NOT NULL,
    metodo_pago ENUM('Efectivo', 'Tarjeta', 'Transferencia') NOT NULL,
    CONSTRAINT pk_pago PRIMARY KEY (pago_id),
    CONSTRAINT fk_pago_pedido FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id)
);

CREATE TABLE Tarjeta(
    numerotarjeta_id varchar(40),
    CVV int(4),
    Nombre_Apellido varchar(80),
    Fecha_vencimiento varchar(30),
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    cliente_id INT,
    fecha_factura DATETIME NOT NULL,
    CONSTRAINT pk_numerotarjeta PRIMARY KEY (numerotarjeta_id),
    CONSTRAINT fk_numerotarjeta_cliente FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

CREATE TABLE Facturas (
    factura_id INT AUTO_INCREMENT,
    pago_id INT,
    cliente_id INT,
    fecha_factura DATETIME NOT NULL,
    CONSTRAINT pk_factura PRIMARY KEY (factura_id),
    CONSTRAINT fk_factura_pago FOREIGN KEY (pago_id) REFERENCES Pagos(pago_id),
    CONSTRAINT fk_factura_cliente FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

ALTER TABLE Sucursales
ADD COLUMN gps_latitud DECIMAL(10, 7),
ADD COLUMN gps_longitud DECIMAL(10, 7),
ADD COLUMN estatus ENUM('Activo', 'Inactivo') DEFAULT 'Activo';

ALTER TABLE Empleado
ADD COLUMN estatus ENUM('Activo', 'Inactivo') DEFAULT 'Activo';

ALTER TABLE Producto
ADD COLUMN estatus ENUM('Activo', 'Inactivo') DEFAULT 'Activo';

-- Inserción de datos

-- Inserción de usuarios
INSERT INTO Usuarios (nombre_usuario, correo, contraseña)
VALUES 
('JP092', 'juan.perez@example.com', AES_ENCRYPT('password123', 'mykey')),
('ML9012', 'maria.lopez@example.com', AES_ENCRYPT('mipassword', 'mykey'));

-- Inserción de empleados y usuarios empleados
INSERT INTO Usuario_empleado (nombre, contraseña, tipo_usuario)
VALUES 
('Carlos Sánchez', AES_ENCRYPT('admin123', 'mykey'), 'Administrador'),
('Ana Martínez', AES_ENCRYPT('chefana', 'mykey'), 'Personal de Cocina');

INSERT INTO Empleado (telefono, usuarioempleado)
VALUES 
('555-1234', 1), -- Usuarioempleado_id 1 corresponde a Carlos Sánchez
('555-5678', 2); -- Usuarioempleado_id 2 corresponde a Ana Martínez

-- Inserción de clientes
INSERT INTO Clientes (cliente_id, nombre, telefono, direccion, usuario)
VALUES 
(1, 'Juan Pérez', '555-7890', 'Calle Falsa 123', 1),
(2, 'María López', '555-2345', 'Avenida Siempre Viva 742', 2);

-- Inserción de sucursales
INSERT INTO Sucursales (nombre, direccion, telefono, gps_latitud, gps_longitud, estatus)
VALUES 
('Sucursal Centro', 'Calle Principal 100', '555-1010', 19.432608, -99.133209, 'Activo'),
('Sucursal Norte', 'Avenida Norte 200', '555-2020', 19.501734, -99.148348, 'Activo');

-- Inserción de productos
INSERT INTO Producto (nombre, descripcion, precio, estatus)
VALUES 
('Tacos al Pastor', 'Deliciosos tacos con carne al pastor y piña', 50.00, 'Activo'),
('Coca-Cola', 'Refresco de cola 500ml', 20.00, 'Activo'),
('Combo Tacos y Bebida', 'Tacos al pastor + Coca-Cola', 65.00, 'Activo');

-- Inserción de menús
INSERT INTO Menus (nombre, sucursal_id)
VALUES 
('Menú Centro', 1),
('Menú Norte', 2);

-- Inserción de platillos
INSERT INTO Platillos (nombre, descripcion, precio, menu_id, producto_id)
VALUES 
('Tacos al Pastor', 'Deliciosos tacos con carne al pastor y piña', 50.00, 1, 1);

-- Inserción de bebidas
INSERT INTO Bebida (nombre, descripcion, precio, menu_id, producto_id)
VALUES 
('Coca-Cola', 'Refresco de cola 500ml', 20.00, 1, 2);

-- Inserción de combos
INSERT INTO Combos (nombre, descripcion, precio, menu_id, producto_id)
VALUES 
('Combo Tacos y Bebida', 'Tacos al pastor + Coca-Cola', 65.00, 1, 3);

-- Inserción de pedidos
INSERT INTO Pedidos (cliente_id, sucursal_id, fecha_pedido, estado)
VALUES 
(1, 1, '2024-08-09 12:00:00', 'Pendiente');

-- Inserción de pagos
INSERT INTO Pagos (pedido_id, monto, fecha_pago, metodo_pago)
VALUES 
(1, 65.00, '2024-08-09 12:30:00', 'Tarjeta');

-- Inserción de tarjetas de clientes
INSERT INTO Tarjeta (numerotarjeta_id, CVV, Nombre_Apellido, Fecha_vencimiento, telefono, direccion, cliente_id, fecha_factura)
VALUES
('1111-2222-3333-4444', 123, 'Juan Pérez', '08/2024', '555-7890', 'Calle Falsa 123', 1, NOW());

-- Inserción de facturas
INSERT INTO Facturas (pago_id, cliente_id, fecha_factura)
VALUES 
(1, 1, '2024-08-09 12:45:00');

-- Inserción de una nueva reserva
INSERT INTO Reservas (cliente_id, mesa_id, fecha_reserva)
VALUES (1, 5, '2024-08-10 19:00:00');


-- Procedimientos Almacenados

 DELIMITER | 

CREATE PROCEDURE CrearSucursal(IN nombre VARCHAR(100), IN direccion VARCHAR(255), IN telefono VARCHAR(20), IN gps_latitud DECIMAL(10, 7), IN gps_longitud DECIMAL(10, 7))
BEGIN
    INSERT INTO Sucursales (nombre, direccion, telefono, gps_latitud, gps_longitud) VALUES (nombre, direccion, telefono, gps_latitud, gps_longitud);
END ;

CREATE PROCEDURE BuscarSucursal(IN sucursalID INT)
BEGIN
    SELECT * FROM Sucursales WHERE sucursal_id = sucursalID;
END ;

CREATE PROCEDURE ActualizarSucursal(IN sucursalID INT, IN nuevoNombre VARCHAR(100), IN nuevaDireccion VARCHAR(255), IN nuevoTelefono VARCHAR(20), IN nuevaLatitud DECIMAL(10, 7), IN nuevaLongitud DECIMAL(10, 7))
BEGIN
    UPDATE Sucursales SET nombre = nuevoNombre, direccion = nuevaDireccion, telefono = nuevoTelefono, gps_latitud = nuevaLatitud, gps_longitud = nuevaLongitud WHERE sucursal_id = sucursalID;
END ;

CREATE PROCEDURE EliminarSucursal(IN sucursalID INT)
BEGIN
    UPDATE Sucursales SET estatus = 'Inactivo' WHERE sucursal_id = sucursalID;
END ;

CREATE PROCEDURE CrearEmpleado(IN nombre VARCHAR(100), IN contraseña VARBINARY(100), IN tipoUsuario ENUM('Administrador', 'Personal de Cocina', 'Cliente'), IN telefono VARCHAR(20))
BEGIN
    INSERT INTO Usuario_empleado (nombre, contraseña, tipo_usuario) VALUES (nombre, contraseña, tipoUsuario);
    SET @ultimoID = LAST_INSERT_ID();
    INSERT INTO Empleado (telefono, usuarioempleado) VALUES (telefono, @ultimoID);
END ;

CREATE PROCEDURE BuscarEmpleado(IN empleadoID INT)
BEGIN
    SELECT * FROM Empleado WHERE empleado_id = empleadoID;
END ;

CREATE PROCEDURE ActualizarEmpleado(IN empleadoID INT, IN nuevoNombre VARCHAR(100), IN nuevaContraseña VARBINARY(100), IN nuevoTipoUsuario ENUM('Administrador', 'Personal de Cocina', 'Cliente'), IN nuevoTelefono VARCHAR(20))
BEGIN
    UPDATE Usuario_empleado ue JOIN Empleado e ON ue.usuarioempleado_id = e.usuarioempleado
    SET ue.nombre = nuevoNombre, ue.contraseña = nuevaContraseña, ue.tipo_usuario = nuevoTipoUsuario, e.telefono = nuevoTelefono
    WHERE e.empleado_id = empleadoID;
END ;

CREATE PROCEDURE EliminarEmpleado(IN empleadoID INT)
BEGIN
    UPDATE Empleado SET estatus = 'Inactivo' WHERE empleado_id = empleadoID;
END ;

CREATE PROCEDURE CrearProducto(IN nombre VARCHAR(100), IN descripcion TEXT, IN precio DECIMAL(10, 2))
BEGIN
    INSERT INTO Producto (nombre, descripcion, precio) VALUES (nombre, descripcion, precio);
END ;

CREATE PROCEDURE BuscarProducto(IN productoID INT)
BEGIN
    SELECT * FROM Producto WHERE producto_id = productoID;
END ;

CREATE PROCEDURE ActualizarProducto(IN productoID INT, IN nuevoNombre VARCHAR(100), IN nuevaDescripcion TEXT, IN nuevoPrecio DECIMAL(10, 2))
BEGIN
    UPDATE Producto SET nombre = nuevoNombre, descripcion = nuevaDescripcion, precio = nuevoPrecio WHERE producto_id = productoID;
END ;

CREATE PROCEDURE EliminarProducto(IN productoID INT)
BEGIN
    UPDATE Producto SET estatus = 'Inactivo' WHERE producto_id = productoID;
END ;

| DELIMITER ;

-- Vistas Avanzadas

CREATE VIEW VistaEmpleados AS
SELECT e.empleado_id, ue.nombre, ue.tipo_usuario, e.telefono, e.estatus
FROM Empleado e
JOIN Usuario_empleado ue ON e.usuarioempleado = ue.usuarioempleado_id;

CREATE VIEW VistaProductosDisponibles AS
SELECT producto_id, nombre, descripcion, precio
FROM Producto
WHERE estatus = 'Activo';

CREATE VIEW VistaPedidosDetalles AS
SELECT p.pedido_id, c.nombre AS cliente, s.nombre AS sucursal, p.fecha_pedido, p.estado
FROM Pedidos p
JOIN Clientes c ON p.cliente_id = c.cliente_id
JOIN Sucursales s ON p.sucursal_id = s.sucursal_id;

CREATE VIEW VistaFacturasPorCliente AS
SELECT f.factura_id, c.nombre AS cliente, f.fecha_factura
FROM Facturas f
JOIN Clientes c ON f.cliente_id = c.cliente_id;

CREATE VIEW VistaMenusConPlatillosYbebidas AS
SELECT m.menu_id, m.nombre AS menu, p.nombre AS platillo, b.nombre AS bebida
FROM Menus m
LEFT JOIN Platillos p ON m.menu_id = p.menu_id
LEFT JOIN Bebida b ON m.menu_id = b.menu_id;

CREATE VIEW VistaReservasPorCliente AS
SELECT r.reserva_id, c.nombre AS cliente, r.fecha_reserva
FROM Reservas r
JOIN Clientes c ON r.cliente_id = c.cliente_id;

CREATE VIEW VistaProductosEnCombos AS
SELECT co.combo_id, co.nombre AS combo, p.nombre AS producto
FROM Combos co
JOIN Producto p ON co.producto_id = p.producto_id;

CREATE VIEW VistaSucursalesAvanzada AS
SELECT 
    sucursal_id, nombre, direccion, telefono, gps_latitud, gps_longitud, estatus
FROM Sucursales
WHERE estatus = 'Activo';


-- Disparadores

 DELIMITER | 

-- Disparador para evitar la actualización de otros campos si el registro está inactivo
CREATE TRIGGER tr_actualizar_sucursal_inactiva 
BEFORE UPDATE ON Sucursales 
FOR EACH ROW 
BEGIN 
    IF OLD.estatus = 'Inactivo' AND NEW.estatus = 'Inactivo' THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede actualizar una sucursal inactiva.';
    END IF; 
END ;

CREATE TRIGGER tr_actualizar_empleado_inactivo 
BEFORE UPDATE ON Empleado 
FOR EACH ROW 
BEGIN 
    IF OLD.estatus = 'Inactivo' AND NEW.estatus = 'Inactivo' THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede actualizar un empleado inactivo.';
    END IF; 
END ;

CREATE TRIGGER tr_actualizar_producto_inactivo 
BEFORE UPDATE ON Producto 
FOR EACH ROW 
BEGIN 
    IF OLD.estatus = 'Inactivo' AND NEW.estatus = 'Inactivo' THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede actualizar un producto inactivo.';
    END IF; 
END ;

| DELIMITER ;


-- Llamadas a procedimientos almacenados

-- Crear Sucursal
CALL CrearSucursal('Sucursal Este', 'Avenida Este 300', '555-3030', 19.432608, -99.133209);

-- Buscar Sucursal por ID
CALL BuscarSucursal(1);

-- Actualizar Sucursal
CALL ActualizarSucursal(1, 'Sucursal Centro Actualizada', 'Calle Principal 100', '555-1111', 19.432608, -99.133209);

-- Eliminar Sucursal (cambiar estatus a 'Inactivo')
CALL EliminarSucursal(2);

-- Crear Empleado
CALL CrearEmpleado('Roberto Gómez', AES_ENCRYPT('passwordempleado', 'mykey'), 'Personal de Cocina', '555-9090');

-- Buscar Empleado por ID
CALL BuscarEmpleado(1);

-- Actualizar Empleado
CALL ActualizarEmpleado(1, 'Carlos Sánchez Actualizado', AES_ENCRYPT('newadmin123', 'mykey'), 'Administrador', '555-0000');

-- Eliminar Empleado (cambiar estatus a 'Inactivo')
CALL EliminarEmpleado(2);

-- Crear Producto
CALL CrearProducto('Enchiladas Verdes', 'Enchiladas de pollo bañadas en salsa verde', 75.00);

-- Buscar Producto por ID
CALL BuscarProducto(1);

-- Actualizar Producto
CALL ActualizarProducto(1, 'Enchiladas Verdes Actualizadas', 'Enchiladas de pollo con más salsa verde', 80.00);

-- Eliminar Producto (cambiar estatus a 'Inactivo')
CALL EliminarProducto(2);

-- Procedimiento para activar una sucursal
DELIMITER $$

CREATE PROCEDURE ActivarSucursal(IN sucursalID INT)
BEGIN
    UPDATE Sucursales 
    SET estatus = 'Activo' 
    WHERE sucursal_id = sucursalID;
END $$

-- Procedimiento para activar un empleado
CREATE PROCEDURE ActivarEmpleado(IN empleadoID INT)
BEGIN
    UPDATE Empleado 
    SET estatus = 'Activo' 
    WHERE empleado_id = empleadoID;
END $$

-- Procedimiento para activar un producto
CREATE PROCEDURE ActivarProducto(IN productoID INT)
BEGIN
    UPDATE Producto 
    SET estatus = 'Activo' 
    WHERE producto_id = productoID;
END $$

DELIMITER ;

-- Ejemplo de uso
-- Activar la sucursal con ID 2
CALL ActivarSucursal(2);

-- Activar el empleado con ID 2
CALL ActivarEmpleado(2);

-- Activar el producto con ID 2
CALL ActivarProducto(2);

-- Ejecución de vistas avanzadas

-- Obtener la información completa de todos los empleados
SELECT * FROM VistaEmpleados;

-- Obtener todos los productos disponibles
SELECT * FROM VistaProductosDisponibles;

-- Obtener detalles de todos los pedidos
SELECT * FROM VistaPedidosDetalles;

-- Obtener todas las facturas junto con el nombre del cliente
SELECT * FROM VistaFacturasPorCliente;

-- Obtener todos los menús con sus platillos y bebidas
SELECT * FROM VistaMenusConPlatillosYbebidas;

-- Obtener todas las reservas junto con el nombre del cliente
SELECT * FROM VistaReservasPorCliente;

-- Obtener todos los combos con los productos incluidos
SELECT * FROM VistaProductosEnCombos;
   
SELECT * FROM VistaSucursalesAvanzada;

INSERT INTO Usuario_empleado (nombre, contraseña, tipo_usuario)
VALUES 
    ('Erick', AES_ENCRYPT('JGTP0021', 'mykey'), 'Administrador'),
    ('Gulberto', AES_ENCRYPT('KKcz671', 'mykey'), 'Personal de Cocina'),
    ('Daniel', AES_ENCRYPT('15689', 'mykey'), 'Personal de Cocina');
    
INSERT INTO Platillos (nombre, descripcion, precio, menu_id, producto_id)
VALUES 
    ('Sopes', 'Consiste en una base de masa frita y se acompaña de frijoles, bistec, pastor y chorizo.', 30.00, NULL, NULL),
    ('Pozole Verde', 'Consiste en una base de masa frita y se acompaña de frijoles, bistec, pastor y chorizo.', 30.00, NULL, NULL),
    ('Tacos de Guisado', 'Consiste en una base de masa frita y se acompaña de frijoles, bistec, pastor y chorizo.', 30.00, NULL, NULL),
    ('Tacos Al Pastor', 'Consiste en una base de masa frita y se acompaña de frijoles, bistec, pastor y chorizo.', 30.00, NULL, NULL),
    ('Enchiladas', 'Consiste en una base de masa frita y se acompaña de frijoles, bistec, pastor y chorizo.', 30.00, NULL, NULL),
    ('Quesadillas', 'Consiste en una base de masa frita y se acompaña de frijoles, bistec, pastor y chorizo.', 30.00, NULL, NULL);

INSERT INTO Bebida (nombre, descripcion, precio, menu_id, producto_id)
VALUES 
    ('Coca-Cola', 'Refresco de cola clásico, servido frío.', 20.00, NULL, NULL),
    ('Sprite', 'Refresco de limón, sin cafeína.', 20.00, NULL, NULL),
    ('Fanta', 'Refresco de naranja, sabor único.', 20.00, NULL, NULL),
    ('Horchata', 'Refrescante bebida de arroz con canela.', 25.00, NULL, NULL),
    ('Jamaica', 'Agua de flor de jamaica, refrescante y natural.', 25.00, NULL, NULL),
    ('Capuccino', 'Café con leche y espuma, ideal para las mañanas.', 35.00, NULL, NULL),
    ('Americano', 'Café americano, servido caliente.', 30.00, NULL, NULL);




-- =============================================
-- POBLACION DE LAS TABLAS - CORREGIDO
-- =============================================

USE pizzeria_don_piccolo;

-- 1. PERSONAS
INSERT INTO Persona (id, Nombre, Apellido, correo) VALUES
(1, 'Juan', 'Pérez', 'juan.perez@email.com'),
(2, 'María', 'Gómez', 'maria.gomez@email.com'),
(3, 'Carlos', 'Rodríguez', 'carlos.rodriguez@email.com'),
(4, 'Ana', 'Martínez', 'ana.martinez@email.com'),
(5, 'Luis', 'Sánchez', 'luis.sanchez@email.com'),
(6, 'Laura', 'Díaz', 'laura.diaz@email.com'),
(7, 'Pedro', 'Fernández', 'pedro.fernandez@email.com'),
(8, 'Sofía', 'López', 'sofia.lopez@email.com'),
(9, 'Miguel', 'Torres', 'miguel.torres@email.com'),
(10, 'Elena', 'Ramírez', 'elena.ramirez@email.com');

-- 2. TELÉFONOS
INSERT INTO telefono (id, numero, indicativo, persona_fk) VALUES
(1, 300123456, 57, 1),
(2, 310234567, 57, 2),
(3, 320345678, 57, 3),
(4, 300456789, 57, 4),
(5, 311567890, 57, 5),
(6, 322678901, 57, 6),
(7, 300789012, 57, 7),
(8, 310890123, 57, 8),
(9, 320901234, 57, 9),
(10, 311012345, 57, 10);

-- 3. CLIENTES (IDs 1-6)
INSERT INTO cliente (id, direccion, fecha_registro) VALUES
(1, 'Calle 123 #45-67, Bogotá', '2026-01-15'),
(2, 'Carrera 78 #90-12, Medellín', '2026-01-20'),
(3, 'Avenida 45 #23-45, Cali', '2026-02-01'),
(4, 'Calle 89 #12-34, Bogotá', '2026-02-10'),
(5, 'Transversal 56 #78-90, Medellín', '2026-02-15'),
(6, 'Diagonal 34 #56-78, Cali', '2026-03-01');

-- 4. EMPLEADOS (IDs 7-10)
INSERT INTO Empleado (id, salario_base, fecha_contratacion) VALUES
(7, 1500000, '2025-06-01'),
(8, 1400000, '2025-07-15'),
(9, 1600000, '2025-05-20'),
(10, 1450000, '2025-08-10');

-- 5. ENCARGADOS DE CAJA (IDs 7 y 8)
INSERT INTO encargado_caja (id) VALUES (7), (8);

-- 6. REPARTIDORES (IDs 9 y 10)
INSERT INTO repartidor (id, zona, estado) VALUES
(9, 'Norte', 0),  -- 0 = ocupado
(10, 'Sur', 0);   -- 0 = ocupado

-- 7. INGREDIENTES (CORREGIDO: stock_minimo)
INSERT INTO ingredientes (id, nombre, stock, stock_minimo, precio_unitario) VALUES
(1, 'Masa para pizza', 50, 10, 2000),
(2, 'Salsa de tomate', 30, 5, 1500),
(3, 'Queso mozzarella', 40, 8, 3000),
(4, 'Pepperoni', 25, 5, 4000),
(5, 'Jamón', 20, 5, 3500),
(6, 'Champiñones', 15, 3, 2500),
(7, 'Cebolla', 20, 5, 1000),
(8, 'Pimiento', 18, 4, 1200),
(9, 'Aceitunas', 12, 3, 2000),
(10, 'Orégano', 8, 2, 500);

-- 8. PIZZAS
INSERT INTO pizza (id, nombre, tamano_cm, precio_base, tipo) VALUES
(1, 'Margarita', 30, 18000, 'clasica'),
(2, 'Pepperoni', 35, 22000, 'clasica'),
(3, 'Hawaiana', 30, 20000, 'especial'),
(4, 'Vegetariana', 32, 19000, 'vegetariana'),
(5, 'Cuatro Quesos', 35, 25000, 'especial'),
(6, 'Napolitana', 30, 17000, 'clasica');

-- 9. PIZZA_INGREDIENTES
INSERT INTO pizza_ingredientes (id, cantidad, pizza_fk, ingredientes_fk) VALUES
-- Margarita
(1, 1, 1, 1),
(2, 2, 1, 2),
(3, 3, 1, 3),
-- Pepperoni
(4, 1, 2, 1),
(5, 2, 2, 2),
(6, 3, 2, 3),
(7, 2, 2, 4),
-- Hawaiana
(8, 1, 3, 1),
(9, 2, 3, 2),
(10, 3, 3, 3),
(11, 2, 3, 5),
-- Vegetariana
(12, 1, 4, 1),
(13, 2, 4, 2),
(14, 3, 4, 3),
(15, 1, 4, 6),
(16, 1, 4, 7),
-- Cuatro Quesos
(17, 1, 5, 1),
(18, 2, 5, 2),
(19, 4, 5, 3),
-- Napolitana
(20, 1, 6, 1),
(21, 2, 6, 2),
(22, 2, 6, 3);

-- 10. PEDIDOS (CORREGIDO: eliminados 'app')
INSERT INTO pedido (id, fecha, metodo_pago, estado, total, cliente_fk, encargado_caja_fk) VALUES
(1, '2026-03-01 12:30:00', 'efectivo', 'entregado', 22000, 1, 7),
(2, '2026-03-01 13:15:00', 'tarjeta', 'entregado', 40000, 2, 7),
(3, '2026-03-01 14:00:00', 'efectivo', 'entregado', 38000, 3, 8),
(4, '2026-03-02 11:45:00', 'tarjeta', 'preparando', 25000, 1, 7),
(5, '2026-03-02 12:30:00', 'efectivo', 'pendiente', 52000, 4, 8),
(6, '2026-03-02 19:00:00', 'tarjeta', 'entregado', 20000, 5, 7),
(7, '2026-03-03 13:00:00', 'efectivo', 'cancelado', 22000, 2, 8),
(8, '2026-03-03 20:30:00', 'tarjeta', 'entregado', 45000, 6, 7),
(9, '2026-03-04 12:00:00', 'efectivo', 'entregado', 32000, 1, 7),
(10, '2026-03-04 13:30:00', 'tarjeta', 'entregado', 45000, 2, 8),
(11, '2026-03-05 11:00:00', 'efectivo', 'entregado', 28000, 3, 7),
(12, '2026-03-05 14:00:00', 'efectivo', 'entregado', 52000, 4, 8),
(13, '2026-03-06 12:45:00', 'tarjeta', 'entregado', 38000, 5, 7),
(14, '2026-03-06 21:00:00', 'tarjeta', 'entregado', 65000, 6, 8);

-- 11. PEDIDO_PIZZAS
INSERT INTO pedido_pizzas (id, cantidad, precio_unitario, pedido_fk, pizza_fk) VALUES
(1, 1, 18000, 1, 1),
(2, 2, 22000, 2, 2),
(3, 1, 18000, 2, 1),
(4, 2, 20000, 3, 3),
(5, 1, 25000, 4, 5),
(6, 1, 22000, 5, 2),
(7, 2, 22000, 5, 3),
(8, 1, 20000, 6, 4),
(9, 1, 18000, 7, 1),
(10, 2, 22000, 8, 2);

-- 12. DOMICILIOS
INSERT INTO domicilio (id, hora_salida, hora_llegada, distancia, precio_envio, pedido_fk, repartidor_fk) VALUES
(1, '2026-03-01 18:30:00', '2026-03-01 18:45:00', 3.5, 5000, 1, 9),
(2, '2026-03-02 19:00:00', '2026-03-02 19:25:00', 4.2, 6000, 2, 10),
(3, '2026-03-03 20:00:00', '2026-03-03 20:15:00', 2.8, 4000, 3, 9),
(4, '2026-03-05 18:00:00', null, 5.1, 7000, 5, 10),  
(5, '2026-03-06 19:30:00', '2026-03-06 19:45:00', 3.0, 4500, 6, 9),
(6, '2026-03-08 20:30:00', '2026-03-08 20:55:00', 4.5, 6500, 8, 10);

-- 13. PAGOS
INSERT INTO pago (id, monto, metodo_pago, fecha_pago, estado, pedido_fk) VALUES
(1, 22000, 'efectivo', '2026-03-01', 'pagado', 1),
(2, 40000, 'tarjeta', '2026-03-02', 'pagado', 2),
(3, 38000, 'efectivo', '2026-03-03', 'pagado', 3),
(4, 25000, 'tarjeta', '2026-03-04', 'pagado', 4),
(5, 52000, 'efectivo', '2026-03-05', 'pendiente', 5),
(6, 20000, 'tarjeta', '2026-03-06', 'pagado', 6),
(7, 22000, 'efectivo', '2026-03-07', 'pendiente', 7),
(8, 45000, 'tarjeta', '2026-03-08', 'pagado', 8);

-- 14. HISTORIAL_PRECIOS (CORREGIDO: fecha_modificacion como DATE)
INSERT INTO historial_precios (id, precio_anterior, precio_nuevo, fecha_modificacion, pizza_fk) VALUES
(1, 15000, 18000, '2026-01-15', 1),
(2, 20000, 22000, '2026-01-20', 2),
(3, 18000, 20000, '2026-02-01', 3),
(4, 22000, 25000, '2026-02-15', 5),
(5, 17000, 19000, '2026-03-01', 6),
(6, 25000, 28000, '2026-03-05', 5),
(7, 19000, 21000, '2026-03-10', 4),
(8, 18000, 20000, '2026-03-15', 1);
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema pizzeria-don-piccolo
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pizzeria-don-piccolo` DEFAULT CHARACTER SET utf8 ;
USE `pizzeria-don-piccolo` ;

-- -----------------------------------------------------
-- Table `pizzeria-don-piccolo`.`Persona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria-don-piccolo`.`Persona` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  `Apellido` VARCHAR(45) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria-don-piccolo`.`telefono`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria-don-piccolo`.`telefono` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `numero` INT NOT NULL,
  `indicativo` INT NOT NULL,
  `persona_fk` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `persona_fk1_idx` (`persona_fk` ASC) VISIBLE,
  CONSTRAINT `persona_fk1`
    FOREIGN KEY (`persona_fk`)
    REFERENCES `pizzeria-don-piccolo`.`Persona` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria-don-piccolo`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria-don-piccolo`.`cliente` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `direccion` VARCHAR(45) NOT NULL,
  `fecha_registro` DATE NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `persona_fk2`
    FOREIGN KEY (`id`)
    REFERENCES `pizzeria-don-piccolo`.`Persona` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria-don-piccolo`.`Empleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria-don-piccolo`.`Empleado` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `salario_base` DOUBLE NOT NULL,
  `fecha_contratacion` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `persona_fk3`
    FOREIGN KEY (`id`)
    REFERENCES `pizzeria-don-piccolo`.`Persona` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria-don-piccolo`.`repartidor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria-don-piccolo`.`repartidor` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `zona` VARCHAR(45) NOT NULL DEFAULT 'libre',
  `estado` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  CONSTRAINT `empleado_fk1`
    FOREIGN KEY (`id`)
    REFERENCES `pizzeria-don-piccolo`.`Empleado` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria-don-piccolo`.`encargado_caja`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria-don-piccolo`.`encargado_caja` (
  `id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  CONSTRAINT `empleado_fk2`
    FOREIGN KEY (`id`)
    REFERENCES `pizzeria-don-piccolo`.`Empleado` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria-don-piccolo`.`ingredientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria-don-piccolo`.`ingredientes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `stock` INT NOT NULL,
  `estock_minimo` INT NOT NULL DEFAULT 5,
  `precio_unitario` DOUBLE NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria-don-piccolo`.`pizza`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria-don-piccolo`.`pizza` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `tamaño` DOUBLE NOT NULL,
  `precio_base` DOUBLE NOT NULL,
  `tipo` ENUM("vegetariana", "especial", "clasica") NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria-don-piccolo`.`pizza_ingredientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria-don-piccolo`.`pizza_ingredientes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `pizza_fk` INT NOT NULL,
  `ingredientes_fk` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `pizza_fk_idx` (`pizza_fk` ASC) VISIBLE,
  INDEX `ingredientes_fk_idx` (`ingredientes_fk` ASC) VISIBLE,
  CONSTRAINT `pizza_fk`
    FOREIGN KEY (`pizza_fk`)
    REFERENCES `pizzeria-don-piccolo`.`pizza` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ingredientes_fk`
    FOREIGN KEY (`ingredientes_fk`)
    REFERENCES `pizzeria-don-piccolo`.`ingredientes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria-don-piccolo`.`pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria-don-piccolo`.`pedido` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATETIME NOT NULL,
  `metodo_pago` ENUM("efectivo", "tarjeta") NOT NULL,
  `estado` ENUM("pendiente", "preparando", "entregado", "cancelado") NOT NULL,
  `total` DOUBLE NOT NULL,
  `cliente_fk` INT NOT NULL,
  `encargado_caja_fk` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `cliente_fk_idx` (`cliente_fk` ASC) VISIBLE,
  INDEX `encargado_caja_fk_idx` (`encargado_caja_fk` ASC) VISIBLE,
  CONSTRAINT `cliente_fk`
    FOREIGN KEY (`cliente_fk`)
    REFERENCES `pizzeria-don-piccolo`.`cliente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `encargado_caja_fk`
    FOREIGN KEY (`encargado_caja_fk`)
    REFERENCES `pizzeria-don-piccolo`.`encargado_caja` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria-don-piccolo`.`pedido_pizzas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria-don-piccolo`.`pedido_pizzas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `precio_unitario` DOUBLE NOT NULL,
  `pedido_fk` INT NOT NULL,
  `pizza_fk` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `pizza_fk_idx` (`pizza_fk` ASC) VISIBLE,
  INDEX `pedido_fk_idx` (`pedido_fk` ASC) VISIBLE,
  CONSTRAINT `pizza_fk3`
    FOREIGN KEY (`pizza_fk`)
    REFERENCES `pizzeria-don-piccolo`.`pizza` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `pedido_fk1`
    FOREIGN KEY (`pedido_fk`)
    REFERENCES `pizzeria-don-piccolo`.`pedido` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria-don-piccolo`.`domicilio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria-don-piccolo`.`domicilio` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `hora_salida` DATETIME NOT NULL,
  `hora_llegada` DATETIME NULL,
  `distancia` DOUBLE NOT NULL,
  `precio_envio` DOUBLE NOT NULL,
  `pedido_fk` INT NOT NULL,
  `repartidor_fk` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `pedido_fk_idx` (`pedido_fk` ASC) VISIBLE,
  INDEX `repartidor_fk_idx` (`repartidor_fk` ASC) VISIBLE,
  CONSTRAINT `pedido_fk3`
    FOREIGN KEY (`pedido_fk`)
    REFERENCES `pizzeria-don-piccolo`.`pedido` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `repartidor_fk`
    FOREIGN KEY (`repartidor_fk`)
    REFERENCES `pizzeria-don-piccolo`.`repartidor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria-don-piccolo`.`pago`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria-don-piccolo`.`pago` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `monto` DOUBLE NOT NULL,
  `metodo_pago` ENUM("efectivo", "tarjeta") NOT NULL,
  `fecha_pago` DATE NOT NULL,
  `estado` ENUM("pagado", "pendiente", "realizado") NOT NULL,
  `pedido_fk` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `pedido_fk_idx` (`pedido_fk` ASC) VISIBLE,
  CONSTRAINT `pedido_fk2`
    FOREIGN KEY (`pedido_fk`)
    REFERENCES `pizzeria-don-piccolo`.`pedido` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria-don-piccolo`.`historial_precios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria-don-piccolo`.`historial_precios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `precio_anterior` DOUBLE NOT NULL,
  `precio_nuevo` DOUBLE NOT NULL,
  `fecha_modificacion` DATETIME NOT NULL,
  `pizza_fk` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `pizza_fk_idx` (`pizza_fk` ASC) VISIBLE,
  CONSTRAINT `pizza_fk2`
    FOREIGN KEY (`pizza_fk`)
    REFERENCES `pizzeria-don-piccolo`.`pizza` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



-- POBLACION DE LAS TABLAS



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
(9, 'Norte', 0),
(10, 'Sur', 0);

-- 7. INGREDIENTES
INSERT INTO ingredientes (id, nombre, stock, estock_minimo, precio_unitario) VALUES
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
INSERT INTO pizza (id, nombre, tamaño, precio_base, tipo) VALUES
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

-- 10. PEDIDOS
INSERT INTO pedido (id, fecha, metodo_pago, estado, total, cliente_fk, encargado_caja_fk) VALUES
(1, '2026-03-01 12:30:00', 'efectivo', 'entregado', 22000, 1, 7),
(2, '2026-03-01 13:15:00', 'tarjeta', 'entregado', 40000, 2, 7),
(3, '2026-03-01 14:00:00', 'efectivo', 'entregado', 38000, 3, 8),

-- Pedidos del 2 de marzo
(4, '2026-03-02 11:45:00', 'tarjeta', 'preparando', 25000, 1, 7),
(5, '2026-03-02 12:30:00', 'efectivo', 'pendiente', 52000, 4, 8),
(6, '2026-03-02 19:00:00', 'tarjeta', 'entregado', 20000, 5, 7),

-- Pedidos del 3 de marzo
(7, '2026-03-03 13:00:00', 'efectivo', 'cancelado', 22000, 2, 8),
(8, '2026-03-03 20:30:00', 'tarjeta', 'entregado', 45000, 6, 7),

-- Pedidos adicionales para análisis
(9, '2026-03-04 12:00:00', 'efectivo', 'entregado', 32000, 1, 7),
(10, '2026-03-04 13:30:00', 'tarjeta', 'entregado', 45000, 2, 8),
(11, '2026-03-05 11:00:00', 'app', 'entregado', 28000, 3, 7),
(12, '2026-03-05 14:00:00', 'efectivo', 'entregado', 52000, 4, 8),
(13, '2026-03-06 12:45:00', 'tarjeta', 'entregado', 38000, 5, 7),
(14, '2026-03-06 21:00:00', 'app', 'entregado', 65000, 6, 8);

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

-- 14. HISTORIAL_PRECIOS
INSERT INTO historial_precios (id, precio_anterior, precio_nuevo, fecha_modificacion, pizza_fk) VALUES
-- Cambios del mes de enero
(1, 15000, 18000, '2026-01-15 10:30:00', 1),
(2, 20000, 22000, '2026-01-20 14:15:00', 2),

-- Cambios del mes de febrero
(3, 18000, 20000, '2026-02-01 09:45:00', 3),
(4, 22000, 25000, '2026-02-15 16:30:00', 5),

-- Cambios del mes de marzo (más recientes)
(5, 17000, 19000, '2026-03-01 11:00:00', 6),
(6, 25000, 28000, '2026-03-05 15:20:00', 5),
(7, 19000, 21000, '2026-03-10 08:45:00', 4),
(8, 18000, 20000, '2026-03-15 12:30:00', 1);
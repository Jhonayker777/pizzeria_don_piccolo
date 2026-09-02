-- =============================================
-- BASE DE DATOS: PIZZERÍA DON PICCOLO
-- SOLO CREACIÓN DE TABLAS
-- =============================================

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- =============================================
-- 1. CREACIÓN DEL SCHEMA
-- =============================================

CREATE SCHEMA IF NOT EXISTS `pizzeria_don_piccolo` DEFAULT CHARACTER SET utf8mb3;
USE `pizzeria_don_piccolo`;

-- =============================================
-- 2. CREACIÓN DE TABLAS
-- =============================================

-- -----------------------------------------------------
-- Table `persona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria_don_piccolo`.`persona` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  `Apellido` VARCHAR(45) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `telefono`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria_don_piccolo`.`telefono` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `numero` INT NOT NULL,
  `indicativo` INT NOT NULL,
  `persona_fk` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `persona_fk1_idx` (`persona_fk` ASC) VISIBLE,
  CONSTRAINT `persona_fk1`
    FOREIGN KEY (`persona_fk`)
    REFERENCES `pizzeria_don_piccolo`.`persona` (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria_don_piccolo`.`cliente` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `direccion` VARCHAR(45) NOT NULL,
  `fecha_registro` DATE NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `persona_fk2`
    FOREIGN KEY (`id`)
    REFERENCES `pizzeria_don_piccolo`.`persona` (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `empleado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria_don_piccolo`.`empleado` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `salario_base` DOUBLE NOT NULL,
  `fecha_contratacion` DATE NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `persona_fk3`
    FOREIGN KEY (`id`)
    REFERENCES `pizzeria_don_piccolo`.`persona` (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `encargado_caja`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria_don_piccolo`.`encargado_caja` (
  `id` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  CONSTRAINT `empleado_fk2`
    FOREIGN KEY (`id`)
    REFERENCES `pizzeria_don_piccolo`.`empleado` (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `repartidor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria_don_piccolo`.`repartidor` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `zona` VARCHAR(45) NOT NULL DEFAULT 'libre',
  `estado` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  CONSTRAINT `empleado_fk1`
    FOREIGN KEY (`id`)
    REFERENCES `pizzeria_don_piccolo`.`empleado` (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `ingredientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria_don_piccolo`.`ingredientes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `stock` INT NOT NULL,
  `stock_minimo` INT NOT NULL DEFAULT 5,
  `precio_unitario` DOUBLE NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `pizza`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria_don_piccolo`.`pizza` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `tamano_cm` DOUBLE NOT NULL,
  `precio_base` DOUBLE NOT NULL,
  `tipo` ENUM('vegetariana', 'especial', 'clasica') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `pizza_ingredientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria_don_piccolo`.`pizza_ingredientes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `pizza_fk` INT NOT NULL,
  `ingredientes_fk` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `pizza_fk_idx` (`pizza_fk` ASC) VISIBLE,
  INDEX `ingredientes_fk_idx` (`ingredientes_fk` ASC) VISIBLE,
  CONSTRAINT `pizza_fk`
    FOREIGN KEY (`pizza_fk`)
    REFERENCES `pizzeria_don_piccolo`.`pizza` (`id`),
  CONSTRAINT `ingredientes_fk`
    FOREIGN KEY (`ingredientes_fk`)
    REFERENCES `pizzeria_don_piccolo`.`ingredientes` (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria_don_piccolo`.`pedido` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATETIME NOT NULL,
  `metodo_pago` ENUM('efectivo', 'tarjeta') NOT NULL,
  `estado` ENUM('pendiente', 'preparando', 'entregado', 'cancelado') NOT NULL,
  `total` DOUBLE NOT NULL,
  `cliente_fk` INT NOT NULL,
  `encargado_caja_fk` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `cliente_fk_idx` (`cliente_fk` ASC) VISIBLE,
  INDEX `encargado_caja_fk_idx` (`encargado_caja_fk` ASC) VISIBLE,
  CONSTRAINT `cliente_fk`
    FOREIGN KEY (`cliente_fk`)
    REFERENCES `pizzeria_don_piccolo`.`cliente` (`id`),
  CONSTRAINT `encargado_caja_fk`
    FOREIGN KEY (`encargado_caja_fk`)
    REFERENCES `pizzeria_don_piccolo`.`encargado_caja` (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `pedido_pizzas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria_don_piccolo`.`pedido_pizzas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cantidad` INT NOT NULL,
  `precio_unitario` DOUBLE NOT NULL,
  `pedido_fk` INT NOT NULL,
  `pizza_fk` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `pizza_fk_idx` (`pizza_fk` ASC) VISIBLE,
  INDEX `pedido_fk_idx` (`pedido_fk` ASC) VISIBLE,
  CONSTRAINT `pedido_fk1`
    FOREIGN KEY (`pedido_fk`)
    REFERENCES `pizzeria_don_piccolo`.`pedido` (`id`),
  CONSTRAINT `pizza_fk3`
    FOREIGN KEY (`pizza_fk`)
    REFERENCES `pizzeria_don_piccolo`.`pizza` (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `domicilio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria_don_piccolo`.`domicilio` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `hora_salida` DATETIME NOT NULL,
  `hora_llegada` DATETIME NULL DEFAULT NULL,
  `distancia` DOUBLE NOT NULL,
  `precio_envio` DOUBLE NOT NULL,
  `pedido_fk` INT NOT NULL,
  `repartidor_fk` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `pedido_fk_idx` (`pedido_fk` ASC) VISIBLE,
  INDEX `repartidor_fk_idx` (`repartidor_fk` ASC) VISIBLE,
  CONSTRAINT `pedido_fk3`
    FOREIGN KEY (`pedido_fk`)
    REFERENCES `pizzeria_don_piccolo`.`pedido` (`id`),
  CONSTRAINT `repartidor_fk`
    FOREIGN KEY (`repartidor_fk`)
    REFERENCES `pizzeria_don_piccolo`.`repartidor` (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `pago`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria_don_piccolo`.`pago` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `monto` DOUBLE NOT NULL,
  `metodo_pago` ENUM('efectivo', 'tarjeta') NOT NULL,
  `fecha_pago` DATE NOT NULL,
  `estado` ENUM('pagado', 'pendiente', 'rechazado') NOT NULL,
  `pedido_fk` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `pedido_fk_idx` (`pedido_fk` ASC) VISIBLE,
  CONSTRAINT `pedido_fk2`
    FOREIGN KEY (`pedido_fk`)
    REFERENCES `pizzeria_don_piccolo`.`pedido` (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `historial_precios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria_don_piccolo`.`historial_precios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `precio_anterior` DOUBLE NOT NULL,
  `precio_nuevo` DOUBLE NOT NULL,
  `fecha_modificacion` DATETIME NOT NULL,
  `pizza_fk` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `pizza_fk_idx` (`pizza_fk` ASC) VISIBLE,
  CONSTRAINT `pizza_fk2`
    FOREIGN KEY (`pizza_fk`)
    REFERENCES `pizzeria_don_piccolo`.`pizza` (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb3;

-- =============================================
-- 3. RESTAURAR CONFIGURACIONES
-- =============================================

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
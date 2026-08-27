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

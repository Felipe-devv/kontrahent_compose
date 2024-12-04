CREATE SCHEMA IF NOT EXISTS `kontrahent` DEFAULT CHARACTER SET utf8mb4;
USE `kontrahent`;

-- Wyłączenie kluczy obcych na czas tworzenia tabel
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------
-- Table `kontrahent`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `surname` VARCHAR(45) NOT NULL,`status` ENUM('active', 'inactive','blocked') NOT NULL,
  `role` ENUM('ROLE_admin','ROLE_regular') NOT NULL,
  `password` CHAR(68) NOT NULL, -- dla hashowania hasla przez bcrypt dlugosc pola stala
  `created` TIMESTAMP NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  CONSTRAINT user_pk PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT=1;
-- -----------------------------------------------------
-- Table `kontrahent`.`problem_report`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user_report`;
CREATE TABLE IF NOT EXISTS `user_report` (
	`id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NOT NULL,
    `type` ENUM('information','problem','error') NOT NULL,
    `status` ENUM('pending','resolved','rejected') NOT NULL,
    `description` VARCHAR(400) NOT NULL,
    CONSTRAINT user_report_pk PRIMARY KEY (`id`),
    INDEX `fk_user_report_user1_idx` (`user_id` ASC),
	INDEX `type_idx` (`type` ASC),
    INDEX `status_idx` (`status` ASC),
	CONSTRAINT `fk_user_report_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
)ENGINE = InnoDB AUTO_INCREMENT=1001;
-- -------------------------------------------------
-- Table `mydb`.`address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE IF NOT EXISTS `address` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `country` VARCHAR(45) NOT NULL,
  `street` VARCHAR(45) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `flat_number` VARCHAR(45) NOT NULL,
  `postcode` VARCHAR(45) NOT NULL,
  CONSTRAINT address_pk PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT=1;

-- -----------------------------------------------------
-- Table `mydb`.`branza`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `industry`;
CREATE TABLE IF NOT EXISTS `industry` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(400),
  CONSTRAINT industry_pk PRIMARY KEY (`id`)
) ENGINE = InnoDB AUTO_INCREMENT=11;

-- -----------------------------------------------------
-- Table `mydb`.`udostępniający`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `provider`;
CREATE TABLE IF NOT EXISTS `provider` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT UNIQUE NOT NULL,
  `industry_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `nip` VARCHAR(45) NOT NULL,
  `regon` VARCHAR(45) NOT NULL,
  `krs` VARCHAR(45) NULL,
  `address_id` INT NOT NULL,
  CONSTRAINT provider_pk PRIMARY KEY (`id`),
  INDEX `fk_provider_user1_idx` (`user_id` ASC),
  INDEX `fk_provider_industry1_idx` (`industry_id` ASC),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  UNIQUE INDEX `nip_UNIQUE` (`nip` ASC),
  UNIQUE INDEX `regon_UNIQUE` (`regon` ASC),
  UNIQUE INDEX `krs_UNIQUE` (`krs` ASC),
  INDEX `fk_provider_address1_idx` (`address_id` ASC),
  CONSTRAINT `fk_provider_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_provider_industry`
    FOREIGN KEY (`industry_id`)
    REFERENCES `industry` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_provider_address1`
    FOREIGN KEY (`address_id`)
    REFERENCES `address` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT=1;

-- -----------------------------------------------------
-- Table `kontrahent`.`product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE IF NOT EXISTS `product` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `serial_number` VARCHAR(45) NOT NULL,
  `description` VARCHAR(400) NULL,
  CONSTRAINT product_pk PRIMARY KEY (`id`))
ENGINE = InnoDB AUTO_INCREMENT=1;

-- -----------------------------------------------------
-- Table `kontrahent`.`offer_product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `offer_product`;
CREATE TABLE IF NOT EXISTS `offer_product` (
  `provider_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `price` DOUBLE NOT NULL,
  `tax` INT NOT NULL,
  `basis_weight` DOUBLE NULL,
  CONSTRAINT offer_product_pk PRIMARY KEY (`provider_id`, `product_id`),
  CONSTRAINT `fk_offer_product_provider`
    FOREIGN KEY (`provider_id`)
    REFERENCES `provider` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_offer_product_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `kontrahent`.`product_has_industry`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `product_has_industry`;
CREATE TABLE IF NOT EXISTS `product_has_industry` (
  `product_id` INT NOT NULL,
  `industry_id` INT NOT NULL,
  CONSTRAINT product_industry_pk PRIMARY KEY (`product_id`, `industry_id`),
  CONSTRAINT `fk_product_has_industry_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `product` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_produkt_has_industry_industry`
    FOREIGN KEY (`industry_id`)
    REFERENCES `industry` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `kontrahent`.`acquirer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `acquirer`;
CREATE TABLE IF NOT EXISTS `acquirer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `provider_id` INT  UNIQUE NOT NULL,
  CONSTRAINT acquirer_pk PRIMARY KEY (`id`),
  CONSTRAINT `fk_acquirer_user`
    FOREIGN KEY (`provider_id`)
    REFERENCES `provider` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB AUTO_INCREMENT=1;

-- -----------------------------------------------------
-- Table `kontrahent`.`implementation_method`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `implementation_method`;
CREATE TABLE IF NOT EXISTS `implementation_method` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(400) NULL,
  CONSTRAINT impl_method_pk PRIMARY KEY (`id`))
ENGINE = InnoDB AUTO_INCREMENT=7771;

-- -----------------------------------------------------
-- Table `kontrahent`.`order_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `order_status`;
CREATE TABLE IF NOT EXISTS `order_status` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(400) NULL,
  CONSTRAINT order_status_pk PRIMARY KEY (`id`))
ENGINE = InnoDB AUTO_INCREMENT=8881;

-- -----------------------------------------------------
-- Table `kontrahent`.`order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `acquirer_id` INT NOT NULL,
  `implementation_method_id` INT NOT NULL,
  `order_status_id` INT NOT NULL,
  `provider_id` INT NOT NULL,
  `order_value` DOUBLE NOT NULL,
  `submission_date` TIMESTAMP NOT NULL,
  `admission_date` TIME NOT NULL,
  `address_id` INT NOT NULL,
  CONSTRAINT order_pk PRIMARY KEY (`id`),
  CONSTRAINT `fk_order_acquirer`
    FOREIGN KEY (`acquirer_id`)
    REFERENCES `acquirer` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_order_impl_method`
    FOREIGN KEY (`implementation_method_id`)
    REFERENCES `implementation_method` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_order_order_status`
    FOREIGN KEY (`order_status_id`)
    REFERENCES `order_status` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_order_provider`
    FOREIGN KEY (`provider_id`)
    REFERENCES `provider` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_order_address`
    FOREIGN KEY (`address_id`)
    REFERENCES `address` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB AUTO_INCREMENT=10001;




-- -----------------------------------------------------
-- Table `kontrahent`.`order_details`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `order_details`;
CREATE TABLE IF NOT EXISTS `order_details` (
  `product_id` INT NOT NULL,
  `order_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  `unit_price` DOUBLE NOT NULL,
  PRIMARY KEY (`product_id`, `order_id`),
  CONSTRAINT `fk_order_details_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_order_details_order`
    FOREIGN KEY (`order_id`)
    REFERENCES `orders` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


ALTER DATABASE `kontrahent`
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;
-- Ponowne włączenie kluczy obcych
SET FOREIGN_KEY_CHECKS = 1;

-- Wstawianie danych do tabeli 'user'
INSERT INTO `user` (`name`, `surname`, `status`,`role`, `password`, `created`, `email`)
VALUES 
('Jan', 'Kowalski', 'active','ROLE_regular','$2a$10$kxxtuEi0/Jcpsv6nm7FjnOTvl3C.RyudwrgpmHqSpw678whrRNdXa', '2023-09-09 10:10:10', 'jan.kowalski@example.com'),
('Anna', 'Nowak', 'active','ROLE_admin', '$2a$10$kxxtuEi0/Jcpsv6nm7FjnOTvl3C.RyudwrgpmHqSpw678whrRNdXa', '2023-09-10 11:15:20', 'anna.nowak@example.com'),
('Piotr', 'Zieliński', 'active','ROLE_regular', '$2a$10$kxxtuEi0/Jcpsv6nm7FjnOTvl3C.RyudwrgpmHqSpw678whrRNdXa', '2023-09-11 14:30:40', 'piotr.zielinski@example.com'),
('Maria', 'Wiśniewska', 'active','ROLE_regular', '$2a$10$kxxtuEi0/Jcpsv6nm7FjnOTvl3C.RyudwrgpmHqSpw678whrRNdXa', '2023-09-12 16:50:50', 'maria.wisniewska@example.com'),
('Katarzyna', 'Lis', 'active','ROLE_regular','$2a$10$kxxtuEi0/Jcpsv6nm7FjnOTvl3C.RyudwrgpmHqSpw678whrRNdXa', '2023-09-15 10:10:10', 'katarzyna.lis@example.com'),
('Tomasz', 'Nowak', 'active','ROLE_admin', '$2a$10$kxxtuEi0/Jcpsv6nm7FjnOTvl3C.RyudwrgpmHqSpw678whrRNdXa', '2023-09-16 11:15:20', 'tomasz.nowak@example.com'),
('Agnieszka', 'Szczepańska', 'active','ROLE_regular', '$2a$10$kxxtuEi0/Jcpsv6nm7FjnOTvl3C.RyudwrgpmHqSpw678whrRNdXa', '2023-09-17 14:30:40', 'agnieszka.szczepanska@example.com');

-- Wstawianie danych do tabeli 'address'
INSERT INTO `address` (`country`, `street`, `city`, `flat_number`, `postcode`)
VALUES
('Poland', 'Wilanowska', 'Warsaw', '12A', '02-001'),
('Poland', 'Długa', 'Krakow', '34B', '31-222'),
('Poland', 'Kościuszki', 'Poznan', '45C', '60-001'),
('Poland', 'Piotrkowska', 'Lodz', '56D', '90-001'),
('Poland', 'Żwirki', 'Katowice', '78A', '40-002'),
('Poland', 'Główna', 'Gdańsk', '98B', '80-001');

-- Wstawianie danych do tabeli 'industry'
INSERT INTO `industry` (`name`, `description`)
VALUES
('IT', 'Software development and IT services'),
('Construction', 'Building and construction services'),
('Retail', 'Sales of consumer goods'),
('Healthcare', 'Medical and healthcare services'),
('Education', 'Educational services and institutions'),
('Manufacturing', 'Manufacturing industry services');

-- Wstawianie danych do tabeli 'provider'
INSERT INTO `provider` (`user_id`, `industry_id`, `name`, `nip`, `regon`, `krs`, `address_id`)
VALUES
(1, 11, 'Januszex', '1234567890', '123456789', '0000123456', 1),
(2, 12, 'Pewex', '0987654321', '987654321', '0000654321', 2),
(3, 13, 'Azoty SA', '4561237890', '456123789', NULL, 3),
(4, 14, 'Optima SA', '5678901234', '567890123', NULL, 4),
(5, 15, 'BestBuild', '6789012345', '678901234', '0000765432', 5),
(7, 15, 'Budimex', '8267566757', '419459599', '0000765433', 6);

-- Wstawianie danych do tabeli 'acquirer'
INSERT INTO `acquirer` (`provider_id`)
VALUES
(1),
(2),
(3),
(4),
(5),
(6);

-- Wstawianie danych do tabeli 'product'
INSERT INTO `product` (`name`, `serial_number`, `description`)
VALUES
('Product A', 'ABC123', 'First product'),
('Product B', 'DEF456', 'Second product'),
('Product C', 'GHI789', 'Third product'),
('Product D', 'JKL012', 'Fourth product'),
('Product E', 'MNO345', 'Fifth product'),
('Product F', 'PQR678', 'Sixth product'),
('Product G', 'STU901', 'Seventh product'),
('Product H', 'VWX234', 'Eighth product'),
('Product I', 'YZA567', 'Ninth product'),
('Product J', 'BCD890', 'Tenth product'),
('Product K', 'EFG123', 'Eleventh product'),
('Product L', 'HIJ456', 'Twelfth product'),
('Product M', 'KLM789', 'Thirteenth product'),
('Product N', 'NOP012', 'Fourteenth product'),
('Product O', 'QRS345', 'Fifteenth product'),
('Product P', 'QWE123', 'Sixteenth product'),
('Product Q', 'RTY456', 'Seventeenth product'),
('Product R', 'UIO789', 'Eighteenth product'),
('Product S', 'PAS123', 'Nineteenth product');

-- Wstawianie danych do tabeli 'implementation_method'
INSERT INTO `implementation_method` (`name`, `description`)
VALUES
('Method A', 'First implementation method'),
('Method B', 'Second implementation method'),
('Method C', 'Third implementation method');

-- Wstawianie danych do tabeli 'order_status'
INSERT INTO `order_status` (`name`, `description`)
VALUES
('Pending', 'Order is pending'),
('Completed', 'Order is completed');

-- Wstawianie danych do tabeli 'offer_product'
INSERT INTO `offer_product` (`provider_id`, `product_id`, `price`, `tax`, `basis_weight`)
VALUES
(1, 1, 100.0, 8, 1.9),
(1, 2, 158.9, 23, 10.0),
(2, 3, 200.0, 8, 0.33),
(2, 4, 250.0, 8, 500),
(3, 5, 300.0, 23, 1.6),
(3, 6, 350.5, 8, 1.2),
(1, 7, 400.0, 5, 1.80),
(1, 8, 450.0, 5, 6.4),
(2, 9, 500.0, 5, 1.0),
(3, 10, 550.0, 23, 1.0),
(4, 11, 600.0, 23, 3.2),
(4, 12, 700.0, 5, 1.8),
(5, 13, 800.0, 8, 0.45),
(5, 14, 900.0, 8, 2.0);

-- Wstawianie danych do tabeli 'product_has_industry'
INSERT INTO `product_has_industry` (`product_id`, `industry_id`)
VALUES
(1, 11),
(2, 12),
(3, 13),
(4, 14),
(5, 11),
(6, 12),
(7, 13),
(8, 14),
(9, 11),
(10, 12),
(11, 13),
(12, 14),
(13, 11),
(14, 12),
(5,14), -- product with id 5 in two industries
(15, 13),
(11, 15),
(12, 16),
(13, 14),
(14, 15);

-- Wstawianie danych do tabeli 'orders'
INSERT INTO `orders` (`acquirer_id`, `implementation_method_id`, `order_status_id`, `provider_id`, `order_value`, `submission_date`, `admission_date`, `address_id`)
VALUES
(1, 7771, 8881, 1, 5000, '2023-09-10 15:00:00', '16:00:00', 1),
(2, 7772, 8882, 2, 3500, '2023-09-11 14:00:00', '15:00:00', 2),
(3, 7773, 8881, 4, 4000, '2023-09-15 17:00:00', '18:00:00', 3),
(4, 7771, 8882, 5, 4500, '2023-09-16 18:00:00', '19:00:00', 4),
(4, 7772, 8881, 5, 45000, '2023-09-16 18:00:00', '19:00:00', 4),
(4, 7773, 8882, 5, 1200, '2023-09-16 18:00:00', '19:00:00', 4),
(5, 7771, 8882, 5, 7000, '2023-09-16 18:00:00', '19:00:00', 5)
;

-- Wstawianie danych do tabeli 'order_details'
INSERT INTO `order_details` (`product_id`, `order_id`, `quantity`, `unit_price`)
VALUES
(1, 10001, 2, 500),
(2, 10002, 1, 1500),
(3, 10003, 3, 666.67),
(4, 10004, 1, 2500),
(5, 10004, 4, 750),
(6, 10002, 2, 1750),
(7, 10001, 1, 1000),
(8, 10002, 5, 300),
(11, 10004, 2, 2000),
(12, 10001, 1, 4500),
(16, 10005, 10, 4500),
(17, 10006, 2, 500),
(18, 10006, 1, 200),
(9, 10007, 2, 3500),
(13, 10002, 5, 1600),
(14, 10003, 2, 2250);

INSERT INTO `user_report` (`user_id`,`type`,`status`,`description`)
VALUES
(1,'information','pending','Site could be faster'),
(2,'information','pending','Sitel could look nicer'),
(2,'error','resolved','Site deleted my windows os')
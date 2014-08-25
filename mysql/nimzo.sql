SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `_app` ;
CREATE SCHEMA IF NOT EXISTS `_app` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
SHOW WARNINGS;
DROP SCHEMA IF EXISTS `_common` ;
CREATE SCHEMA IF NOT EXISTS `_common` ;
SHOW WARNINGS;
DROP SCHEMA IF EXISTS `_client_config` ;
CREATE SCHEMA IF NOT EXISTS `_client_config` ;
SHOW WARNINGS;
USE `_app` ;

-- -----------------------------------------------------
-- Table `_app`.`brand`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`brand` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`brand` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `private_title` VARCHAR(45) NULL,
  `private_description` VARCHAR(255) NULL,
  `public_title` VARCHAR(45) NULL,
  `public_description` VARCHAR(255) NULL,
  `url` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`commodity_code`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`commodity_code` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`commodity_code` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`tax_code`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`tax_code` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`tax_code` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`user` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`user` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `flag_locked` ENUM('0','1') NOT NULL DEFAULT '0' COMMENT '0 = USER ACCOUNT NOT LOCKED\n1 = USER ACCOUNT LOCKED',
  `database_id` VARCHAR(15) NOT NULL,
  `username` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NULL,
  `password_hint` VARCHAR(150) NULL,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`product` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`product` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `is_available` ENUM('0','1') NOT NULL DEFAULT '1' COMMENT '0 = MARK AS OUT OF STOCK\n1 = MARK AS IN STOCK',
  `is_visible` ENUM('0','1') NOT NULL DEFAULT '1' COMMENT '0 = NOT VISIBLE\n1 = VISIBILE',
  `is_new` ENUM('0','1') NOT NULL DEFAULT '1' COMMENT '0 = USED\n1 = NEW',
  `is_stock_tracked` ENUM('0','1') NOT NULL DEFAULT '1' COMMENT '0 = NOT STOCK TRACKED\n1 = STOCK TRACKED',
  `is_bundle` ENUM('0','1') NOT NULL DEFAULT '0' COMMENT '0 = NON BUNDLE ITEM\n1 = BUNDLE MASTER ITEM\n\nBUNDLE MASTER ITEMS WILL JOIN TO SUB-ITEMS VIA \'product_bundle\'',
  `is_variation` ENUM('0','1') NOT NULL DEFAULT '0' COMMENT '0 = NON VARIATION ITEM\n1 = VARIATION MASTER ITEM\n\nVARIATION MASTER ITEMS WILL JOIN TO SUB-ITEMS VIA \'product_variation\'',
  `created_date` DATETIME NULL,
  `created_user_id` INT UNSIGNED NULL,
  `product_sku` VARCHAR(64) NOT NULL COMMENT 'Internal product code, needs to be unique.',
  `product_ean` VARCHAR(20) NULL,
  `product_title` VARCHAR(255) NULL,
  `product_subtitle` VARCHAR(255) NULL,
  `product_description` TEXT NULL,
  `meta_title` VARCHAR(255) NULL,
  `meta_description` VARCHAR(255) NULL,
  `meta_keywords` TEXT NULL,
  `brand_id` INT UNSIGNED NULL,
  `brand_sku` VARCHAR(64) NULL,
  `commodity_code_id` INT UNSIGNED NULL,
  `tax_code_id` INT UNSIGNED NULL,
  `opts_preferred_qty` INT UNSIGNED NOT NULL DEFAULT 0,
  `opts_reorder_qty` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `products_brands_id_idx` (`brand_id` ASC),
  INDEX `products_commodity_code_id_idx` (`commodity_code_id` ASC),
  INDEX `products_tax_code_id_idx` (`tax_code_id` ASC),
  INDEX `products_users_id_idx` (`created_user_id` ASC),
  UNIQUE INDEX `product_sku_UNIQUE` (`product_sku` ASC),
  CONSTRAINT `products_brands_id`
    FOREIGN KEY (`brand_id`)
    REFERENCES `_app`.`brand` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `products_commodity_code_id`
    FOREIGN KEY (`commodity_code_id`)
    REFERENCES `_common`.`commodity_code` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `products_tax_code_id`
    FOREIGN KEY (`tax_code_id`)
    REFERENCES `_common`.`tax_code` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `products_users_id`
    FOREIGN KEY (`created_user_id`)
    REFERENCES `_app`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`product_pricelist_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`product_pricelist_type` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`product_pricelist_type` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`currency`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`currency` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`currency` (
  `id` INT UNSIGNED NOT NULL,
  `code` VARCHAR(3) NOT NULL COMMENT 'USD, GBP',
  `name` VARCHAR(45) NOT NULL COMMENT 'US Dollar, Pound Sterling',
  `symbol` VARCHAR(10) NULL COMMENT '$, £',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`product_pricelist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`product_pricelist` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`product_pricelist` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_pricelist_type_id` INT UNSIGNED NOT NULL,
  `currency_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `product_pricelist_product_pricelist_type_id_idx` (`product_pricelist_type_id` ASC),
  INDEX `product_pricelist_currency_id_idx` (`currency_id` ASC),
  CONSTRAINT `product_pricelist_product_pricelist_type_id`
    FOREIGN KEY (`product_pricelist_type_id`)
    REFERENCES `_common`.`product_pricelist_type` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `product_pricelist_currency_id`
    FOREIGN KEY (`currency_id`)
    REFERENCES `_common`.`currency` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`product_price`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`product_price` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`product_price` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NOT NULL,
  `pricelist_id` INT UNSIGNED NOT NULL,
  `amount` DECIMAL(13,4) NOT NULL DEFAULT 0.00,
  `minimum_qty` SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `products_id_idx` (`product_id` ASC),
  INDEX `products_prices_products_pricelists_id_idx` (`pricelist_id` ASC),
  CONSTRAINT `product_price_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `product_price_product_pricelist_id`
    FOREIGN KEY (`pricelist_id`)
    REFERENCES `_app`.`product_pricelist` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`product_bullet`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`product_bullet` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`product_bullet` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NOT NULL,
  `value` VARCHAR(255) NULL,
  `sort_order` INT UNSIGNED NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `product_id_idx` (`product_id` ASC),
  CONSTRAINT `products_bullets_products_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`product_content`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`product_content` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`product_content` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NOT NULL,
  `value` VARCHAR(255) NULL,
  `sort_order` INT UNSIGNED NULL DEFAULT 1,
  INDEX `product_id_idx` (`product_id` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `product_content_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`contact_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`contact_type` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`contact_type` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL COMMENT 'SUPPLIER\nCUSTOMER\nCOMPANY',
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Holds all the different order types:\nEBAY\nAMAZON\nSHOPIFY';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`contact`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`contact` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`contact` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `contact_type_id` INT UNSIGNED NOT NULL,
  `created_date` DATETIME NOT NULL,
  `full_name` VARCHAR(90) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `contact_contact_type_id_idx` (`contact_type_id` ASC),
  CONSTRAINT `contact_contact_type_id`
    FOREIGN KEY (`contact_type_id`)
    REFERENCES `_common`.`contact_type` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`product_supplier_map`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`product_supplier_map` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`product_supplier_map` (
  `product_id` INT UNSIGNED NOT NULL,
  `contact_id` INT UNSIGNED NOT NULL,
  `supplier_sku` VARCHAR(64) NULL,
  INDEX `products_suppliers_products_id_idx` (`product_id` ASC),
  INDEX `products_suppliers_contacts_id_idx` (`contact_id` ASC),
  PRIMARY KEY (`product_id`),
  CONSTRAINT `products_suppliers_products_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `products_suppliers_contacts_id`
    FOREIGN KEY (`contact_id`)
    REFERENCES `_app`.`contact` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`warehouse`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`warehouse` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`warehouse` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `address_id` INT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`product_stock`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`product_stock` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`product_stock` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NOT NULL,
  `warehouse_id` INT UNSIGNED NOT NULL,
  `qty` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `products_stock_products_id_idx` (`product_id` ASC),
  INDEX `products_stock_warehouses_id_idx` (`warehouse_id` ASC),
  CONSTRAINT `product_stock_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `product_stock_warehouse_id`
    FOREIGN KEY (`warehouse_id`)
    REFERENCES `_app`.`warehouse` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`product_bundle`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`product_bundle` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`product_bundle` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NOT NULL COMMENT 'MASTER PRODUCT ID',
  `bundled_product_id` INT UNSIGNED NOT NULL COMMENT 'BUNDLED PRODUCT ID (USUALLY MULTIPLE)',
  `bundled_product_qty` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'QTY OF BUNDLED PRODUCT',
  PRIMARY KEY (`id`),
  INDEX `products_bundles_products_id_idx` (`product_id` ASC),
  INDEX `products_bundles_products_id_bundled_idx` (`bundled_product_id` ASC),
  CONSTRAINT `product_bundle_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `product_bundle_bundled_product_id`
    FOREIGN KEY (`bundled_product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`dimension_unit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`dimension_unit` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`dimension_unit` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `short_name` VARCHAR(5) NOT NULL,
  `long_name` VARCHAR(15) NOT NULL,
  `long_name_plural` VARCHAR(15) NOT NULL,
  `to_millimeters` DECIMAL(10,8) UNSIGNED NULL,
  `to_centimeters` DECIMAL(10,8) UNSIGNED NULL,
  `to_inches` DECIMAL(10,8) UNSIGNED NULL,
  `to_feet` DECIMAL(10,8) UNSIGNED NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`weight_unit`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`weight_unit` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`weight_unit` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `short_name` VARCHAR(5) NOT NULL,
  `long_name` VARCHAR(10) NOT NULL,
  `long_name_plural` VARCHAR(10) NOT NULL,
  `to_grams` DECIMAL(10,8) UNSIGNED NULL,
  `to_kilos` DECIMAL(10,8) UNSIGNED NULL,
  `to_ounces` DECIMAL(10,8) UNSIGNED NULL,
  `to_pounds` DECIMAL(10,8) UNSIGNED NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`product_assembled_dimension`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`product_assembled_dimension` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`product_assembled_dimension` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NOT NULL,
  `part_name` VARCHAR(45) NOT NULL COMMENT 'IF A PRODUCT COMES IN MORE THAN 1 PART, THIS WOULD BE THE NAME GIVEN TO THIS PART.',
  `part_qty` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'IF A PRODUCT COMES IN MORE THAN 1 PART, THIS WOULD THE QTY FOR THIS PART.',
  `dimensions_unit_id` INT UNSIGNED NULL,
  `width` DECIMAL(10,4) UNSIGNED NULL,
  `height` DECIMAL(10,4) UNSIGNED NULL,
  `depth` DECIMAL(10,4) UNSIGNED NULL,
  `weight_unit_id` INT UNSIGNED NULL,
  `weight` DECIMAL(10,4) UNSIGNED NULL,
  `sort_order` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `products_assessment_assembled_products_id_idx` (`product_id` ASC),
  INDEX `products_assembled_dimensions_dimension_units_id_idx` (`dimensions_unit_id` ASC),
  INDEX `products_assembled_dimensions_weight_units_id_idx` (`weight_unit_id` ASC),
  CONSTRAINT `product_assembled_dimension_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `product_assembled_dimension_dimension_unit_id`
    FOREIGN KEY (`dimensions_unit_id`)
    REFERENCES `_common`.`dimension_unit` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `product_assembled_dimension_weight_unit_id`
    FOREIGN KEY (`weight_unit_id`)
    REFERENCES `_common`.`weight_unit` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`product_packaged_dimension`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`product_packaged_dimension` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`product_packaged_dimension` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NOT NULL,
  `part_name` VARCHAR(45) NOT NULL COMMENT 'IF A PRODUCT COMES IN MORE THAN 1 PART, THIS WOULD BE THE NAME GIVEN TO THIS PART.',
  `part_qty` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'IF A PRODUCT COMES IN MORE THAN 1 PART, THIS WOULD THE QTY FOR THIS PART.',
  `dimensions_unit_id` INT UNSIGNED NULL,
  `width` DECIMAL(10,4) UNSIGNED NULL,
  `height` DECIMAL(10,4) UNSIGNED NULL,
  `depth` DECIMAL(10,4) UNSIGNED NULL,
  `weight_unit_id` INT UNSIGNED NULL,
  `weight` DECIMAL(10,4) UNSIGNED NULL,
  `sort_order` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `products_assessment_assembled_products_id_idx` (`product_id` ASC),
  INDEX `products_assembled_dimensions_dimension_units_id_idx` (`dimensions_unit_id` ASC),
  INDEX `products_assembled_dimensions_weight_units_id_idx` (`weight_unit_id` ASC),
  CONSTRAINT `product_packaged_dimension_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `product_packaged_dimension_dimension_unit_id`
    FOREIGN KEY (`dimensions_unit_id`)
    REFERENCES `_common`.`dimension_unit` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `product_packaged_dimension_weight_unit_id`
    FOREIGN KEY (`weight_unit_id`)
    REFERENCES `_common`.`weight_unit` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`category` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`category` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `channel_id` INT UNSIGNED NOT NULL,
  `parent_node` INT UNSIGNED NULL,
  `category_title` VARCHAR(255) NULL,
  `meta_title` VARCHAR(255) NULL,
  `meta_description` VARCHAR(255) NULL,
  `meta_keywords` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`channel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`channel` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`channel` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `flag_active` ENUM('0','1') NOT NULL DEFAULT '1' COMMENT '0 = NOT ACTIVE\n1 = ACTIVE',
  `store_name` VARCHAR(128) NULL,
  `store_url` VARCHAR(255) NULL,
  `ftp_host` VARCHAR(128) NULL,
  `ftp_username` VARCHAR(32) NULL,
  `ftp_password` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`product_category_map`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`product_category_map` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`product_category_map` (
  `product_id` INT UNSIGNED NOT NULL,
  `category_id` INT UNSIGNED NOT NULL,
  `channel_id` INT UNSIGNED NOT NULL,
  INDEX `products_categories_products_id_idx` (`product_id` ASC),
  INDEX `products_categories_categories_id_idx` (`category_id` ASC),
  INDEX `products_categories_stores_id_idx` (`channel_id` ASC),
  PRIMARY KEY (`product_id`),
  CONSTRAINT `product_category_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `product_category_category_id`
    FOREIGN KEY (`category_id`)
    REFERENCES `_app`.`category` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `product_category_channel_id`
    FOREIGN KEY (`channel_id`)
    REFERENCES `_app`.`channel` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`image`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`image` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`image` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `uploaded_date` DATETIME NOT NULL,
  `uploaded_user_id` INT UNSIGNED NOT NULL,
  `uploaded_ip` VARCHAR(20) NOT NULL,
  `file_name_actual` VARCHAR(50) NOT NULL,
  `file_name_display` VARCHAR(128) NOT NULL,
  `original_name` VARCHAR(255) NOT NULL,
  `original_size` INT NOT NULL,
  `original_width` INT NOT NULL,
  `original_height` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `images_users_id_idx` (`uploaded_user_id` ASC),
  CONSTRAINT `images_users_id`
    FOREIGN KEY (`uploaded_user_id`)
    REFERENCES `_app`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`product_image_map`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`product_image_map` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`product_image_map` (
  `product_id` INT UNSIGNED NOT NULL,
  `image_id` INT UNSIGNED NOT NULL,
  `sort_order` INT UNSIGNED NOT NULL,
  INDEX `products_images_images_id_idx` (`image_id` ASC),
  INDEX `products_images_products_id_idx` (`product_id` ASC),
  PRIMARY KEY (`product_id`),
  CONSTRAINT `products_images_products_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `products_images_images_id`
    FOREIGN KEY (`image_id`)
    REFERENCES `_app`.`image` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`client_account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`client_account` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`client_account` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `flag_locked` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 = NOT LOCKED\n1 = LOCKED',
  `database_id` VARCHAR(9) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `database_id_UNIQUE` (`database_id` ASC))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`app_permission`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`app_permission` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`app_permission` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `key` VARCHAR(45) NOT NULL,
  `value` ENUM('0','1') NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  CONSTRAINT `users_permissions_users_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `_app`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`attribute_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`attribute_type` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`attribute_type` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL COMMENT 'PRE-DEFINED\nNUMERIC\nSHORT TEXT\nLONG TEXT\nY/N',
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Holds all the attribute types such as:\nPRE-DEFINED\nNUMERIC\nSHORT TEXT\nLONG TEXT\nY/N';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`attribute`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`attribute` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`attribute` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `attribute_type_id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(132) NOT NULL,
  `description` VARCHAR(255) NULL,
  `internal_label` VARCHAR(132) NULL,
  PRIMARY KEY (`id`),
  INDEX `attribute_attribute_type_id_idx` (`attribute_type_id` ASC),
  CONSTRAINT `attribute_attribute_type_id`
    FOREIGN KEY (`attribute_type_id`)
    REFERENCES `_common`.`attribute_type` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`attribute_numeric`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`attribute_numeric` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`attribute_numeric` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `attribute_id` INT UNSIGNED NOT NULL,
  `unit_short` VARCHAR(8) NULL,
  `unit_long` VARCHAR(32) NULL,
  `unit_long_plural` VARCHAR(32) NULL,
  `has_space` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'SPACE BETWEEN NUMBER AND \'UNIT_SHORT\' (IE: 10kg OR 20 MB).\n\n0 = NO SPACE\n1 = HAS SPACE',
  `has_decimals` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT '0 = DECIMALS NOT ALLOWED\n1 = DECIMALS ALLOWED',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `attribute_id_UNIQUE` (`attribute_id` ASC),
  CONSTRAINT `attribute_numeric_attribute_id`
    FOREIGN KEY (`attribute_id`)
    REFERENCES `_app`.`attribute` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`attribute_predefined`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`attribute_predefined` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`attribute_predefined` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `attribute_id` INT UNSIGNED NOT NULL,
  `value` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `attributes_predefined_attributes_id_idx` (`attribute_id` ASC),
  CONSTRAINT `attribute_predefined_attribute_id`
    FOREIGN KEY (`attribute_id`)
    REFERENCES `_app`.`attribute` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`product_attribute_map`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`product_attribute_map` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`product_attribute_map` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NOT NULL,
  `attribute_id` INT UNSIGNED NOT NULL,
  `value_numeric` DECIMAL(12,8) NULL,
  `value_predefined` INT NULL,
  `value_yn` TINYINT(1) UNSIGNED NULL COMMENT '0 = NO\n1 = YES',
  `value_short_text` VARCHAR(255) NULL,
  `value_long_text` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `products_attributes_products_id_idx` (`product_id` ASC),
  INDEX `products_attributes_attributes_id_idx` (`attribute_id` ASC),
  CONSTRAINT `product_attribute_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `product_attribute_attribute_id`
    FOREIGN KEY (`attribute_id`)
    REFERENCES `_app`.`attribute` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`user_password_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`user_password_history` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`user_password_history` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `changed_date` DATETIME NULL,
  `password` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `users_password_history_users_id_idx` (`user_id` ASC),
  CONSTRAINT `users_password_history_users_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `_app`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`product_msrp`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`product_msrp` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`product_msrp` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NOT NULL,
  `product_pricelist_id` INT UNSIGNED NOT NULL,
  `amount` DECIMAL(13,4) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`),
  INDEX `products_msrp_products_id_idx` (`product_id` ASC),
  INDEX `products_msrp_products_pricelists_id_idx` (`product_pricelist_id` ASC),
  CONSTRAINT `product_msrp_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `product_msrp_product_pricelist_id`
    FOREIGN KEY (`product_pricelist_id`)
    REFERENCES `_app`.`product_pricelist` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`shipping_method`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`shipping_method` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`shipping_method` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `private_name` VARCHAR(45) NULL,
  `private_description` VARCHAR(255) NULL,
  `public_name` VARCHAR(45) NOT NULL,
  `public_description` VARCHAR(255) NULL,
  `weight_unit_id` INT UNSIGNED NOT NULL,
  `weight_min` DECIMAL(10,4) UNSIGNED NOT NULL DEFAULT 0,
  `weight_max` DECIMAL(10,4) UNSIGNED NOT NULL DEFAULT 0,
  `dimensions_unit_id` INT UNSIGNED NOT NULL,
  `length_min` DECIMAL(10,4) UNSIGNED NOT NULL DEFAULT 0,
  `length_max` DECIMAL(10,4) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'LOWEST = SMALLEST/CHEAPEST PACKAGE\nHIGHEST = BIGGER SHIPMENTS',
  `items_min` INT NULL,
  `items_max` INT NULL,
  `sort_order` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `shipping_methods_weight_units_id_idx` (`weight_unit_id` ASC),
  INDEX `shipping_methods_dimensions_id_idx` (`dimensions_unit_id` ASC),
  CONSTRAINT `shipping_method_weight_unit_id`
    FOREIGN KEY (`weight_unit_id`)
    REFERENCES `_common`.`weight_unit` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `shipping_method_dimension_unit_id`
    FOREIGN KEY (`dimensions_unit_id`)
    REFERENCES `_common`.`dimension_unit` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`shipping_method_tier`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`shipping_method_tier` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`shipping_method_tier` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shipping_method_id` INT UNSIGNED NOT NULL,
  `ship_to_country_code` VARCHAR(2) NOT NULL,
  `ship_to_country_region_id` INT UNSIGNED NOT NULL,
  `delivery_days_min` INT UNSIGNED NOT NULL DEFAULT 0,
  `delivery_days_max` INT UNSIGNED NOT NULL DEFAULT 0,
  `delivery_description` VARCHAR(45) NULL,
  `weight_not_over` DECIMAL(10,4) NULL DEFAULT 0,
  `our_cost` DECIMAL(13,4) NULL DEFAULT 0,
  `our_charge` DECIMAL(13,4) NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `shipping_methods_tiers_shipping_methods_id_idx` (`shipping_method_id` ASC),
  CONSTRAINT `shipping_method_tier_shipping_method_id`
    FOREIGN KEY (`shipping_method_id`)
    REFERENCES `_app`.`shipping_method` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`product_shipping_method`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`product_shipping_method` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`product_shipping_method` (
  `product_id` INT UNSIGNED NOT NULL,
  `shipping_method_id` INT UNSIGNED NOT NULL,
  INDEX `products_shipping_methods_products_id_idx` (`product_id` ASC),
  INDEX `products_shipping_methods_shipping_methods_id_idx` (`shipping_method_id` ASC),
  PRIMARY KEY (`product_id`),
  CONSTRAINT `product_shipping_method_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `product_shipping_method_shipping_method_id`
    FOREIGN KEY (`shipping_method_id`)
    REFERENCES `_app`.`shipping_method` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`product_variation_map`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`product_variation_map` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`product_variation_map` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NOT NULL COMMENT 'MASTER PRODUCT (NOT STOCK TRACKED, ONLY CARRIES DESCRIPTION)',
  `variation_product_id` INT UNSIGNED NOT NULL COMMENT 'VARIATION PRODUCT',
  PRIMARY KEY (`id`),
  INDEX `products_variations_products_id_idx` (`product_id` ASC),
  INDEX `products_variations_master_products_id_idx` (`variation_product_id` ASC),
  CONSTRAINT `products_variations_products_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `products_variations_variation_products_id`
    FOREIGN KEY (`variation_product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`goods_movement_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`goods_movement_type` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`goods_movement_type` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`goods_movement`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`goods_movement` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`goods_movement` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NOT NULL,
  `goods_movement_type_id` INT UNSIGNED NOT NULL,
  `from_warehouse_id` INT UNSIGNED NULL,
  `to_warehouse_id` INT UNSIGNED NULL COMMENT 'ONLY USE THIS FIELD IF THE MOVEMENT IS FROM ONE WAREHOUSE TO ANOTHER,\nOTHERWISE LEAVE BLANK ',
  PRIMARY KEY (`id`),
  INDEX `goods_movement_products_id_idx` (`product_id` ASC),
  INDEX `goods_movements_goods_movements_types_id_idx` (`goods_movement_type_id` ASC),
  CONSTRAINT `goods_movements_products_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `goods_movements_goods_movements_types_id`
    FOREIGN KEY (`goods_movement_type_id`)
    REFERENCES `_app`.`goods_movement_type` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`app_state`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`app_state` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`app_state` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `key` VARCHAR(45) NOT NULL,
  `value` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  INDEX `app_config_users_id_idx` (`user_id` ASC),
  INDEX `app_config_key` (`key` ASC),
  CONSTRAINT `app_config_users_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `_app`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`shipping_method_warehouse`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`shipping_method_warehouse` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`shipping_method_warehouse` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shipping_method_id` INT UNSIGNED NOT NULL,
  `warehouse_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `shipping_method_warehouse_shipping_warehouse_id_idx` (`warehouse_id` ASC),
  INDEX `shipping_method_warehouse_shipping_method_id_idx` (`shipping_method_id` ASC),
  CONSTRAINT `shipping_method_warehouse_shipping_method_id`
    FOREIGN KEY (`shipping_method_id`)
    REFERENCES `_app`.`shipping_method` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `shipping_method_warehouse_shipping_warehouse_id`
    FOREIGN KEY (`warehouse_id`)
    REFERENCES `_app`.`warehouse` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`order_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`order_type` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`order_type` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = 'Holds all the different order types:\nEBAY\nAMAZON\nSHOPIFY';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`country` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`country` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `currency_id` INT UNSIGNED NOT NULL,
  `iso_alpha_2` VARCHAR(2) NOT NULL,
  `iso_alpha_3` VARCHAR(3) NOT NULL,
  `iso_numeric` VARCHAR(3) NULL,
  `dialling_code` VARCHAR(8) NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `2_digit_country_codes` (`iso_alpha_2` ASC),
  UNIQUE INDEX `3_digit_country_codes` (`iso_alpha_3` ASC),
  INDEX `countries_currencies_code_idx` (`currency_id` ASC),
  UNIQUE INDEX `iso_numeric_UNIQUE` (`iso_numeric` ASC),
  CONSTRAINT `country_currency_id`
    FOREIGN KEY (`currency_id`)
    REFERENCES `_common`.`currency` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`address` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`address` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `description` TEXT NULL,
  `address_1` VARCHAR(150) NOT NULL,
  `address_2` VARCHAR(150) NULL,
  `address_3` VARCHAR(150) NULL,
  `town` VARCHAR(75) NULL,
  `county` VARCHAR(75) NULL,
  `post_code` VARCHAR(15) NULL,
  `country_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `address_country_id_idx` (`country_id` ASC),
  CONSTRAINT `address_country_id`
    FOREIGN KEY (`country_id`)
    REFERENCES `_common`.`country` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`order` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`order` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_no` VARCHAR(15) NOT NULL,
  `order_type_id` INT UNSIGNED NOT NULL,
  `created_date` DATETIME NOT NULL,
  `modified_date` DATETIME NOT NULL,
  `paid_date` DATETIME NULL,
  `shipped_date` DATETIME NULL,
  `shipped_user` INT UNSIGNED NULL,
  `refund_date` DATETIME NULL,
  `refund_user` INT UNSIGNED NULL,
  `return_received_date` DATETIME NULL,
  `return_received_user` INT UNSIGNED NULL,
  `contact_id` INT UNSIGNED NULL,
  `shipping_method_id` INT UNSIGNED NOT NULL,
  `shipping_address_id` INT UNSIGNED NULL,
  `warehouse_id` INT UNSIGNED NOT NULL,
  `note` TEXT NULL COMMENT 'CUSTOMER NOTE',
  PRIMARY KEY (`id`),
  INDEX `order_order_type_id_idx` (`order_type_id` ASC),
  INDEX `order_shipped_user_id_idx` (`shipped_user` ASC),
  INDEX `order_refund_user_id_idx` (`refund_user` ASC),
  INDEX `order_return_received_user_id_idx` (`return_received_user` ASC),
  INDEX `order_shipping_method_id_idx` (`shipping_method_id` ASC),
  INDEX `order_shipping_address_id_idx` (`shipping_address_id` ASC),
  INDEX `order_contact_id_idx` (`contact_id` ASC),
  INDEX `order_warehouse_id_idx` (`warehouse_id` ASC),
  CONSTRAINT `order_order_type_id`
    FOREIGN KEY (`order_type_id`)
    REFERENCES `_common`.`order_type` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_shipped_user_id`
    FOREIGN KEY (`shipped_user`)
    REFERENCES `_app`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_refund_user_id`
    FOREIGN KEY (`refund_user`)
    REFERENCES `_app`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_return_received_user_id`
    FOREIGN KEY (`return_received_user`)
    REFERENCES `_app`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_shipping_method_id`
    FOREIGN KEY (`shipping_method_id`)
    REFERENCES `_app`.`shipping_method` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_shipping_address_id`
    FOREIGN KEY (`shipping_address_id`)
    REFERENCES `_app`.`address` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_contact_id`
    FOREIGN KEY (`contact_id`)
    REFERENCES `_app`.`contact` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_warehouse_id`
    FOREIGN KEY (`warehouse_id`)
    REFERENCES `_app`.`warehouse` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`ebay_order_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`ebay_order_status` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`ebay_order_status` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) BINARY NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`ebay_payment_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`ebay_payment_status` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`ebay_payment_status` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`ebay_site`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`ebay_site` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`ebay_site` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `site_id` INT UNSIGNED NOT NULL COMMENT 'siteID',
  `site_name` VARCHAR(45) NOT NULL COMMENT 'site',
  `modified_date` DATETIME NOT NULL COMMENT 'updateTime[]',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`ebay_shipping_service`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`ebay_shipping_service` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`ebay_shipping_service` (
  `id` INT UNSIGNED NOT NULL,
  `ebay_site_id` INT UNSIGNED NOT NULL,
  `service_id` INT UNSIGNED NOT NULL COMMENT 'shippingServiceID',
  `service_name` VARCHAR(45) NOT NULL COMMENT 'shippingService',
  `service_description` VARCHAR(150) NOT NULL COMMENT 'description',
  `shipping_time_min` INT NOT NULL COMMENT 'shippingTimeMin',
  `shipping_time_max` INT NOT NULL COMMENT 'shippingTimeMax',
  `shipping_category` VARCHAR(45) NOT NULL COMMENT 'shippingCategory',
  `valid_for_selling_flow` ENUM('0','1') NOT NULL DEFAULT '0' COMMENT 'validForSellingFlow\n\nIf this field is returned as \'true\', the shipping service option can be used in a Add/Revise/Relist API call. If this field is returned as \'false\', the shipping service option is not currently supported and cannot be used in a Add/Revise/Relist API call.',
  `expedited_service` ENUM('0','1') NOT NULL DEFAULT '0' COMMENT 'expeditedService\n\nIndicates whether the shipping service is an expedited shipping service. See Enabling Get It Fast. Only returned for sites for which the Get It Fast feature is enabled and only if true.',
  `modified_date` DATETIME NOT NULL COMMENT 'updateTime[]',
  PRIMARY KEY (`id`),
  INDEX `ebay_shipping_service_ebay_site_id_idx` (`ebay_site_id` ASC),
  CONSTRAINT `ebay_shipping_service_ebay_site_id`
    FOREIGN KEY (`ebay_site_id`)
    REFERENCES `_common`.`ebay_site` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`order_ebay`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`order_ebay` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`order_ebay` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` INT UNSIGNED NULL COMMENT 'OrderArray.Order.OrderID',
  `order_status_id` INT UNSIGNED NULL COMMENT 'OrderArray.Order.OrderStatus',
  `payment_status_id` INT UNSIGNED NULL COMMENT 'OrderArray.Order.CheckoutStatus.eBayPaymentStatus',
  `shipping_service_id` INT UNSIGNED NULL,
  `shipping_service_amount` DECIMAL(13,4) NULL,
  `shipping_service_currency` INT UNSIGNED NULL,
  `order_ebaycol` VARCHAR(45) NULL,
  `raw_json` TEXT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `order_ebay_order_id_idx` (`order_id` ASC),
  INDEX `order_ebay_ebay_order_status_id_idx` (`order_status_id` ASC),
  INDEX `order_ebay_ebay_payment_status_id_idx` (`payment_status_id` ASC),
  INDEX `order_ebay_shipping_service_id_idx` (`shipping_service_id` ASC),
  INDEX `order_ebay_shipping_service_currency_id_idx` (`shipping_service_currency` ASC),
  CONSTRAINT `order_ebay_order_id`
    FOREIGN KEY (`order_id`)
    REFERENCES `_app`.`order` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `order_ebay_ebay_order_status_id`
    FOREIGN KEY (`order_status_id`)
    REFERENCES `_common`.`ebay_order_status` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_ebay_ebay_payment_status_id`
    FOREIGN KEY (`payment_status_id`)
    REFERENCES `_common`.`ebay_payment_status` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_ebay_shipping_service_id`
    FOREIGN KEY (`shipping_service_id`)
    REFERENCES `_common`.`ebay_shipping_service` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_ebay_shipping_service_currency_id`
    FOREIGN KEY (`shipping_service_currency`)
    REFERENCES `_common`.`currency` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`contact_customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`contact_customer` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`contact_customer` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `contact_id` INT UNSIGNED NOT NULL,
  `customer_no` VARCHAR(15) NOT NULL,
  INDEX `contact_customer_contact_id_idx` (`contact_id` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `contact_customer_contact_id`
    FOREIGN KEY (`contact_id`)
    REFERENCES `_app`.`contact` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`country_phone_prefix`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`country_phone_prefix` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`country_phone_prefix` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `country_id` INT UNSIGNED NOT NULL,
  `prefix` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `country_phone_prefix_country_ud_idx` (`country_id` ASC),
  CONSTRAINT `country_phone_prefix_country_ud`
    FOREIGN KEY (`country_id`)
    REFERENCES `_common`.`country` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Phone prefixes, IE: +44, +1';

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`phone_number`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`phone_number` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`phone_number` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `description` TEXT NULL,
  `country_phone_prefix_id` INT UNSIGNED NOT NULL,
  `phone_number` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `phone_number_country_phone_prefix_id_idx` (`country_phone_prefix_id` ASC),
  CONSTRAINT `phone_number_country_phone_prefix_id`
    FOREIGN KEY (`country_phone_prefix_id`)
    REFERENCES `_common`.`country_phone_prefix` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`contact_phone_number`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`contact_phone_number` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`contact_phone_number` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `contact_id` INT UNSIGNED NOT NULL,
  `phone_number_id` INT UNSIGNED NOT NULL,
  INDEX `contact_phone_number_phone_number_id_idx` (`phone_number_id` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `contact_phone_number_contact_id`
    FOREIGN KEY (`contact_id`)
    REFERENCES `_app`.`contact` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `contact_phone_number_phone_number_id`
    FOREIGN KEY (`phone_number_id`)
    REFERENCES `_app`.`phone_number` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`contact_address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`contact_address` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`contact_address` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `contact_id` INT UNSIGNED NOT NULL,
  `address_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `contact_address_address_id_idx` (`address_id` ASC),
  CONSTRAINT `contact_address_contact_id`
    FOREIGN KEY (`contact_id`)
    REFERENCES `_app`.`contact` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `contact_address_address_id`
    FOREIGN KEY (`address_id`)
    REFERENCES `_app`.`address` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`email`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`email` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`email` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `description` TEXT NULL,
  `email` TEXT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`contact_email`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`contact_email` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`contact_email` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `contact_id` INT UNSIGNED NOT NULL,
  `email_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `contact_email_email_id_idx` (`email_id` ASC),
  CONSTRAINT `contact_email_contact_id`
    FOREIGN KEY (`contact_id`)
    REFERENCES `_app`.`contact` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `contact_email_email_id`
    FOREIGN KEY (`email_id`)
    REFERENCES `_app`.`email` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`note`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`note` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`note` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `locked` ENUM('0','1') NOT NULL DEFAULT '0' COMMENT '0 = NOT LOCKED\n1 = LOCKED\n\nLOCKED MEANS ONLY USER WHO CREATED NOTE CAN EDIT/DELETE',
  `deleted` ENUM('0','1') NOT NULL DEFAULT '0' COMMENT '0 = NOT DELETED\n1 = DELETED\n\nKEEP NOTES EVEN IF DELETED, JUST IN CASE.',
  `created_date` DATETIME NOT NULL,
  `created_user` INT UNSIGNED NOT NULL,
  `modified_date` DATETIME NOT NULL,
  `modified_user` INT UNSIGNED NOT NULL,
  `body` TEXT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `note_user_id_idx` (`created_user` ASC),
  INDEX `note_modified_user_id_idx` (`modified_user` ASC),
  CONSTRAINT `note_created_user_id`
    FOREIGN KEY (`created_user`)
    REFERENCES `_app`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `note_modified_user_id`
    FOREIGN KEY (`modified_user`)
    REFERENCES `_app`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`contact_note`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`contact_note` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`contact_note` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `contact_id` INT UNSIGNED NOT NULL,
  `note_id` INT UNSIGNED NOT NULL,
  INDEX `contact_note_note_id_idx` (`note_id` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `contact_note_contact_id`
    FOREIGN KEY (`contact_id`)
    REFERENCES `_app`.`contact` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `contact_note_note_id`
    FOREIGN KEY (`note_id`)
    REFERENCES `_app`.`note` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`note_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`note_history` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`note_history` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `note_id` INT UNSIGNED NOT NULL,
  `modified_date` DATETIME NOT NULL COMMENT 'REMEMBER:\nMUST COPY THE MODIFIED DATE FROM NOTE TABLE, NOT!! USE TIMESTAMP OF UPDATE MOMENT.',
  `modified_user` INT UNSIGNED NOT NULL,
  `body` TEXT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `note_history_note_id_idx` (`note_id` ASC),
  INDEX `note_history_user_id_idx` (`modified_user` ASC),
  CONSTRAINT `note_history_note_id`
    FOREIGN KEY (`note_id`)
    REFERENCES `_app`.`note` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `note_history_user_id`
    FOREIGN KEY (`modified_user`)
    REFERENCES `_app`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`contact_ebay`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`contact_ebay` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`contact_ebay` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `contact_id` INT UNSIGNED NOT NULL,
  `user_id` VARCHAR(90) NULL,
  `eias_token` VARCHAR(150) NULL COMMENT 'Unique identifier for the user that does not change when the eBay user name is changed. Use when an application needs to associate a new eBay user name with the corresponding eBay user.',
  PRIMARY KEY (`id`),
  INDEX `contact_ebay_contact_id_idx` (`contact_id` ASC),
  CONSTRAINT `contact_ebay_contact_id`
    FOREIGN KEY (`contact_id`)
    REFERENCES `_app`.`contact` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`order_ebay_transaction`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`order_ebay_transaction` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`order_ebay_transaction` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_ebay_id` INT UNSIGNED NOT NULL,
  `created_date` DATETIME NOT NULL,
  `site` VARCHAR(45) NOT NULL,
  `selling_manager_record_number` INT NULL COMMENT 'sellingManagerSalesRecordNumber\n\nThe sale record ID. Applicable to Selling Manager users. When an item is sold, Selling Manager generates a sale record. A sale record contains buyer information, shipping, and other information. A sale record is displayed in the Sold view in Selling Manager. Each sale record has a sale record ID. In the following calls, the value for the sale record ID is in the SellingManagerSalesRecordNumber field: GetItemTransactions, GetSellerTransactions, GetOrders, GetOrderTransactions. In the Selling Manager calls, the value for the sale record ID is in the SaleRecordID field. The sale record ID can be for a single or a multiple line item order.',
  `transaction_id` VARCHAR(45) NOT NULL,
  `transaction_site_id` VARCHAR(45) NOT NULL COMMENT 'SITE IT FOR TRANSACTION\ntransactionArray.transaction.transactionSiteId',
  `item_id` VARCHAR(20) NOT NULL COMMENT 'itemID',
  `item_site_id` VARCHAR(45) NOT NULL COMMENT 'SITE IT FOR ITEM\ntransactionArray.transaction.item.site',
  `item_title` VARCHAR(250) NOT NULL,
  `item_sku` VARCHAR(90) NULL,
  `item_condition` VARCHAR(45) NULL,
  `quantity` INT NOT NULL,
  `amount` DECIMAL(13,4) NOT NULL,
  `fvf_amount` DECIMAL(13,4) NOT NULL,
  `fvf_currency_id` INT UNSIGNED NOT NULL,
  `payment_hold_status` VARCHAR(90) NULL,
  `variation_title` VARCHAR(250) NULL,
  `variation_specifics` TEXT NULL COMMENT 'JSON ENCODED STRING OF ALL THE VARIATION DETAILS. THESE COULD BE ANYTHING.',
  PRIMARY KEY (`id`),
  INDEX `order_ebay_transaction_order_ebay_id_idx` (`order_ebay_id` ASC),
  INDEX `order_ebay_transaction_fvf_currency_id_idx` (`fvf_currency_id` ASC),
  CONSTRAINT `order_ebay_transaction_order_ebay_id`
    FOREIGN KEY (`order_ebay_id`)
    REFERENCES `_app`.`order_ebay` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_ebay_transaction_fvf_currency_id`
    FOREIGN KEY (`fvf_currency_id`)
    REFERENCES `_common`.`currency` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`order_ebay_transaction_external`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`order_ebay_transaction_external` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`order_ebay_transaction_external` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_ebay_id` INT UNSIGNED NOT NULL,
  `created_date` DATETIME NOT NULL,
  `transaction_id` VARCHAR(45) NOT NULL COMMENT 'OrderArray.Order.ExternalTransaction.ExternalTransactionID\n\nUnique identifier for a PayPal payment of an eBay order. If the order was purchased with a payment method other than PayPal, \"SIS\" is returned, which stands for \"Send Information To Seller.\" This field is only returned after payment has been made.',
  `fee_amount` DECIMAL(13,4) NOT NULL COMMENT 'Fee Amount is a positive value and Credit Amount is a negative value.',
  `fee_amount_currency_id` INT UNSIGNED NOT NULL,
  `payment_amount` DECIMAL(13,4) NOT NULL COMMENT 'If positive, the amount the buyer pays the seller through PayPal on the purchase of items. If negative, the amount refunded the buyer. Default = 0.',
  `payment_amount_currency_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `order_ebay_transaction_external_order_ebay_id_idx` (`order_ebay_id` ASC),
  INDEX `order_ebay_transaction_external_fee_amount_currency_id_idx` (`fee_amount_currency_id` ASC),
  INDEX `order_ebay_transaction_external_payment_amount_currency_id_idx` (`payment_amount_currency_id` ASC),
  CONSTRAINT `order_ebay_transaction_external_order_ebay_id`
    FOREIGN KEY (`order_ebay_id`)
    REFERENCES `_app`.`order_ebay` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_ebay_transaction_external_fee_amount_currency_id`
    FOREIGN KEY (`fee_amount_currency_id`)
    REFERENCES `_common`.`currency` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_ebay_transaction_external_payment_amount_currency_id`
    FOREIGN KEY (`payment_amount_currency_id`)
    REFERENCES `_common`.`currency` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`ebay_payment_method`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`ebay_payment_method` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`ebay_payment_method` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`order_ebay_payment_methods`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`order_ebay_payment_methods` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`order_ebay_payment_methods` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_ebay_id` INT UNSIGNED NOT NULL,
  `payment_method_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `order_ebay_payment_methods_order_ebay_idx` (`order_ebay_id` ASC),
  INDEX `order_ebay_payment_methods_payment_method_id_idx` (`payment_method_id` ASC),
  CONSTRAINT `order_ebay_payment_methods_order_ebay_id`
    FOREIGN KEY (`order_ebay_id`)
    REFERENCES `_app`.`order_ebay` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_ebay_payment_methods_payment_method_id`
    FOREIGN KEY (`payment_method_id`)
    REFERENCES `_common`.`ebay_payment_method` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`attribute_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`attribute_group` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`attribute_group` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `private_name` VARCHAR(45) NULL,
  `private_description` VARCHAR(255) NULL,
  `public_name` VARCHAR(45) NOT NULL,
  `public_description` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`attribute_group_map`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`attribute_group_map` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`attribute_group_map` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `attribute_id` INT UNSIGNED NOT NULL,
  `attribute_group_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `attribute_group_attribute_id_idx` (`attribute_id` ASC),
  INDEX `attribute_group_attribute_group_id_idx` (`attribute_group_id` ASC),
  CONSTRAINT `attribute_group_attribute_id`
    FOREIGN KEY (`attribute_id`)
    REFERENCES `_app`.`attribute` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `attribute_group_attribute_group_id`
    FOREIGN KEY (`attribute_group_id`)
    REFERENCES `_app`.`attribute_group` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`order_ebay_feedback`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`order_ebay_feedback` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`order_ebay_feedback` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ebay_order_id` INT UNSIGNED NOT NULL,
  `feedback_id` VARCHAR(20) NOT NULL,
  `feedbacK_date` DATETIME NOT NULL,
  `feedback_score` VARCHAR(10) NOT NULL,
  `feedback_type` VARCHAR(15) NOT NULL,
  `feedback_text` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `order_ebay_feedback_order_ebay_id_idx` (`ebay_order_id` ASC),
  CONSTRAINT `order_ebay_feedback_order_ebay_id`
    FOREIGN KEY (`ebay_order_id`)
    REFERENCES `_app`.`order_ebay` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`order_totals`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`order_totals` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`order_totals` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` INT UNSIGNED NOT NULL,
  `contact_id` INT UNSIGNED NOT NULL,
  `currency_id` INT UNSIGNED NOT NULL,
  `refund_amount` DECIMAL(13,4) NOT NULL DEFAULT 0.00 COMMENT 'THE AMOUNT REFUNDED.',
  `cost_stock` DECIMAL(13,4) NOT NULL DEFAULT 0.00 COMMENT 'COST OF STOCK (IMPORT + DUTY + VAT)',
  `cost_shipping` DECIMAL(13,4) NOT NULL DEFAULT 0.00 COMMENT 'COST OF SHIPPING TO CUSTOMER.',
  `cost_fees` DECIMAL(13,4) NOT NULL DEFAULT 0.00 COMMENT 'COST OF ONLINE FEES (PAYPAL, EBAY, ETC).',
  `cost_tax_liability` DECIMAL(13,4) NOT NULL DEFAULT 0.00 COMMENT 'COST OF (POSSIBLE) TAX LIABILITY.',
  `cost_extra` DECIMAL(13,4) NOT NULL DEFAULT 0.00 COMMENT 'ANY EXTRA COSTS (USUALLY SAVINGS BY CUSTOMER).',
  `cost_total` DECIMAL(13,4) NOT NULL DEFAULT 0.00 COMMENT 'THE TOTAL COST.',
  `spend_product` DECIMAL(13,4) NOT NULL DEFAULT 0.00 COMMENT 'AMOUNT SPENT ON PRODUCTS/SERVICES.',
  `spend_extra` DECIMAL(13,4) NOT NULL DEFAULT 0.00 COMMENT 'ANY EXTRA AMOUNT SPENT BY CUSTOMER.',
  `spend_total` DECIMAL(13,4) NOT NULL DEFAULT 0.00 COMMENT 'THE TOTAL SPENT BY CUSTOMER.',
  `profit_total` DECIMAL(13,4) NOT NULL DEFAULT 0.00 COMMENT 'TOTAL PROFIT (IF ANY).',
  PRIMARY KEY (`id`),
  INDEX `order_totals_order_id_idx` (`order_id` ASC),
  INDEX `order_totals_contact_id_idx` (`contact_id` ASC),
  INDEX `order_totals_currency_id_idx` (`currency_id` ASC),
  CONSTRAINT `order_totals_order_id`
    FOREIGN KEY (`order_id`)
    REFERENCES `_app`.`order` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_totals_contact_id`
    FOREIGN KEY (`contact_id`)
    REFERENCES `_app`.`contact` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_totals_currency_id`
    FOREIGN KEY (`currency_id`)
    REFERENCES `_common`.`currency` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`order_product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`order_product` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`order_product` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` INT UNSIGNED NOT NULL,
  `product_id` INT UNSIGNED NULL,
  `product_sku` VARCHAR(64) NULL COMMENT 'The SKU from eBay (etc.), not our internal SKU.',
  `product_title` VARCHAR(255) NULL COMMENT 'The Title from eBay (etc.), not our internal Title.',
  `quantity` INT NULL,
  `unit_price` DECIMAL(13,4) NULL,
  `total_price` DECIMAL(13,4) NULL,
  `stock_left` INT NOT NULL COMMENT 'The amount of stock left AFTER this sale. If 0 or less, item must be marked as OUT-OF-STOCK on order page, although in theory this should never happen.',
  `stock_tracked` ENUM('0','1') NOT NULL COMMENT 'STOCK TRACK STATUS AT TIME OF SALE.\n0 = NOT STOCK TRACKED\n1 = STOCK TRACKED',
  PRIMARY KEY (`id`),
  INDEX `order_product_order_id_idx` (`order_id` ASC),
  INDEX `order_product_product_id_idx` (`product_id` ASC),
  CONSTRAINT `order_product_order_id`
    FOREIGN KEY (`order_id`)
    REFERENCES `_app`.`order` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `order_product_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `_app`.`product` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_app`.`cron`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_app`.`cron` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_app`.`cron` (
  `id` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;
USE `_common` ;

-- -----------------------------------------------------
-- Table `_common`.`currency_exchange_rate`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`currency_exchange_rate` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`currency_exchange_rate` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(3) NOT NULL,
  `toGBP` DECIMAL(5,5) UNSIGNED ZEROFILL NOT NULL,
  `toUSD` DECIMAL(5,5) UNSIGNED ZEROFILL NOT NULL,
  `toEUR` DECIMAL(5,5) UNSIGNED ZEROFILL NOT NULL,
  `toCAD` DECIMAL(5,5) UNSIGNED ZEROFILL NOT NULL,
  `toAUD` DECIMAL(5,5) UNSIGNED ZEROFILL NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `currency_exchange_rate_currency_id`
    FOREIGN KEY (`id`)
    REFERENCES `_common`.`currency` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`region`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`region` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`region` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `country_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `regions_countries_id_idx` (`country_id` ASC),
  CONSTRAINT `regions_country_id`
    FOREIGN KEY (`country_id`)
    REFERENCES `_common`.`country` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`region_postcode_uk`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`region_postcode_uk` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`region_postcode_uk` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `country_id` INT UNSIGNED NOT NULL,
  `region_id` INT UNSIGNED NOT NULL,
  `prefix` VARCHAR(2) NOT NULL,
  `prefix_from` INT NOT NULL,
  `prefix_to` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `regions_postcodes_uk_regions_id_idx` (`region_id` ASC),
  INDEX `regions_postcodes_uk_countries_2_digit_code_idx` (`country_id` ASC),
  CONSTRAINT `region_postcode_uk_region_id`
    FOREIGN KEY (`region_id`)
    REFERENCES `_common`.`region` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `region_postcode_uk_country_id`
    FOREIGN KEY (`country_id`)
    REFERENCES `_common`.`country` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`uk_county`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`uk_county` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`uk_county` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `county_name` VARCHAR(45) NOT NULL,
  `county_region` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_common`.`ebay_cancel_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_common`.`ebay_cancel_status` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_common`.`ebay_cancel_status` (
  `id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;
USE `_client_config` ;

-- -----------------------------------------------------
-- Table `_client_config`.`data_center`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_client_config`.`data_center` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_client_config`.`data_center` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `host` TEXT NOT NULL,
  `username` TEXT NOT NULL,
  `password` TEXT NOT NULL,
  `port` TEXT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_client_config`.`payment_plan`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_client_config`.`payment_plan` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_client_config`.`payment_plan` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `_client_config`.`client`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `_client_config`.`client` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `_client_config`.`client` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `data_center_id` INT UNSIGNED NOT NULL,
  `payment_plan_id` INT UNSIGNED NOT NULL,
  `locked` ENUM('0','1') NOT NULL DEFAULT '0' COMMENT '0 = LOCKED\n1 = NOT LOCKED',
  `db_name` VARCHAR(45) NOT NULL,
  `client_name` VARCHAR(64) NOT NULL COMMENT 'NAME FOR INTERNAL USE. ALPHANUMERIC, LOWERCASE, NO SPACES.',
  `client_name_display` VARCHAR(64) NOT NULL COMMENT 'NAME FOR DISPLAY',
  PRIMARY KEY (`id`),
  INDEX `client_data_center_id_idx` (`data_center_id` ASC),
  INDEX `client_payment_plan_id_idx` (`payment_plan_id` ASC),
  CONSTRAINT `client_data_center_id`
    FOREIGN KEY (`data_center_id`)
    REFERENCES `_client_config`.`data_center` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `client_payment_plan_id`
    FOREIGN KEY (`payment_plan_id`)
    REFERENCES `_client_config`.`payment_plan` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
SET SQL_MODE = '';
GRANT USAGE ON *.* TO root;
 DROP USER root;
SET SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';
SHOW WARNINGS;
CREATE USER 'root' IDENTIFIED BY 'lkqhacyp52';

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
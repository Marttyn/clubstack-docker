-- MySQL Script generated by MySQL Workbench
-- Thu Mar 30 17:28:23 2023
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema clubstack
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `clubstack` ;

-- -----------------------------------------------------
-- Schema clubstack
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `clubstack` DEFAULT CHARACTER SET utf8mb3 ;
USE `clubstack` ;

-- -----------------------------------------------------
-- Table `clubstack`.`order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clubstack`.`order` ;

CREATE TABLE IF NOT EXISTS `clubstack`.`order` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 21
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `clubstack`.`product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clubstack`.`product` ;

CREATE TABLE IF NOT EXISTS `clubstack`.`product` (
  `id` BINARY(16) NOT NULL DEFAULT uuid_to_bin(uuid(),true),
  `stock_available` INT NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `clubstack`.`order_has_product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clubstack`.`order_has_product` ;

CREATE TABLE IF NOT EXISTS `clubstack`.`order_has_product` (
  `order_id` INT NOT NULL,
  `product_id` BINARY(16) NOT NULL,
  `quantity` INT NOT NULL DEFAULT '1',
  PRIMARY KEY (`order_id`, `product_id`),
  INDEX `fk_order_has_product_product_idx` (`product_id` ASC) VISIBLE,
  INDEX `fk_order_has_product_order_idx` (`order_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_has_product_order`
    FOREIGN KEY (`order_id`)
    REFERENCES `clubstack`.`order` (`id`),
  CONSTRAINT `fk_order_has_product_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `clubstack`.`product` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

USE `clubstack` ;

-- -----------------------------------------------------
-- Placeholder table for view `clubstack`.`product_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `clubstack`.`product_details` (`Product ID` INT, `Stock Available` INT, `Present in how many orders` INT, `Quantity Ordered` INT, `Products sold` INT, `Average Quantity Ordered` INT, `Average Quantity Purchased` INT);

-- -----------------------------------------------------
-- procedure add_random_stock_to_all_products
-- -----------------------------------------------------

USE `clubstack`;
DROP procedure IF EXISTS `clubstack`.`add_random_stock_to_all_products`;

DELIMITER $$
USE `clubstack`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_random_stock_to_all_products`()
BEGIN
	-- Disable safe update
    SET SQL_SAFE_UPDATES = 0;

	-- Generate a random number between 1 and 100
    SET @random_stock  = floor(rand() * 100 + 1 );

    -- Update all products stock with the random number
	UPDATE product
	SET 
		stock_available = stock_available + @random_stock;
        
	-- Enable safe update
    SET SQL_SAFE_UPDATES = 1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure add_random_stock_to_product
-- -----------------------------------------------------

USE `clubstack`;
DROP procedure IF EXISTS `clubstack`.`add_random_stock_to_product`;

DELIMITER $$
USE `clubstack`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_random_stock_to_product`(
	IN product_id VARCHAR(36)
)
BEGIN
	-- Generate a random number between 1 and 100
	SET @random_stock  = floor(rand() * 100 + 1 );

	-- Update the product's stock with the random number
	UPDATE product
	SET 
		stock_available = stock_available + @random_stock
	WHERE
		id = UUID_TO_BIN(product_id);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure populate_order
-- -----------------------------------------------------

USE `clubstack`;
DROP procedure IF EXISTS `clubstack`.`populate_order`;

DELIMITER $$
USE `clubstack`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `populate_order`()
BEGIN
	DECLARE i INT;
    DECLARE numRows INT;
    
	SET i = 1;
	SET numRows = 20;
    
    START TRANSACTION;
    WHILE i <= numRows DO
		INSERT INTO `order` (`date`)
		SELECT
		  DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY) AS `date`;
		
		SET i = i + 1;
    END WHILE;
    COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure populate_order_has_product
-- -----------------------------------------------------

USE `clubstack`;
DROP procedure IF EXISTS `clubstack`.`populate_order_has_product`;

DELIMITER $$
USE `clubstack`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `populate_order_has_product`()
BEGIN
	DECLARE i INT;
    DECLARE numRows INT;
    DECLARE duplicateEntry BOOLEAN DEFAULT FALSE;
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE cur_order_id INT;
    DECLARE cur CURSOR FOR SELECT id FROM `order`;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done := TRUE;
    DECLARE CONTINUE HANDLER FOR 1062 SET duplicateEntry := TRUE;
    
    OPEN cur;
    orderLoop: LOOP
		FETCH cur INTO cur_order_id;
        
        IF done THEN
			LEAVE orderLoop;
		END IF;
        
        SET i = 1;
		SET numRows = FLOOR(RAND() * 3 + 1);
        
		WHILE i <= numRows DO    
			INSERT INTO order_has_product (order_id, product_id, quantity)
			SELECT
				cur_order_id AS order_id,
				(SELECT id FROM product ORDER BY RAND() LIMIT 1) AS product_id,
				FLOOR(RAND() * 50 + 1) AS quantity;
			
            IF duplicateEntry = FALSE THEN
				SET i = i + 1;
			END IF;
            SET duplicateEntry := FALSE;
		END WHILE;
        
	END LOOP orderLoop;
    CLOSE cur;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure populate_product
-- -----------------------------------------------------

USE `clubstack`;
DROP procedure IF EXISTS `clubstack`.`populate_product`;

DELIMITER $$
USE `clubstack`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `populate_product`()
BEGIN
	DECLARE i INT;
    DECLARE numRows INT;
    
    SET i = 1;
    SET numRows = 10;
    
    START TRANSACTION;
    WHILE i <= numRows DO
		INSERT INTO product (id, stock_available)
		SELECT
			UUID_TO_BIN(UUID(), TRUE),
			FLOOR(RAND() * 100 + 1) as stock_available;
		
		SET i = i + 1;
	END WHILE;
    COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure populate_product_order
-- -----------------------------------------------------

USE `clubstack`;
DROP procedure IF EXISTS `clubstack`.`populate_product_order`;

DELIMITER $$
USE `clubstack`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `populate_product_order`()
BEGIN
	-- Insert 10 products with random stock_available (at most 100)
    CALL populate_product();
    
	-- Insert 20 orders with random arrival date (today + at most 30 days)
    CALL populate_order();
    
    -- Insert at most 3 products with random quantities (at most 50) for each order
    CALL populate_order_has_product();
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `clubstack`.`product_details`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clubstack`.`product_details`;
DROP VIEW IF EXISTS `clubstack`.`product_details` ;
USE `clubstack`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `clubstack`.`product_details` AS select bin_to_uuid(`p`.`id`) AS `Product ID`,`p`.`stock_available` AS `Stock Available`,count(distinct `o`.`id`) AS `Present in how many orders`,sum(`op`.`quantity`) AS `Quantity Ordered`,(sum(`op`.`quantity`) - `p`.`stock_available`) AS `Products sold`,`avg_product_order_counts`.`avg_quantity_ordered` AS `Average Quantity Ordered`,`avg_product_order_counts`.`avg_quantity_purchased` AS `Average Quantity Purchased` from (((`clubstack`.`product` `p` join `clubstack`.`order_has_product` `op` on((`p`.`id` = `op`.`product_id`))) join `clubstack`.`order` `o` on((`op`.`order_id` = `o`.`id`))) left join (select `op`.`product_id` AS `product_id`,`op`.`order_id` AS `order_id`,count(distinct `op`.`order_id`) AS `num_orders`,avg(`op`.`quantity`) AS `avg_quantity_purchased`,avg((`op`.`quantity` / (select count(`clubstack`.`order`.`id`) from `clubstack`.`order`))) AS `avg_quantity_ordered` from (`clubstack`.`order_has_product` `op` join `clubstack`.`order` `o` on((`op`.`order_id` = `o`.`id`))) where (`o`.`date` <= curdate()) group by `op`.`product_id`) `avg_product_order_counts` on((`p`.`id` = `avg_product_order_counts`.`product_id`))) group by `p`.`id`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

CREATE DATABASE IF NOT EXISTS demo;
USE demo;


CREATE TABLE IF NOT EXISTS Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(20) NOT NULL UNIQUE,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(10, 2) NOT NULL,
    productAmount INT NOT NULL,
    productDescription TEXT,
    productStatus VARCHAR(20) DEFAULT 'Available'
);


INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
VALUES 
    ('P001', 'iPhone 15 Pro', 999.99, 50, 'Apple Flagship Smartphone', 'Available'),
    ('P002', 'Samsung Galaxy S24', 899.99, 30, 'Samsung Flagship Smartphone', 'Available'),
    ('P003', 'MacBook Pro M3', 1599.99, 15, 'High performance laptop', 'Available'),
    ('P004', 'Dell XPS 15', 1299.99, 20, 'Premium Windows laptop', 'OutOfStock'),
    ('P005', 'AirPods Pro 2', 249.99, 100, 'Wireless Noise Canceling Earbuds', 'Available');

EXPLAIN SELECT * FROM Products WHERE productCode = 'P003';
EXPLAIN SELECT * FROM Products WHERE productName = 'iPhone 15 Pro' AND productPrice = 999.99;


CREATE UNIQUE INDEX idx_productCode ON Products(productCode);


CREATE INDEX idx_name_price ON Products(productName, productPrice);


EXPLAIN SELECT * FROM Products WHERE productCode = 'P003';
EXPLAIN SELECT * FROM Products WHERE productName = 'iPhone 15 Pro' AND productPrice = 999.99;


CREATE VIEW w_product_info AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;

SELECT * FROM w_product_info;


CREATE OR REPLACE VIEW w_product_info AS
SELECT productCode, productName, productPrice, productAmount, productStatus
FROM Products;


DROP VIEW IF EXISTS w_product_info;

DELIMITER //


DROP PROCEDURE IF EXISTS sp_getAllProducts //
CREATE PROCEDURE sp_getAllProducts()
BEGIN
    SELECT * FROM Products;
END //


DROP PROCEDURE IF EXISTS sp_addProduct //
CREATE PROCEDURE sp_addProduct(
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10, 2),
    IN p_amount INT,
    IN p_description TEXT,
    IN p_status VARCHAR(20)
)
BEGIN
    INSERT INTO Products(productCode, productName, productPrice, productAmount, productDescription, productStatus)
    VALUES (p_code, p_name, p_price, p_amount, p_description, p_status);
END //

DROP PROCEDURE IF EXISTS sp_updateProductById //
CREATE PROCEDURE sp_updateProductById(
    IN p_id INT,
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10, 2),
    IN p_amount INT,
    IN p_description TEXT,
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE Products
    SET productCode = p_code,
        productName = p_name,
        productPrice = p_price,
        productAmount = p_amount,
        productDescription = p_description,
        productStatus = p_status
    WHERE Id = p_id;
END //


DROP PROCEDURE IF EXISTS sp_deleteProductById //
CREATE PROCEDURE sp_deleteProductById(
    IN p_id INT
)
BEGIN
    DELETE FROM Products WHERE Id = p_id;
END //

DELIMITER ;


CALL sp_addProduct('P006', 'iPad Air 5', 599.99, 25, 'Apple Tablet', 'Available');

CALL sp_updateProductById(1, 'P001', 'iPhone 15 Pro Max', 1199.99, 45, 'Apple Flagship 256GB', 'Available');


CALL sp_deleteProductById(5);

CALL sp_getAllProducts();
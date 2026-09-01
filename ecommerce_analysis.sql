-- ==========================================================
-- Task 3: SQL for Data Analysis
-- Database: Ecommerce Analysis
-- Tool: MySQL
-- ==========================================================

-- ==========================================================
-- 1. Create Database
-- ==========================================================

CREATE DATABASE IF NOT EXISTS ecommerce_analysis;

USE ecommerce_analysis;

-- ==========================================================
-- 2. Create Customers Table
-- ==========================================================

CREATE TABLE customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

-- ==========================================================
-- 3. Create Orders Table
-- ==========================================================

CREATE TABLE orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

-- ==========================================================
-- 4. Create Order Items Table
-- ==========================================================

CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);

-- ==========================================================
-- 5. Import CSV Files
-- ==========================================================

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- ==========================================================
-- 6. Verify Imported Data
-- ==========================================================

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;

-- ==========================================================
-- 7. SELECT
-- ==========================================================

SELECT * FROM customers LIMIT 10;

-- ==========================================================
-- 8. WHERE
-- ==========================================================

SELECT *
FROM customers
WHERE customer_state='SP';

-- ==========================================================
-- 9. ORDER BY
-- ==========================================================

SELECT *
FROM order_items
ORDER BY price DESC
LIMIT 10;

-- ==========================================================
-- 10. GROUP BY
-- ==========================================================

SELECT
customer_state,
COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

-- ==========================================================
-- 11. Aggregate Functions
-- ==========================================================

SELECT SUM(price) AS total_sales
FROM order_items;

SELECT AVG(price) AS average_price
FROM order_items;

-- ==========================================================
-- 12. INNER JOIN
-- ==========================================================

SELECT
o.order_id,
c.customer_city,
o.order_status
FROM orders o
INNER JOIN customers c
ON o.customer_id=c.customer_id
LIMIT 10;

-- ==========================================================
-- 13. LEFT JOIN
-- ==========================================================

SELECT
c.customer_id,
o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id=o.customer_id
LIMIT 10;

-- ==========================================================
-- 14. RIGHT JOIN
-- ==========================================================

SELECT
c.customer_id,
o.order_id
FROM customers c
RIGHT JOIN orders o
ON c.customer_id=o.customer_id
LIMIT 10;

-- ==========================================================
-- 15. Subquery
-- ==========================================================

SELECT
order_id,
customer_id,
order_status
FROM orders
WHERE customer_id IN
(
SELECT customer_id
FROM customers
WHERE customer_state='SP'
)
LIMIT 10;

-- ==========================================================
-- 16. Sales by Customer State
-- ==========================================================

SELECT
c.customer_state,
SUM(oi.price) AS total_sales
FROM customers c
INNER JOIN orders o
ON c.customer_id=o.customer_id
INNER JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY c.customer_state
ORDER BY total_sales DESC;

-- ==========================================================
-- 17. Top 10 Most Expensive Products
-- ==========================================================

SELECT
product_id,
MAX(price) AS highest_price
FROM order_items
GROUP BY product_id
ORDER BY highest_price DESC
LIMIT 10;

-- ==========================================================
-- 18. Order Status Distribution
-- ==========================================================

SELECT
order_status,
COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- ==========================================================
-- 19. Average Price by Customer State
-- ==========================================================

SELECT
c.customer_state,
ROUND(AVG(oi.price),2) AS average_price
FROM customers c
INNER JOIN orders o
ON c.customer_id=o.customer_id
INNER JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY c.customer_state
ORDER BY average_price DESC;

-- ==========================================================
-- 20. Create View
-- ==========================================================

CREATE VIEW order_sales_analysis AS
SELECT
o.order_id,
o.customer_id,
o.order_status,
oi.product_id,
oi.price,
oi.freight_value
FROM orders o
INNER JOIN order_items oi
ON o.order_id=oi.order_id;

-- ==========================================================
-- 21. View Analysis
-- ==========================================================

SELECT *
FROM order_sales_analysis
LIMIT 10;

SELECT COUNT(*) AS total_records
FROM order_sales_analysis;

-- ==========================================================
-- 22. Create Index
-- ==========================================================

CREATE INDEX idx_orders_customer_id
ON orders(customer_id);

SHOW INDEX
FROM orders;

-- ==========================================================
-- 23. Query Optimization
-- ==========================================================

EXPLAIN
SELECT
o.order_id,
o.order_status,
c.customer_city
FROM orders o
INNER JOIN customers c
ON o.customer_id=c.customer_id
WHERE o.customer_id='8afb90a97ee661103014329b1bcea1a2';

-- ==========================================================
-- 24. Verify View
-- ==========================================================

SHOW FULL TABLES
WHERE Table_type='VIEW';

-- ==========================================================
-- 25. Show Tables
-- ==========================================================

SHOW TABLES;
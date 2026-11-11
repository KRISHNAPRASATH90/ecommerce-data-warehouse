CREATE DATABASE ECOM_ODS;

USE ECOM_ODS;

USE ECOM_ODS;

-- TABLE CREATION

CREATE TABLE customers LIKE ECOM_STAGING.customers;

CREATE TABLE categories LIKE ECOM_STAGING.categories;

CREATE TABLE products LIKE ECOM_STAGING.products;

CREATE TABLE orders LIKE ECOM_STAGING.orders;

CREATE TABLE order_details LIKE ECOM_STAGING.order_details;

CREATE TABLE payments LIKE ECOM_STAGING.payments;

-- INSERT INTO TABLE

INSERT INTO categories
SELECT * FROM ECOM_STAGING.categories;

INSERT INTO customers
SELECT * FROM ECOM_STAGING.customers;

INSERT INTO products
SELECT * FROM ECOM_STAGING.products;

INSERT INTO orders
SELECT * FROM ECOM_STAGING.orders;

INSERT INTO order_details
SELECT * FROM ECOM_STAGING.order_details;

INSERT INTO payments
SELECT * FROM ECOM_STAGING.payments;

-- COUNT


SELECT 'categories' AS table_name, COUNT(*) AS total_rows FROM categories
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_details', COUNT(*) FROM order_details
UNION ALL
SELECT 'payments', COUNT(*) FROM payments;


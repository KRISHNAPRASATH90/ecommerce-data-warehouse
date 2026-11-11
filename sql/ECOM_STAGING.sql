CREATE DATABASE ECOM_STAGING;

USE ECOM_STAGING;

CREATE TABLE categories LIKE ECOM.categories;

CREATE TABLE customers LIKE ECOM.customers;

CREATE TABLE products LIKE ECOM.products;

CREATE TABLE orders LIKE ECOM.orders;

CREATE TABLE order_details LIKE ECOM.order_details;

CREATE TABLE payments LIKE ECOM.payments;

INSERT INTO customers
SELECT * FROM ECOM.customers;

INSERT INTO categories
SELECT * FROM ECOM.categories;

INSERT INTO products
SELECT * FROM ECOM.products;

INSERT INTO orders
SELECT * FROM ECOM.orders;

INSERT INTO order_details
SELECT * FROM ECOM.order_details;

INSERT INTO payments
SELECT * FROM ECOM.payments;


SELECT * FROM ECOM.payments;

USE ECOM_STAGING;


SELECT 'categoriCOMPANYes' AS column_names, COUNT(*) AS total_rows FROM categories
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


SELECT
    COUNT(*) AS total_rows,
    SUM(customer_name IS NULL) AS null_customer_name,
    SUM(email IS NULL) AS null_email,
    SUM(phone IS NULL) AS null_phone,
    SUM(city IS NULL) AS null_city,
    SUM(state IS NULL) AS null_state,
    SUM(country IS NULL) AS null_country,
    SUM(signup_date IS NULL) AS null_signup_date
FROM customers;

SELECT
    COUNT(*) AS total_rows,
    SUM(product_name IS NULL) AS null_product_name,
    SUM(category_id IS NULL) AS null_category_id,
    SUM(brand IS NULL) AS null_brand,
    SUM(price IS NULL) AS null_price,
    SUM(stock_quantity IS NULL) AS null_stock
FROM products;

SELECT
    COUNT(*) AS total_rows,
    SUM(customer_id IS NULL) AS null_customer_id,
    SUM(order_date IS NULL) AS null_order_date,
    SUM(order_status IS NULL) AS null_order_status,
    SUM(shipping_city IS NULL) AS null_shipping_city,
    SUM(shipping_state IS NULL) AS null_shipping_state,
    SUM(payment_method IS NULL) AS null_payment_method,
    SUM(total_amount IS NULL) AS null_total_amount
FROM orders;

SELECT
    COUNT(*) AS total_rows,
    SUM(order_id IS NULL) AS null_order_id,
    SUM(product_id IS NULL) AS null_product_id,
    SUM(quantity IS NULL) AS null_quantity,
    SUM(unit_price IS NULL) AS null_unit_price,
    SUM(discount IS NULL) AS null_discount,
    SUM(line_total IS NULL) AS null_line_total
FROM order_details;

SELECT
    COUNT(*) AS total_rows,
    SUM(order_id IS NULL) AS null_order_id,
    SUM(payment_date IS NULL) AS null_payment_date,
    SUM(payment_method IS NULL) AS null_payment_method,
    SUM(payment_status IS NULL) AS null_payment_status,
    SUM(amount IS NULL) AS null_amount
FROM payments;

-- invaild-- 

SELECT
    COUNT(*) AS total_products,
    SUM(price <= 0) AS invalid_price,
    SUM(stock_quantity < 0) AS invalid_stock
FROM products;
SELECT * FROM orders;

SELECT COUNT(*) AS invalid_category_products
FROM products p
LEFT JOIN categories c
    ON p.category_id = c.category_id
WHERE c.category_id IS NULL;

SELECT
    COUNT(*) AS total_orders,
    SUM(total_amount <= 0) AS invalid_total_amount
FROM orders;

SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

SELECT
    payment_method,
    COUNT(*) AS order_count
FROM orders
GROUP BY payment_method
ORDER BY order_count DESC;


-- DUPLICATE

SELECT
    customer_id,
    COUNT(*) AS count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

   
SELECT
    email,
    COUNT(*) AS count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

SELECT
    order_id,
    COUNT(*) AS count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS invalid_customer_orders
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT * FROM PRODUCTS
;
SELECT COUNT(*) AS invalid_order_details
FROM order_details od
LEFT JOIN orders o
    ON od.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS invalid_product_details
FROM order_details od
LEFT JOIN products p
    ON od.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT
    COUNT(*) AS total_details,
    SUM(quantity <= 0) AS invalid_quantity,
    SUM(unit_price <= 0) AS invalid_unit_price,
    SUM(discount < 0 OR discount > 100) AS invalid_discount
FROM order_details;

SELECT
    order_detail_id,
    quantity,
    unit_price,
    discount,
    line_total,
    ROUND(
        quantity * unit_price * (1 - discount / 100),
        2
    ) AS calculated_line_total
FROM order_details
LIMIT 20;




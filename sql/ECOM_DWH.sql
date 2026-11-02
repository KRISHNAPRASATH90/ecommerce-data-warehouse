CREATE DATABASE ECOM_DWH;
USE ECOM_DWH;


CREATE TABLE dim_customer (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    signup_date DATE
);


CREATE TABLE dim_product (
    product_key INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    product_name VARCHAR(150),
    brand VARCHAR(100),
    category_id INT,
    price DECIMAL(10,2)
);



CREATE TABLE dim_category (
    category_key INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    category_name VARCHAR(100)
);



CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    day INT,
    month INT,
    month_name VARCHAR(20),
    quarter INT,
    year INT
);



CREATE TABLE dim_payment (
    payment_key INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50)
);

-- CREATE FACT TABLE
select * from fact_sales;
CREATE TABLE fact_sales (
    sales_key INT AUTO_INCREMENT PRIMARY KEY,

    order_id INT,
    
    customer_key INT,
    product_key INT,
    category_key INT,
    date_key INT,
    payment_key INT,

    quantity INT,
    unit_price DECIMAL(10,2),
    discount DECIMAL(5,2),
    sales_amount DECIMAL(12,2)
);

-- INSERT CUSTOMER DATA

INSERT INTO dim_customer (
    customer_id,
    customer_name,
    email,
    phone,
    city,
    state,
    country,
    signup_date
)
SELECT
    customer_id,
    customer_name,
    email,
    phone,
    city,
    state,
    country,
    signup_date
FROM ECOM_ODS.customers;

-- INSERT PRODUCT DATA

INSERT INTO dim_product (
    product_id,
    product_name,
    brand,
    category_id,
    price
)
SELECT
    product_id,
    product_name,
    brand,
    category_id,
    price
FROM ECOM_ODS.products;

-- INSERT CATEGORY DATA

INSERT INTO dim_category (
    category_id,
    category_name
)
SELECT
    category_id,
    category_name
FROM ECOM_ODS.categories;



-- INSERT DATE  DATA

INSERT INTO dim_date (
    date_key,
    full_date,
    day,
    month,
    month_name,
    quarter,
    year
)
SELECT DISTINCT
    DATE_FORMAT(order_date, '%Y%m%d') + 0 AS date_key,
    DATE(order_date) AS full_date,
    DAY(order_date) AS day,
    MONTH(order_date) AS month,
    MONTHNAME(order_date) AS month_name,
    QUARTER(order_date) AS quarter,
    YEAR(order_date) AS year
FROM ECOM_ODS.orders;

-- INSERT PAYMENT DATA

INSERT INTO dim_payment (
    payment_id,
    payment_method,
    payment_status
)
SELECT
    payment_id,
    payment_method,
    payment_status
FROM ECOM_ODS.payments;



-- FACT INSERT


INSERT INTO fact_sales (
    order_id,
    customer_key,
    product_key,
    category_key,
    date_key,
    payment_key,
    quantity,
    unit_price,
    discount,
    sales_amount
)
SELECT
    o.order_id,
    dc.customer_key,
    dp.product_key,
    dcat.category_key,
    dd.date_key,
    dpay.payment_key,
    od.quantity,
    od.unit_price,
    od.discount,
    od.line_total
FROM ECOM_ODS.order_details od

JOIN ECOM_ODS.orders o
    ON od.order_id = o.order_id

JOIN ECOM_ODS.payments p
    ON o.order_id = p.order_id

JOIN ECOM_DWH.dim_customer dc
    ON o.customer_id = dc.customer_id

JOIN ECOM_DWH.dim_product dp
    ON od.product_id = dp.product_id

JOIN ECOM_DWH.dim_category dcat
    ON dp.category_id = dcat.category_id

JOIN ECOM_DWH.dim_date dd
    ON o.order_date = dd.full_date

JOIN ECOM_DWH.dim_payment dpay
    ON p.payment_id = dpay.payment_id;
    
-- CHECKING FACT

SELECT *
FROM fact_sales
LIMIT 20;

SELECT * FROM dim_product;

-- check the fact

SELECT COUNT(*) AS fact_rows
FROM fact_sales;

SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_key) AS customer_keys,
    COUNT(product_key) AS product_keys,
    COUNT(category_key) AS category_keys,
    COUNT(date_key) AS date_keys,
    COUNT(payment_key) AS payment_keys
FROM fact_sales;

-- Validate sales_amount

SELECT
    order_id,
    quantity,
    unit_price,
    discount,
    sales_amount,
    ROUND(
        quantity * unit_price * (1 - discount / 100),
        2
    ) AS calculated_amount
FROM fact_sales
LIMIT 20;

-- Check for duplicate sales rows

SELECT
    order_id,
    product_key,
    COUNT(*) AS row_count
FROM fact_sales
GROUP BY
    order_id,
    product_key
HAVING COUNT(*) > 1;


-- Check that every fact row has a valid customer
SELECT COUNT(*) AS invalid_customer_keys
FROM fact_sales f
LEFT JOIN dim_customer c
    ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;

-- Check Product Key Integrity

SELECT COUNT(*) AS invalid_product_keys
FROM fact_sales f
LEFT JOIN dim_product p
    ON f.product_key = p.product_key
WHERE p.product_key IS NULL;

-- Check Category Key Integrity

SELECT COUNT(*) AS invalid_category_keys
FROM fact_sales f
LEFT JOIN dim_category c
    ON f.category_key = c.category_key
WHERE c.category_key IS NULL;

-- Check Date Key Integrity
SELECT COUNT(*) AS invalid_date_keys
FROM fact_sales f
LEFT JOIN dim_date d
    ON f.date_key = d.date_key
WHERE d.date_key IS NULL;

-- Check Payment Key Integrity

SELECT COUNT(*) AS invalid_payment_keys
FROM fact_sales f
LEFT JOIN dim_payment p
    ON f.payment_key = p.payment_key
WHERE p.payment_key IS NULL;


-- Check Sales Amount Calculation


SELECT
    order_id,
    quantity,
    unit_price,
    discount,
    sales_amount,
    ROUND(
        quantity * unit_price * (1 - discount / 100),
        2
    ) AS calculated_amount
FROM fact_sales
WHERE sales_amount <> ROUND(
    quantity * unit_price * (1 - discount / 100),
    2
)
LIMIT 20;



SELECT SUM(sales_amount) AS total_sales
FROM fact_sales;

-- Which category generates the most revenue?
SELECT
    c.category_name,
    SUM(f.sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_category c
    ON f.category_key = c.category_key
GROUP BY c.category_name
ORDER BY total_sales DESC;


-- Which products sell the most?
SELECT
    p.product_name,
    SUM(f.quantity) AS units_sold
FROM fact_sales f
JOIN dim_product p
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY units_sold DESC;


-- How much did we sell each month?
SELECT
    d.year,
    d.month,
    d.month_name,
    SUM(f.sales_amount) AS total_sales
FROM fact_sales f
JOIN dim_date d
    ON f.date_key = d.date_key
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY d.year, d.month;























/* =========================================================
   PROJECT: E-commerce SQL Profitability Analysis
   FILE: 01_data_exploration.sql
   PURPOSE: Explore data granularity, keys, and join quality
   DATABASE: xomdata_dataset
   SCHEMA: e_commerce
========================================================= */

-- 01. Preview main sales table
SELECT TOP 100 *
FROM e_commerce.ecom_sales;


-- 02. Check sales table overview
-- COUNT(*) = number of order lines
-- COUNT(DISTINCT order_id) = number of actual orders
SELECT
    COUNT(*) AS total_order_lines,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT product_code) AS total_products,
    COUNT(DISTINCT region_code) AS total_regions
FROM e_commerce.ecom_sales;


-- 03. Check duplicate key in customer dimension
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM e_commerce.customer;


-- 04. Check duplicate key in product dimension
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_code) AS unique_products
FROM e_commerce.product;


-- 05. Check duplicate key in region dimension
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT region_code) AS unique_regions
FROM e_commerce.region;


-- 06. Check missing values after joining sales with dimension tables
SELECT
    COUNT(*) AS total_rows_after_join,
    SUM(CASE WHEN c.customer_id IS NULL THEN 1 ELSE 0 END) AS missing_customer,
    SUM(CASE WHEN p.product_code IS NULL THEN 1 ELSE 0 END) AS missing_product,
    SUM(CASE WHEN r.region_code IS NULL THEN 1 ELSE 0 END) AS missing_region
FROM e_commerce.ecom_sales s
LEFT JOIN e_commerce.customer c
    ON s.customer_id = c.customer_id
LEFT JOIN e_commerce.product p
    ON s.product_code = p.product_code
LEFT JOIN e_commerce.region r
    ON s.region_code = r.region_code;


-- 07. Inspect unmatched product or region records
SELECT 
    s.row_id,
    s.order_id,
    s.product_code,
    p.product_code AS matched_product_code,
    s.region_code,
    r.region_code AS matched_region_code
FROM e_commerce.ecom_sales s
LEFT JOIN e_commerce.product p
    ON s.product_code = p.product_code
LEFT JOIN e_commerce.region r
    ON s.region_code = r.region_code
WHERE 
    p.product_code IS NULL
    OR r.region_code IS NULL;

/* =========================================================
   FILE: 04_customer_analysis.sql
   PURPOSE: Customer profitability and customer value segmentation
========================================================= */

-- 01. Top 10 customers by sales
SELECT TOP 10
    es.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    es.segment,
    COUNT(DISTINCT es.order_id) AS total_orders,
    SUM(es.sales) AS total_sales,
    SUM(es.profit) AS total_profit,
    ROUND(SUM(es.profit) * 100.0 / NULLIF(SUM(es.sales), 0), 2) AS profit_margin,
    ROUND(AVG(es.discount), 4) AS average_discount
FROM e_commerce.ecom_sales es
LEFT JOIN e_commerce.customer c
    ON es.customer_id = c.customer_id
GROUP BY 
    es.customer_id,
    c.first_name,
    c.last_name,
    es.segment
ORDER BY total_sales DESC, total_profit DESC;


-- 02. High-sales customers with negative profit
SELECT TOP 10
    es.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    es.segment,
    COUNT(DISTINCT es.order_id) AS total_orders,
    SUM(es.sales) AS total_sales,
    SUM(es.profit) AS total_profit,
    ROUND(SUM(es.profit) * 100.0 / NULLIF(SUM(es.sales), 0), 2) AS profit_margin,
    ROUND(AVG(es.discount), 4) AS average_discount
FROM e_commerce.ecom_sales es
LEFT JOIN e_commerce.customer c
    ON es.customer_id = c.customer_id
GROUP BY 
    es.customer_id,
    c.first_name,
    c.last_name,
    es.segment
HAVING SUM(es.profit) < 0
ORDER BY total_sales DESC;


-- 03. Loss-making customer-category-discount combinations
WITH sales_discount AS (
    SELECT 
        es.customer_id,
        c.first_name,
        c.last_name,
        p.category,
        es.discount,
        es.sales,
        es.profit,
        es.order_id,
        CASE 
            WHEN es.discount = 0 THEN 'No Discount'
            WHEN es.discount <= 0.1 THEN 'Low Discount'
            WHEN es.discount <= 0.3 THEN 'Medium Discount'
            ELSE 'High Discount'
        END AS discount_tier
    FROM e_commerce.ecom_sales es 
    LEFT JOIN e_commerce.customer c 
        ON es.customer_id = c.customer_id 
    LEFT JOIN e_commerce.product p 
        ON es.product_code = p.product_code 
)
SELECT TOP 20
    customer_id,
    CONCAT(first_name, ' ', last_name) AS customer_name,
    category,
    discount_tier,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) * 100.0 / NULLIF(SUM(sales), 0), 2) AS profit_margin,
    ROUND(AVG(discount), 4) AS average_discount
FROM sales_discount
GROUP BY 
    customer_id,
    first_name,
    last_name,
    category,
    discount_tier
HAVING SUM(profit) < 0
ORDER BY total_sales DESC;


-- 04. Customer value segmentation detail
WITH customer_summary AS (
    SELECT  
        es.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        es.segment,
        COUNT(DISTINCT es.order_id) AS total_orders,
        SUM(es.sales) AS total_sales,
        SUM(es.profit) AS total_profit,
        ROUND(SUM(es.profit) * 100.0 / NULLIF(SUM(es.sales), 0), 2) AS profit_margin,
        ROUND(AVG(es.discount), 4) AS average_discount
    FROM e_commerce.ecom_sales es 
    LEFT JOIN e_commerce.customer c 
        ON es.customer_id = c.customer_id 
    GROUP BY 
        es.customer_id,
        c.first_name,
        c.last_name,
        es.segment
)
SELECT
    customer_id,
    customer_name,
    segment,
    total_orders,
    total_sales,
    total_profit,
    profit_margin,
    average_discount,
    CASE 
        WHEN total_profit < 0 THEN 'Loss Making'
        WHEN total_sales >= 5000 AND profit_margin >= 15 THEN 'High Value'
        WHEN total_sales >= 2000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_value_tier
FROM customer_summary
ORDER BY total_sales DESC;


-- 05. Customer value tier summary
WITH customer_summary AS (
    SELECT  
        es.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        es.segment,
        COUNT(DISTINCT es.order_id) AS total_orders,
        SUM(es.sales) AS total_sales,
        SUM(es.profit) AS total_profit,
        ROUND(SUM(es.profit) * 100.0 / NULLIF(SUM(es.sales), 0), 2) AS profit_margin,
        ROUND(AVG(es.discount), 4) AS average_discount
    FROM e_commerce.ecom_sales es 
    LEFT JOIN e_commerce.customer c 
        ON es.customer_id = c.customer_id 
    GROUP BY 
        es.customer_id,
        c.first_name,
        c.last_name,
        es.segment
),
customer_segmented AS (
    SELECT 
        customer_id,
        customer_name,
        segment,
        total_orders,
        total_sales,
        total_profit,
        profit_margin,
        average_discount,
        CASE 
            WHEN total_profit < 0 THEN 'Loss Making'
            WHEN total_sales >= 5000 AND profit_margin >= 15 THEN 'High Value'
            WHEN total_sales >= 2000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_value_tier
    FROM customer_summary
)
SELECT
    customer_value_tier,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(total_orders) AS total_orders,
    SUM(total_sales) AS total_sales,
    SUM(total_profit) AS total_profit,
    ROUND(SUM(total_profit) * 100.0 / NULLIF(SUM(total_sales), 0), 2) AS profit_margin,
    ROUND(AVG(average_discount), 4) AS avg_customer_discount
FROM customer_segmented
GROUP BY customer_value_tier
ORDER BY total_profit DESC;


-- 06. Customer value tier by segment
WITH customer_summary AS (
    SELECT  
        es.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        es.segment,
        COUNT(DISTINCT es.order_id) AS total_orders,
        SUM(es.sales) AS total_sales,
        SUM(es.profit) AS total_profit,
        ROUND(SUM(es.profit) * 100.0 / NULLIF(SUM(es.sales), 0), 2) AS profit_margin,
        ROUND(AVG(es.discount), 4) AS average_discount
    FROM e_commerce.ecom_sales es 
    LEFT JOIN e_commerce.customer c 
        ON es.customer_id = c.customer_id 
    GROUP BY 
        es.customer_id,
        c.first_name,
        c.last_name,
        es.segment
),
customer_segmented AS (
    SELECT 
        customer_id,
        customer_name,
        segment,
        total_orders,
        total_sales,
        total_profit,
        profit_margin,
        average_discount,
        CASE 
            WHEN total_profit < 0 THEN 'Loss Making'
            WHEN total_sales >= 5000 AND profit_margin >= 15 THEN 'High Value'
            WHEN total_sales >= 2000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_value_tier
    FROM customer_summary
)
SELECT
    segment,
    customer_value_tier,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(total_sales) AS total_sales,
    SUM(total_profit) AS total_profit,
    ROUND(SUM(total_profit) * 100.0 / NULLIF(SUM(total_sales), 0), 2) AS profit_margin
FROM customer_segmented
GROUP BY segment, customer_value_tier
ORDER BY segment, total_profit DESC;

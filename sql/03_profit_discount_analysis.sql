/* =========================================================
   FILE: 03_profit_discount_analysis.sql
   PURPOSE: Discount impact and loss-driver analysis
========================================================= */

-- 01. Profitability by category and discount tier
WITH sales_with_discount_tier AS (
    SELECT
        p.category,
        es.order_id,
        es.customer_id,
        es.sales,
        es.profit,
        es.discount,
        CASE
            WHEN es.discount = 0 THEN 'No Discount'
            WHEN es.discount <= 0.1 THEN 'Low Discount'
            WHEN es.discount <= 0.3 THEN 'Medium Discount'
            ELSE 'High Discount'
        END AS discount_tier
    FROM e_commerce.ecom_sales es
    LEFT JOIN e_commerce.product p
        ON es.product_code = p.product_code
)
SELECT
    category,
    discount_tier,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) * 100.0 / NULLIF(SUM(sales), 0), 2) AS profit_margin,
    ROUND(AVG(discount), 4) AS average_discount
FROM sales_with_discount_tier
GROUP BY category, discount_tier
ORDER BY category, profit_margin DESC;


-- 02. Profitability by discount tier
WITH sales_discount AS (
    SELECT
        es.order_id,
        es.sales,
        es.profit,
        es.discount,
        CASE
            WHEN es.discount = 0 THEN 'No Discount'
            WHEN es.discount <= 0.1 THEN 'Low Discount'
            WHEN es.discount <= 0.3 THEN 'Medium Discount'
            ELSE 'High Discount'
        END AS discount_tier
    FROM e_commerce.ecom_sales es
)
SELECT
    discount_tier,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) * 100.0 / NULLIF(SUM(sales), 0), 2) AS profit_margin,
    ROUND(AVG(discount), 4) AS average_discount
FROM sales_discount
GROUP BY discount_tier
ORDER BY profit_margin DESC;


-- 03. Profitability by customer segment and discount tier
WITH sales_discount AS (
    SELECT
        es.segment,
        es.order_id,
        es.sales,
        es.profit,
        es.discount,
        CASE
            WHEN es.discount = 0 THEN 'No Discount'
            WHEN es.discount <= 0.1 THEN 'Low Discount'
            WHEN es.discount <= 0.3 THEN 'Medium Discount'
            ELSE 'High Discount'
        END AS discount_tier
    FROM e_commerce.ecom_sales es
)
SELECT
    segment,
    discount_tier,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) * 100.0 / NULLIF(SUM(sales), 0), 2) AS profit_margin,
    ROUND(AVG(discount), 4) AS average_discount
FROM sales_discount
GROUP BY segment, discount_tier
ORDER BY segment, profit_margin DESC;


-- 04. Corporate category performance by discount tier
WITH sales_discount AS (
    SELECT
        p.category,
        es.segment,
        es.order_id,
        es.sales,
        es.profit,
        es.discount,
        CASE
            WHEN es.discount = 0 THEN 'No Discount'
            WHEN es.discount <= 0.1 THEN 'Low Discount'
            WHEN es.discount <= 0.3 THEN 'Medium Discount'
            ELSE 'High Discount'
        END AS discount_tier
    FROM e_commerce.ecom_sales es
    LEFT JOIN e_commerce.product p
        ON es.product_code = p.product_code
)
SELECT
    category,
    discount_tier,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) * 100.0 / NULLIF(SUM(sales), 0), 2) AS profit_margin,
    ROUND(AVG(discount), 4) AS average_discount
FROM sales_discount
WHERE segment = 'Corporate'
GROUP BY category, discount_tier
ORDER BY category, average_discount;


-- 05. Biggest loss drivers under high discount
WITH sales_discount AS (
    SELECT
        p.category,
        es.segment,
        es.order_id,
        es.sales,
        es.profit,
        es.discount,
        CASE
            WHEN es.discount = 0 THEN 'No Discount'
            WHEN es.discount <= 0.1 THEN 'Low Discount'
            WHEN es.discount <= 0.3 THEN 'Medium Discount'
            ELSE 'High Discount'
        END AS discount_tier
    FROM e_commerce.ecom_sales es
    LEFT JOIN e_commerce.product p
        ON es.product_code = p.product_code
)
SELECT
    segment,
    category,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) * 100.0 / NULLIF(SUM(sales), 0), 2) AS profit_margin,
    ROUND(AVG(discount), 4) AS average_discount
FROM sales_discount
WHERE discount_tier = 'High Discount'
GROUP BY segment, category
ORDER BY total_profit ASC;


-- 06. High-discount loss priority by segment and category
WITH sales_discount AS (
    SELECT
        p.category,
        es.segment,
        es.order_id,
        es.sales,
        es.profit,
        es.discount,
        CASE
            WHEN es.discount = 0 THEN 'No Discount'
            WHEN es.discount <= 0.1 THEN 'Low Discount'
            WHEN es.discount <= 0.3 THEN 'Medium Discount'
            ELSE 'High Discount'
        END AS discount_tier
    FROM e_commerce.ecom_sales es
    LEFT JOIN e_commerce.product p
        ON es.product_code = p.product_code
),
loss_summary AS (
    SELECT
        segment,
        category,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        ROUND(SUM(profit) * 100.0 / NULLIF(SUM(sales), 0), 2) AS profit_margin,
        ROUND(AVG(discount), 4) AS average_discount
    FROM sales_discount
    WHERE discount_tier = 'High Discount'
    GROUP BY segment, category
    HAVING SUM(profit) < 0
)
SELECT
    segment,
    category,
    total_orders,
    total_sales,
    total_profit,
    profit_margin,
    average_discount,
    CASE
        WHEN total_profit <= -50000 THEN 'Critical Loss'
        WHEN total_profit <= -20000 THEN 'High Loss'
        ELSE 'Medium Loss'
    END AS loss_priority
FROM loss_summary
ORDER BY total_profit ASC;

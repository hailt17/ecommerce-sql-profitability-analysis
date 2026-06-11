/* =========================================================
   FILE: 05_product_analysis.sql
   PURPOSE: Product and category performance analysis
========================================================= */

-- 01. Category performance
SELECT
    p.category,
    COUNT(DISTINCT es.order_id) AS total_orders,
    SUM(es.sales) AS total_sales,
    SUM(es.profit) AS total_profit,
    ROUND(SUM(es.profit) * 100.0 / NULLIF(SUM(es.sales), 0), 2) AS profit_margin,
    ROUND(AVG(es.discount), 4) AS average_discount
FROM e_commerce.ecom_sales es
LEFT JOIN e_commerce.product p
    ON es.product_code = p.product_code
GROUP BY p.category
ORDER BY total_profit DESC;


-- 02. Top 10 products by sales
SELECT TOP 10
    p.product_code,
    p.product,
    p.category,
    COUNT(DISTINCT es.order_id) AS total_orders,
    SUM(es.sales) AS total_sales,
    SUM(es.profit) AS total_profit,
    ROUND(SUM(es.profit) * 100.0 / NULLIF(SUM(es.sales), 0), 2) AS profit_margin,
    ROUND(AVG(es.discount), 4) AS average_discount
FROM e_commerce.ecom_sales es
LEFT JOIN e_commerce.product p
    ON es.product_code = p.product_code
GROUP BY 
    p.product_code,
    p.product,
    p.category
ORDER BY total_sales DESC;


-- 03. Products with high sales but negative profit
SELECT TOP 10
    p.product_code,
    p.product,
    p.category,
    COUNT(DISTINCT es.order_id) AS total_orders,
    SUM(es.sales) AS total_sales,
    SUM(es.profit) AS total_profit,
    ROUND(SUM(es.profit) * 100.0 / NULLIF(SUM(es.sales), 0), 2) AS profit_margin,
    ROUND(AVG(es.discount), 4) AS average_discount
FROM e_commerce.ecom_sales es
LEFT JOIN e_commerce.product p
    ON es.product_code = p.product_code
GROUP BY 
    p.product_code,
    p.product,
    p.category
HAVING SUM(es.profit) < 0
ORDER BY total_sales DESC;

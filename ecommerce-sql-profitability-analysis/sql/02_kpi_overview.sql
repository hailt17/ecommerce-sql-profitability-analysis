/* =========================================================
   FILE: 02_kpi_overview.sql
   PURPOSE: Overall KPI, segment, and category performance
========================================================= */

-- 01. Overall business performance
SELECT 
    COUNT(*) AS total_order_lines,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) * 100.0 / NULLIF(SUM(sales), 0), 2) AS profit_margin,
    ROUND(AVG(discount), 4) AS average_discount
FROM e_commerce.ecom_sales;


-- 02. Sales and profit by customer segment
SELECT 
    segment,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) * 100.0 / NULLIF(SUM(sales), 0), 2) AS profit_margin,
    ROUND(AVG(discount), 4) AS average_discount
FROM e_commerce.ecom_sales
GROUP BY segment
ORDER BY total_profit DESC;


-- 03. Sales and profit by product category
SELECT 
    p.category,
    COUNT(DISTINCT es.order_id) AS total_orders,
    COUNT(DISTINCT es.customer_id) AS total_customers,
    SUM(es.sales) AS total_sales,
    SUM(es.profit) AS total_profit,
    ROUND(SUM(es.profit) * 100.0 / NULLIF(SUM(es.sales), 0), 2) AS profit_margin,
    ROUND(AVG(es.discount), 4) AS average_discount
FROM e_commerce.ecom_sales es
LEFT JOIN e_commerce.product p
    ON es.product_code = p.product_code
GROUP BY p.category
ORDER BY total_profit DESC;

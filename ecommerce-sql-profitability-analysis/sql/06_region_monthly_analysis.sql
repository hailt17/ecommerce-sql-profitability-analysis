/* =========================================================
   FILE: 06_region_monthly_analysis.sql
   PURPOSE: Region and monthly trend analysis
========================================================= */

-- 01. Region performance
SELECT
    r.region,
    COUNT(DISTINCT es.order_id) AS total_orders,
    COUNT(DISTINCT es.customer_id) AS total_customers,
    SUM(es.sales) AS total_sales,
    SUM(es.profit) AS total_profit,
    ROUND(SUM(es.profit) * 100.0 / NULLIF(SUM(es.sales), 0), 2) AS profit_margin,
    ROUND(AVG(es.discount), 4) AS average_discount
FROM e_commerce.ecom_sales es
LEFT JOIN e_commerce.region r
    ON es.region_code = r.region_code
GROUP BY r.region
ORDER BY total_profit DESC;


-- 02. Monthly sales and profit trend
SELECT
    DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS order_month,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) * 100.0 / NULLIF(SUM(sales), 0), 2) AS profit_margin,
    ROUND(AVG(discount), 4) AS average_discount
FROM e_commerce.ecom_sales
GROUP BY DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1)
ORDER BY order_month;


-- 03. Monthly growth
WITH monthly_summary AS (
    SELECT
        DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS order_month,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit
    FROM e_commerce.ecom_sales
    GROUP BY DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1)
),
monthly_growth AS (
    SELECT
        order_month,
        total_sales,
        total_profit,
        LAG(total_sales) OVER (ORDER BY order_month) AS previous_month_sales,
        LAG(total_profit) OVER (ORDER BY order_month) AS previous_month_profit
    FROM monthly_summary
)
SELECT
    order_month,
    total_sales,
    previous_month_sales,
    total_sales - previous_month_sales AS sales_change,
    ROUND((total_sales - previous_month_sales) * 100.0 / NULLIF(previous_month_sales, 0), 2) AS sales_growth_percent,
    total_profit,
    previous_month_profit,
    total_profit - previous_month_profit AS profit_change,
    ROUND((total_profit - previous_month_profit) * 100.0 / NULLIF(previous_month_profit, 0), 2) AS profit_growth_percent
FROM monthly_growth
ORDER BY order_month;


-- 04. Region monthly performance
SELECT
    DATEFROMPARTS(YEAR(es.order_date), MONTH(es.order_date), 1) AS order_month,
    r.region,
    COUNT(DISTINCT es.order_id) AS total_orders,
    SUM(es.sales) AS total_sales,
    SUM(es.profit) AS total_profit,
    ROUND(SUM(es.profit) * 100.0 / NULLIF(SUM(es.sales), 0), 2) AS profit_margin
FROM e_commerce.ecom_sales es
LEFT JOIN e_commerce.region r
    ON es.region_code = r.region_code
GROUP BY 
    DATEFROMPARTS(YEAR(es.order_date), MONTH(es.order_date), 1),
    r.region
ORDER BY order_month, total_profit DESC;

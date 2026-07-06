-- =============================================================================
-- THEME 2: PHÂN TÍCH ĐỊA LÝ & CHIẾN LƯỢC MỞ RỘNG (GEOGRAPHIC GROWTH)
-- =============================================================================

-- Q3: Top 10 sản phẩm được khách hàng mua nhiều nhất (Tính theo tổng số lượng Quantity)
SELECT TOP 10 
    p.product,
    SUM(s.quantity) AS total_quantity_sold,
    ROUND(SUM(s.sales), 2) AS total_revenue
FROM e_commerce.ecom_sales s
JOIN e_commerce.product p ON s.product_code = p.product_code
GROUP BY p.product
ORDER BY total_quantity_sold DESC;


-- Q10: Top 15 quốc gia đem lại doanh thu lớn nhất sàn và số lượng khách hàng tương ứng
SELECT TOP 15 
    r.country,
    ROUND(SUM(s.sales), 2) AS total_revenue,
    COUNT(DISTINCT s.customer_id) AS unique_customers_count
FROM e_commerce.ecom_sales s
JOIN e_commerce.region r ON s.region_code = r.region_code
GROUP BY r.country
ORDER BY total_revenue DESC;


-- Q11: Tốc độ tăng trưởng Doanh thu cùng kỳ năm trước (YoY Growth %) theo từng Tháng
WITH monthly_sales AS (
    SELECT 
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        SUM(sales) AS current_sales
    FROM e_commerce.ecom_sales
    GROUP BY YEAR(order_date), MONTH(order_date)
),
yoy_sales AS (
    SELECT 
        order_year,
        order_month,
        current_sales,
        LAG(current_sales, 12) OVER (ORDER BY order_year, order_month) AS previous_year_sales
    FROM monthly_sales
)
SELECT 
    order_year,
    order_month,
    ROUND(current_sales, 2) AS current_sales,
    ROUND(previous_year_sales, 2) AS prev_year_sales,
    ROUND(((current_sales - previous_year_sales) / NULLIF(previous_year_sales, 0)) * 100, 2) AS yoy_growth_pct
FROM yoy_sales
ORDER BY order_year DESC, order_month DESC;


-- Q13: Khám phá hành vi khách mua Cross-market (Khách hàng toàn cầu đặt đơn ở nhiều Market khác nhau)
WITH customer_markets AS (
    SELECT DISTINCT 
        s.customer_id,
        r.market,
        FIRST_VALUE(r.market) OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS first_purchased_market
    FROM e_commerce.ecom_sales s
    JOIN e_commerce.region r ON s.region_code = r.region_code
)
SELECT 
    customer_id,
    COUNT(DISTINCT market) AS total_markets_shopped,
    first_purchased_market
FROM customer_markets
GROUP BY customer_id, first_purchased_market
HAVING COUNT(DISTINCT market) > 1 -- Chỉ lọc những khách mua hàng đa quốc gia
ORDER BY total_markets_shopped DESC;

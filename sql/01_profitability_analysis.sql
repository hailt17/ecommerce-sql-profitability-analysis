-- =============================================================================
-- THEME 1: CỨU VÃN LỢI NHUẬN & TỐI ƯU KHUYẾN MÃI (PROFITABILITY & DISCOUNT)
-- =============================================================================

-- Q1: Tổng doanh thu và profit toàn sàn (Bức tranh tổng quan)
SELECT 
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS gross_profit_margin_pct
FROM e_commerce.ecom_sales;


-- Q2: Doanh thu và lợi nhuận bổ nhỏ theo Phân khúc (Segment) để xem ai là Cash Cow
SELECT 
    segment,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
FROM e_commerce.ecom_sales
GROUP BY segment
ORDER BY total_revenue DESC;


-- Q5: Mức discount trung bình theo từng Danh mục sản phẩm (Category)
SELECT 
    p.category,
    ROUND(AVG(s.discount) * 100, 2) AS avg_discount_pct,
    ROUND(SUM(s.sales), 2) AS total_revenue,
    ROUND(SUM(s.profit), 2) AS total_profit
FROM e_commerce.ecom_sales s
JOIN e_commerce.product p ON s.product_code = p.product_code
GROUP BY p.category
ORDER BY avg_discount_pct DESC;


-- Q6: Biên lợi nhuận (Profit Margin) theo từng Thị trường (Market) lớn
SELECT 
    r.market,
    ROUND(SUM(s.sales), 2) AS total_revenue,
    ROUND(SUM(s.profit), 2) AS total_profit,
    ROUND((SUM(s.profit) / NULLIF(SUM(s.sales), 0)) * 100, 2) AS profit_margin_pct
FROM e_commerce.ecom_sales s
JOIN e_commerce.region r ON s.region_code = r.region_code
GROUP BY r.market
HAVING SUM(s.sales) > 0  -- Lọc bỏ các thị trường thử nghiệm không phát sinh sales lớn
ORDER BY profit_margin_pct DESC;


-- Q7: Đơn hàng bị lỗ (Profit < 0) theo từng Phân khúc khách hàng
-- Đo lường mức độ tàn phá của "Discount Cannibalization"
SELECT 
    segment,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT CASE WHEN profit < 0 THEN order_id END) AS total_loss_orders,
    ROUND(COUNT(DISTINCT CASE WHEN profit < 0 THEN order_id END) * 100.0 / COUNT(DISTINCT order_id), 2) AS loss_order_ratio_pct,
    ROUND(AVG(CASE WHEN profit < 0 THEN discount END) * 100, 2) AS avg_discount_on_loss_orders
FROM e_commerce.ecom_sales
GROUP BY segment
ORDER BY loss_order_ratio_pct DESC;


-- Q12: Top 3 sản phẩm mang lại nhiều lợi nhuận (Profit) nhất trong mỗi Category
WITH product_profit_ranking AS (
    SELECT 
        p.category,
        p.product,
        ROUND(SUM(s.profit), 2) AS total_profit,
        ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(s.profit) DESC) AS rank_idx
    FROM e_commerce.ecom_sales s
    JOIN e_commerce.product p ON s.product_code = p.product_code
    GROUP BY p.category, p.product
)
SELECT category, product, total_profit
FROM product_profit_ranking
WHERE rank_idx <= 3;

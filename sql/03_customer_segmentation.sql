-- =============================================================================
-- THEME 3: TỐI ĐA HÓA GIÁ TRỊ VÒNG ĐỜI KHÁCH HÀNG (CUSTOMER RETAIN & LTV)
-- =============================================================================

-- Q4: Phân tích số lượng khách hàng theo tổ hợp Giới tính x Nghề nghiệp (Demographics)
SELECT 
    c.gender,
    c.occupation,
    COUNT(DISTINCT c.customer_id) AS total_customers
FROM e_commerce.customer c
GROUP BY c.gender, c.occupation
ORDER BY total_customers DESC;


-- Q8: Định vị Khách VIP có nguy cơ rời bỏ (VIP Churn Risk)
-- Tiêu chuẩn VIP: Đã từng mang lại Profit lớn. Nguy cơ Churn: Quá lâu chưa mua lại đơn mới.
WITH customer_value AS (
    SELECT 
        customer_id,
        SUM(profit) AS total_profit_contributed,
        MAX(order_date) AS last_purchase_date,
        DATEDIFF(day, MAX(order_date), '2026-01-01') AS days_since_last_order -- Giả định ngày chốt báo cáo
    FROM e_commerce.ecom_sales
    GROUP BY customer_id
),
ranked_vip AS (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY total_profit_contributed DESC) AS vip_rank
    FROM customer_value
)
SELECT 
    customer_id,
    ROUND(total_profit_contributed, 2) AS total_profit,
    last_purchase_date,
    days_since_last_order
FROM ranked_vip
WHERE vip_rank <= 500 AND days_since_last_order > 180 -- Thuộc top VIP nhưng >6 tháng chưa phát sinh đơn
ORDER BY days_since_last_order DESC;


-- Q9: Phân tích Cross-sell (Bán chéo) ma trận danh mục giữa nhóm Consumer vs Corporate
SELECT 
    segment,
    ROUND(SUM(CASE WHEN p.category = 'Office Supplies' THEN s.sales ELSE 0 END), 2) AS office_supplies_sales,
    ROUND(SUM(CASE WHEN p.category = 'Furniture' THEN s.sales ELSE 0 END), 2) AS furniture_sales,
    ROUND(SUM(CASE WHEN p.category = 'Technology' THEN s.sales ELSE 0 END), 2) AS technology_sales,
    ROUND(SUM(s.sales), 2) AS total_sales
FROM e_commerce.ecom_sales s
JOIN e_commerce.product p ON s.product_code = p.product_code
WHERE segment IN ('Consumer', 'Corporate')
GROUP BY segment;


-- Q14: Phân cụm khách hàng nâng cao bằng mô hình RFM (Recency, Frequency, Monetary)
WITH rfm_base AS (
    SELECT 
        customer_id,
        DATEDIFF(day, MAX(order_date), '2026-01-01') AS recency_val,
        COUNT(DISTINCT order_id) AS frequency_val,
        SUM(profit) AS monetary_val -- Sử dụng Profit thay vì Revenue để tìm khách hàng "thực lời"
    FROM e_commerce.ecom_sales
    GROUP BY customer_id
),
rfm_scores AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY recency_val DESC) AS r_score, -- Mới mua gần đây điểm cao
        NTILE(5) OVER (ORDER BY frequency_val ASC) AS f_score, -- Mua nhiều lần điểm cao
        NTILE(5) OVER (ORDER BY monetary_val ASC) AS m_score   -- Mang lại nhiều lời điểm cao
    FROM rfm_base
)
SELECT 
    customer_id,
    recency_val, frequency_val, monetary_val,
    (r_score * 100 + f_score * 10 + m_score) AS rfm_cell,
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions (VIP)'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'New Customers'
        WHEN r_score <= 2 AND f_score >= 4 AND m_score >= 4 THEN 'VIP Churn Risk'
        WHEN r_score <= 1 AND f_score <= 1 THEN 'Lost'
        ELSE 'Regular'
    END AS customer_segmentation
FROM rfm_scores
ORDER BY monetary_val DESC;


-- Q15: Phân tích Giỏ hàng (Market Basket Analysis) - Tìm các sản phẩm thường xuyên được mua cùng nhau
WITH order_product_pairs AS (
    SELECT 
        s1.order_id,
        p1.product AS product_a,
        p2.product AS product_b
    FROM e_commerce.ecom_sales s1
    JOIN e_commerce.ecom_sales s2 ON s1.order_id = s2.order_id AND s1.product_code < s2.product_code
    JOIN e_commerce.product p1 ON s1.product_code = p1.product_code
    JOIN e_commerce.product p2 ON s2.product_code = p2.product_code
)
SELECT TOP 10
    product_a,
    product_b,
    COUNT(*) AS times_purchased_together
FROM order_product_pairs
GROUP BY product_a, product_b
ORDER BY times_purchased_together DESC;

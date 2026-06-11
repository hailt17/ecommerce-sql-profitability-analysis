# Key Insights

## 1. Data Understanding

The dataset contains 51,290 order lines, representing 25,728 unique orders and 17,415 customers. Since the sales table is at order-line level, order count must be calculated using `COUNT(DISTINCT order_id)` instead of `COUNT(*)`.

During the join quality check, all customer records were matched successfully. However, 2 sales records had unmatched product information and 2 records had unmatched region information. These were flagged as minor data quality issues before further analysis.

## 2. Overall Business Performance

The dataset generated total sales of 6,517,674 and total profit of 1,065,413.58, with an overall profit margin of 16.35%. The average discount was 14.29%.

## 3. Customer Segment Performance

Corporate customers generated the highest sales and profit, making them the main revenue driver. However, Corporate also had the lowest profit margin compared with Consumer and Self-Employed customers.

## 4. Product Category Performance

Body care was the strongest product category in terms of sales and profit. Face care achieved the highest profit margin despite having smaller sales volume. Home and Accessories generated strong sales but showed the lowest margin among major categories.

## 5. Discount Impact on Profitability

Discount level showed a clear negative relationship with profitability. No-discount orders achieved the highest profit margin at 31.30%, while high-discount orders generated 1.34M in sales but resulted in a loss of 295.7K, with a -22.02% profit margin.

## 6. High-Discount Loss Drivers

High-discount losses were concentrated in a small number of segment-category combinations. Corporate Body care was the largest loss driver, generating 393.7K in sales but losing 93.8K in profit with a -23.82% margin.

Corporate customers also appeared in multiple high-loss groups, especially in Body care, Home and Accessories, Hair care, and Make up. This suggests that discount policies for Corporate accounts should be reviewed first.

## 7. Customer-Level Profitability

Some high-sales customers generated negative profit, indicating that revenue volume alone is not sufficient to evaluate customer value. Several customers with sales above 5K had negative margins, suggesting the need to review discount levels, product mix, or customer-specific pricing.

Customer value segmentation helped classify customers into High Value, Medium Value, Low Value, and Loss Making groups.

## 8. Business Recommendations

1. Review high-discount campaigns, especially for Corporate customers.
2. Prioritize investigation of Corporate Body care, as it is the largest loss driver under high discount.
3. Avoid evaluating performance by sales alone; profit margin should be monitored together with sales.
4. Segment customers by value tier to separate profitable customers from loss-making customers.
5. Review product-category profitability before expanding discount campaigns.

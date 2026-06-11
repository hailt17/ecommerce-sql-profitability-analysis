# E-commerce Profitability & Customer Analysis using SQL

## Project Overview

This project analyzes an e-commerce sales dataset using SQL to evaluate business performance, profitability, discount impact, customer value, product performance, and regional/monthly trends.

The main objective is to identify key revenue drivers, detect profitability issues, and provide actionable recommendations based on customer segments, product categories, and discount levels.

## Dataset

The project uses the `e_commerce` dataset from XomData, including four main tables:

| Table | Description |
|---|---|
| `ecom_sales` | Order-line transaction data including order, customer, product, region, sales, discount, and profit |
| `customer` | Customer demographic information |
| `product` | Product details including product name and category |
| `region` | Region and market information |

The sales table is at **order-line level**, meaning one order can contain multiple product lines. Therefore, `COUNT(*)` measures order lines, while `COUNT(DISTINCT order_id)` measures actual orders.

## Tools Used

- SQL Server
- DBeaver
- XomData Dataset
- GitHub for portfolio documentation

## Key Analysis Areas

### Data Exploration
- Checked data granularity and table structure
- Checked duplicate keys in dimension tables
- Checked join quality and unmatched records

### KPI Overview
- Total order lines, orders, customers, sales, profit, profit margin, and average discount

### Segment and Category Performance
- Sales and profit by customer segment
- Sales and profit by product category
- Category-level margin comparison

### Profit and Discount Analysis
- Profitability by discount tier
- Category and segment profitability by discount tier
- High-discount loss drivers
- Loss priority classification

### Customer Analysis
- Top customers by sales
- High-sales customers with negative profit
- Customer value segmentation
- Customer tier performance by segment

### Product, Region, and Monthly Trend Analysis
- Top products by sales
- Products with high sales but negative profit
- Region-level performance
- Monthly sales and profit trends
- Monthly growth analysis

## SQL Files

| File | Description |
|---|---|
| `01_data_exploration.sql` | Data structure, key checks, and join quality checks |
| `02_kpi_overview.sql` | Overall KPI and segment/category performance |
| `03_profit_discount_analysis.sql` | Discount tier and profitability analysis |
| `04_customer_analysis.sql` | Customer-level sales, profit, and value segmentation |
| `05_product_analysis.sql` | Product and category performance |
| `06_region_monthly_analysis.sql` | Region and time-based performance analysis |

## Key Findings

- The dataset contains 51,290 order lines, 25,728 unique orders, and 17,415 customers.
- Total sales reached 6,517,674, with total profit of 1,065,413.58 and an overall profit margin of 16.35%.
- Corporate customers generated the highest sales and profit, but had lower margin than other segments.
- High-discount orders generated 1.34M in sales but resulted in a 295.7K loss, with a -22.02% profit margin.
- Corporate Body care was the largest high-discount loss driver, generating 393.7K in sales but losing 93.8K in profit.

## Business Recommendations

1. Review high-discount campaigns, especially for Corporate customers.
2. Prioritize investigation of Corporate Body care, as it is the largest loss driver under high discount.
3. Avoid evaluating performance by sales alone; profit margin should be monitored together with sales.
4. Segment customers by value tier to separate profitable customers from loss-making customers.
5. Review product-category profitability before expanding discount campaigns.

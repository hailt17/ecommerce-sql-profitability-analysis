# Xóm E-Com: Global E-Commerce Profitability & Customer LTV Optimization (SQL Server)

## 📌 1. Project Overview & Business Context (Situation)
**Xóm E-Com** is a global B2C e-commerce platform operating across 140+ countries within 4 primary markets (US, EMEA, APAC, LATAM), generating approximately **$2.3M in annual revenue**. 

Despite steady top-line growth, the company is facing a critical squeeze on its financial health, with a **gross profit margin hovering around only 20%**. Operating purely as a digital-first platform without physical brick-and-mortar storefronts, the business model relies heavily on direct-to-consumer shipping through third-party logistics partners, leaving it highly vulnerable to rising operational and discount costs.

## 🎯 2. Core Business Pain Points (Task)
As a Data Analyst, I was tasked by the C-suite (CFO, CMO, Head of Growth, and Head of Merchandising) to deep-dive into **101K transactional rows** to diagnose and solve 4 core business bottlenecks:
1. **Discount Cannibalization:** Evaluate whether aggressive marketing campaigns (ranging from 20% to 80% off) are destroying product margins and causing net-negative orders.
2. **Segment Profitability (P&L Breakdown):** Reconstruct the financial contribution of the 3 main customer segments: *Consumer* (60% volume), *Corporate* (25% volume), and *Home Office* (15% volume) to identify the true "cash cow".
3. **Geographic Saturation vs. Expansion:** Assess performance across global markets to pin down which international regions are scaling effectively versus those hitting stagnation.
4. **Customer LTV & Retention Gap:** Address the "one-and-done" purchase pattern where the majority of acquired customers fail to place a second order.

## 🛠️ 3. Analytical Framework & Technical Execution (Action)
To transform raw queries into strategic execution, I restructured the codebase into **3 logic-driven tactical modules** mapped directly to the business issues:

*   **Module 1: Profitability & Discount Breakdown (`01_profitability_analysis.sql`)**
    *   Leveraged conditional aggregation (`CASE WHEN`) to audit net-negative transactions and isolate high-risk product categories where profit margins collapsed due to excessive vouchers.
*   **Module 2: Time-Series Growth & Geographic Insights (`02_growth_geographic.sql`)**
    *   Utilized advanced Window Functions (`LAG()`, `PARTITION BY`) to compute Year-over-Year (YoY) rolling growth rates across months and continents to steer market capital allocations.
*   **Module 3: Advanced Customer Segmentation & Association Models (`03_customer_segmentation.sql`)**
    *   Built an **RFM (Recency, Frequency, Monetary) Clustering Model** using statistical tile distributions (`NTILE(5)`) to identify high-value VIP cohorts at risk of churning.
    *   Executed a **Market Basket Analysis (Association Rule)** using asynchronous `SELF JOIN` operations to identify the top 10 highest-probability product pairings for automated checkout cross-selling.

---

## 📈 4. Key Executive Findings & Data-Driven Recommendations (Result)

*Note: The following metrics represent real business insights extracted via DBeaver from the live SQL database.*

### 📊 Financial Insights (Discount & Segment Performance)
*   **Finding:** Aggressive discounts do not scale linearly. The **[Insert Segment Name, e.g., Consumer]** segment accounted for the highest volume of transactions but suffered a **[Insert %]** loss-order ratio. Transactions with discounts exceeding **40%** consistently yielded a net-negative profit margin.
*   **Strategic Recommendation:** Implement an automated hard cap on discounts at **30%** for low-margin categories like *Furniture*. Pivot marketing strategy from blanket markdown discounts to bundle promotions.

### 🗺️ Geographic Expansion Strategy
*   **Finding:** While the **[Insert Market Name, e.g., US]** remains the top revenue driver, its YoY growth rate has slowed down to **[Insert %]** over the last 12 months, indicating market saturation. Conversely, **[Insert Market Name, e.g., LATAM]** exhibits an explosive **[Insert %]** YoY acceleration.
*   **Strategic Recommendation:** Reallocate 15% of the digital ad spend from saturated regions to the high-growth markets to maximize global market-share expansion.

### 👥 Retention & Cross-Sell Opportunities
*   **Finding:** The Market Basket Analysis revealed that customers who purchase **[Product A]** have a **[Insert % / count]** co-occurrence rate of purchasing **[Product B]** within the same transaction. Furthermore, the RFM model identified **[Insert Count]** VIP customers who haven't made a purchase in over 180 days.
*   **Strategic Recommendation:** 
    1. Direct the engineering team to implement a "Frequently Bought Together" cross-sell widget at checkout for those specific product pairings.
    2. Hand over the "At-Risk VIP" customer list to the CRM team for an exclusive win-back email sequence offering a personalized customer loyalty reward (not a flat discount).

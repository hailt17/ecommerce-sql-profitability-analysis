# Xóm E-Com: Global B2C Market Profitability & Customer Retention Optimization (SQL Server)

## 📌 1. Project Overview & Business Context (Situation)
**Xóm E-Com** is a global B2C e-commerce platform operating across 140+ countries within 4 primary markets (Europe, USCA, LATAM, Africa, Asia Pacific), generating **$6,517,674.00 in total revenue**. 

Despite strong top-line sales, the company's bottom-line health is constrained, with a **gross profit margin of only 16.35%** ($1,065,413.58 net profit). Operating purely via localized logistics networks and third-party fulfillment without physical brick-and-mortar storefronts, the business model is highly sensitive to rising promotional markdown expenses and fluctuating geographic cost structures.

## 🎯 2. Core Business Pain Points (Task)
As a Lead Data Analyst, I conducted a comprehensive diagnostic audit of **101,000+ transactional rows** to mitigate 4 systemic organizational bottlenecks:
1. **Discount Cannibalization:** Assess if aggressive marketing markdowns (vouchers spanning 20% to 80%) are destroying unit-economics and generating net-negative orders.
2. **Segment Profitability Re-engineering:** Build an accurate P&L by customer type to identify the true "cash cow" between *Corporate*, *Consumer*, and *Self-Employed*.
3. **Geographic Saturation vs. Expansion Growth:** Map multi-national revenue velocity to identify high-efficiency scaling zones versus stagnant regions.
4. **Customer LTV & Retention Gap:** Diagnose the "one-and-done" buyer behavioral trend to retain at-risk VIP buyers and establish cross-selling triggers.

## 🛠️ 3. Analytical Framework & Technical Execution (Action)
I engineered a clean, scalable SQL script depository divided into 3 strategic analysis campaigns:

* **Module 1: Profitability & Discount Breakdown (`01_profitability_analysis.sql`)**
    * Leveraged conditional aggregation (`CASE WHEN`) to audit net-negative transactions and isolate macro-level segment margins.
* **Module 2: Time-Series Growth & Geographic Insights (`02_growth_geographic.sql`)**
    * Utilized advanced analytic Window Functions (`LAG() OVER`) to establish monthly rolling Year-over-Year (YoY) revenue trajectories.
* **Module 3: Customer Lifecycle RFM Analytics & Cross-Sell Models (`03_customer_segmentation.sql`)**
    * Built an **RFM (Recency, Frequency, Monetary)** grouping matrix via row distribution tiles (`NTILE(5)`) tied directly to localized customer demographic behavior.
    * Executed an algorithmic **Market Basket Analysis (Association Rule)** using asynchronous database `SELF JOIN` models to evaluate purchase co-occurrence patterns.

---

## 📈 4. Key Executive Findings & Data-Driven Recommendations (Result)

### 📊 Theme 1: Financial Performance & Discount Cannibalization Audit
* **The "Volume vs. Margin" Illusion:** The *Corporate* segment drives the highest top-line volume (**$3,840,707.00** in sales), yet yields the lowest profit margin (**15.84%**). *Self-Employed* is our most efficient bucket with a **17.26%** margin.
* **Definitive Proof of Cannibalization:** Across all buyer types, an alarming **26% to 27% of all processed orders are leaking cash and running at a net loss** (e.g., Corporate: 2,096 loss orders; Consumer: 3,584 loss orders). The baseline root cause is proven: unprofitable transactions carry a massive average discount of **45.5%**, confirming marketing campaigns are actively burning capital.
* **Product Performance:** Within the dominant *Body care* category, *"Herbal Essences Bio"* is our primary anchor SKU, generating a substantial **$9,089.67** in standalone net profit.

### 🗺️ Theme 2: Geographic Expansion & Monthly YoY Velocities
* **Core Revenue Densities:** The *United States* remains our primary financial pillar (**$1,326,577.00** in revenue, 2,501 unique buyers), followed by *Australia* ($381,404.00) and *France* ($374,791.00).
* **Market Saturation vs. Health:** Time-series analysis confirms strong year-end operational momentum in 2023, with Q4 showing prominent YoY expansions: October (**+39.38%**), November (**+38.12%**), and December (**+29.05%**). However, July 2023 suffered an explicit contraction (**-4.83%** YoY), indicating a seasonal structural slowdown.
* **Geographic Margins:** *Europe* stands out as the most capital-efficient continent with a premium **22.30%** profit margin, whereas *Asia Pacific* dilutes overall platform profitability with an underperforming **12.48%** margin.

### 👥 Theme 3: Customer Demographic Retention & Market Basket Behavior
* **Demographic Profile:** Platform users are dominated by high-income office workers, led by *Female Professionals* (2,626 unique users) and *Male Professionals* (2,517 unique users).
* **At-Risk VIP Risk Profiles:** The RFM scoring architecture successfully identified high-value profiles currently stagnant. For instance, Customer `MY-1829527` has contributed **$2,165.00** in historical profit but has an RFM score of `155` (Recency group 1), indicating zero activity in over **1,787 days** (approx. 4.9 years).
* **Basket Co-occurrence Rules:** The cross-sell matrix exposed a prominent attachment trend: *"Herbal Essences Bio"* and *"Essie Nail Polish Aruba Blue Shimmering Cobalt"* have the highest statistical pairing with **4 distinct co-purchases**, followed closely by specialized rings and cosmetic lines.

---

## 🚀 5. Data-Driven Strategic Recommendations

1.  **Promotional Markdown Policy Reform:** Immediately establish an automated system hard-cap on multi-voucher checkouts at a maximum of **30%**. Data proves any discount scale beyond 40% triggers immediate unit-economic loss across all categories.
2.  **Regional Budgetary Reallocation:** Shift 15% of active paid acquisition marketing budgets away from low-margin *Asia Pacific* channels (12.48% margin) and re-route them into high-yielding *European* channels (22.30% margin) to maximize profit optimization per dollar spent.
3.  **Algorithmic Cross-Sell Triggers:** Instruct the engineering team to embed an automated product recommendation widget at checkout. Target high-probability pairs (e.g., prompting *Essie Nail Polish* immediately when *Herbal Essences Bio* is added to the user cart).
4.  **Targeted Re-engagement Loops:** Export the compiled list of high-margin **"VIP Churn Risk"** accounts (such as `MY-1829527`) to the CRM team. Deploy an exclusive win-back email workflow prioritizing value-adds and bundle points rather than utilizing toxic, flat-rate markdowns.

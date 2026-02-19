-- ============================================
-- Retail Sales Analysis
-- Phase 3: KPI & Business Performance Analysis
-- ============================================

USE retail_sales_analysis;

-- ============================================
-- 1️. Overall Business KPIs
-- ============================================

-- Total Sales, Profit, Orders, Customers

SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_percentage
FROM orders;

-- ============================================
-- 2️. Sales by Region
-- ============================================

SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_pct
FROM orders
GROUP BY region
ORDER BY total_sales DESC;

-- ============================================
-- 3️. Sales by Category & Sub-Category
-- ============================================

SELECT
    category,
    sub_category,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY category, sub_category
ORDER BY total_sales DESC;

-- ============================================
-- 4️. Top 10 Most Profitable Products
-- ============================================

SELECT
    product_name,
    ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;


-- ============================================
-- 5️. Top 10 Loss-Making Products
-- ============================================

SELECT
    product_name,
    ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY product_name
ORDER BY total_profit ASC
LIMIT 10;


-- ============================================
-- 6️. Monthly Sales Trend
-- ============================================

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    ROUND(SUM(sales),2) AS monthly_sales,
    ROUND(SUM(profit),2) AS monthly_profit
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;
    
-- ============================================
-- 7️. Yearly Sales Growth
-- ============================================

WITH yearly_data AS (
    SELECT
        YEAR(order_date) AS order_year,
        SUM(sales) AS yearly_sales
    FROM orders
    GROUP BY YEAR(order_date)
)

SELECT
    order_year,
    ROUND(yearly_sales,2) AS yearly_sales,
    ROUND(
        (yearly_sales - LAG(yearly_sales) 
            OVER (ORDER BY order_year))
        / LAG(yearly_sales) 
            OVER (ORDER BY order_year) * 100,
        2
    ) AS yoy_growth_percentage
FROM yearly_data;

-- ============================================
-- 8️. Segment Performance
-- ============================================

SELECT
    segment,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit,
    ROUND((SUM(profit)/SUM(sales))*100,2) AS profit_margin_pct
FROM orders
GROUP BY segment
ORDER BY total_sales DESC;


-- ============================================
-- 9️. Discount Impact on Profit
-- ============================================

SELECT
    discount,
    ROUND(AVG(profit),2) AS avg_profit,
    COUNT(*) AS total_orders
FROM orders
GROUP BY discount
ORDER BY discount;

-- ============================================
-- 10. Average Shipping Time (Operational KPI)
-- ============================================

SELECT
    ROUND(AVG(DATEDIFF(ship_date, order_date)),2) AS avg_shipping_days
FROM orders;

-- ============================================
-- Phase 3 Completed
-- Business KPIs Generated Successfully
-- ============================================

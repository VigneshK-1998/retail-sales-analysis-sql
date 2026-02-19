-- ============================================
-- Retail Sales Analysis
-- Phase 2: Data Validation & Quality Checks
-- ============================================

-- Total number of records

SELECT COUNT(*) AS total_records
FROM orders;

-- Null value check for important columns

SELECT 
    SUM(CASE
        WHEN order_id IS NULL THEN 1
        ELSE 0
    END) AS null_order_id,
    SUM(CASE
        WHEN order_date IS NULL THEN 1
        ELSE 0
    END) AS null_order_date,
    SUM(CASE
        WHEN sales IS NULL THEN 1
        ELSE 0
    END) AS null_sales,
    SUM(CASE
        WHEN profit IS NULL THEN 1
        ELSE 0
    END) AS null_profit,
    SUM(CASE
        WHEN quantity IS NULL THEN 1
        ELSE 0
    END) AS null_quantity
FROM
    orders;	

-- Future date validation
SELECT *
FROM orders
WHERE order_date > CURRENT_DATE();

-- Order date range validation

SELECT 
    MIN(order_date) AS earliest_order,
    MAX(order_date) AS latest_order
FROM orders;
    
-- Zero or negative sales validation
-- Note: Zero sales may indicate returned or cancelled orders
SELECT *
FROM orders
WHERE sales <= 0;

-- Invalid quantity check
SELECT *
FROM orders
WHERE quantity <= 0;

-- Orders shipped before order date (logical error check)
SELECT *
FROM orders
WHERE ship_date < order_date;

-- Verify unique categories
SELECT DISTINCT category
FROM orders;

-- Verify unique sub-categories
SELECT DISTINCT sub_category
FROM orders;

-- Highest and lowest sales values
SELECT 
    MAX(sales) AS max_sales,
    MIN(sales) AS min_sales,
    AVG(sales) AS avg_sales
FROM orders;

-- Negative profit check
SELECT *
FROM orders
WHERE profit < 0;

-- Negative profits identified

-- Negative profit percentage

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE
        WHEN profit < 0 THEN 1
        ELSE 0
    END) AS negative_profit_records,
    ROUND((SUM(CASE
                WHEN profit < 0 THEN 1
                ELSE 0
            END) / COUNT(*)) * 100,
            2) AS negative_profit_percentage
FROM
    orders;
    
-- Analyze relationship between discount and average profit

SELECT 
    discount,
    ROUND(AVG(profit),2) AS avg_profit,
    COUNT(*) AS transaction_count
FROM orders
GROUP BY discount
ORDER BY discount DESC;

-- Root cause of negative profits -> Loss Sales count

SELECT 
    discount,
    COUNT(*) AS loss_count
FROM orders
WHERE profit < 0
GROUP BY discount
ORDER BY discount DESC;

-- Total profit per category

SELECT 
    category,
    ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY category
ORDER BY total_profit;

-- Duplicate entries validation -> All key fields duplicated except for row_id

SELECT 
    order_id,
    product_id,
    order_date,
    ship_date,
    customer_id,
    sales,
    quantity,
    discount,
    profit,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY 
    order_id,
    product_id,
    order_date,
    ship_date,
    customer_id,
    sales,
    quantity,
    discount,
    profit
HAVING COUNT(*) > 1;

-- Minimum row_id with duplicated record to be kept and Maximum row_id to be deleted

SELECT MIN(row_id) AS keep_id,
       MAX(row_id) AS delete_id
FROM orders
GROUP BY 
    order_id,
    product_id,
    sales,
    quantity,
    discount,
    profit
HAVING COUNT(*) > 1;

-- Remove duplicated entries from orders table

DELETE FROM orders 
WHERE
    row_id IN (SELECT 
        delete_id
    FROM
        (SELECT 
            MAX(row_id) AS delete_id
        FROM
            orders
        GROUP BY order_id , product_id , sales , quantity , discount , profit
        HAVING COUNT(*) > 1) AS duplicates);

-- Record count after duplicate removal

SELECT COUNT(*) AS final_record_count
FROM orders;

-- ============================================
-- Phase 2 Completed
-- Data validated for:
-- 1. Null values
-- 2. Duplicate records
-- 3. Logical date consistency
-- 4. Negative & abnormal values
-- 5. Profitability distribution
-- ============================================
-- ============================================
-- Retail Sales Analysis
-- Phase 2: Data Cleaning & Transformation
-- ============================================

USE retail_sales_analysis;

-- ============================================
-- Step 1: Inspect Raw Date Formats
-- ============================================

SELECT 
    order_date,
    LENGTH(order_date) AS len_order,
    ship_date,
    LENGTH(ship_date) AS len_ship
FROM orders
LIMIT 100;

-- ============================================
-- Step 2: Add Clean Date Columns
-- ============================================

ALTER TABLE orders
ADD COLUMN order_date_clean DATE,
ADD COLUMN ship_date_clean DATE;

-- ============================================
-- Step 3: Preview Date Conversion Logic
-- Handles both MM/DD/YYYY and MM-DD-YYYY formats
-- ============================================

SELECT 
    order_date,
    ship_date,

    CASE 
        WHEN order_date LIKE '%/%'
            THEN STR_TO_DATE(order_date, '%m/%d/%Y')
        WHEN order_date LIKE '%-%'
            THEN STR_TO_DATE(order_date, '%m-%d-%Y')
        ELSE NULL
    END AS converted_order_date,

    CASE
        WHEN ship_date LIKE '%/%'
            THEN STR_TO_DATE(ship_date, '%m/%d/%Y')
        WHEN ship_date LIKE '%-%'
            THEN STR_TO_DATE(ship_date, '%m-%d-%Y')
        ELSE NULL
    END AS converted_ship_date

FROM orders
LIMIT 100;

-- ============================================
-- Step 4: Update Clean Date Columns
-- ============================================

SET SQL_SAFE_UPDATES = 0;

UPDATE orders 
SET 
    order_date_clean = CASE
        WHEN order_date LIKE '%/%'
            THEN STR_TO_DATE(order_date, '%m/%d/%Y')
        WHEN order_date LIKE '%-%'
            THEN STR_TO_DATE(order_date, '%m-%d-%Y')
        ELSE NULL
    END,

    ship_date_clean = CASE
        WHEN ship_date LIKE '%/%'
            THEN STR_TO_DATE(ship_date, '%m/%d/%Y')
        WHEN ship_date LIKE '%-%'
            THEN STR_TO_DATE(ship_date, '%m-%d-%Y')
        ELSE NULL
    END;

SET SQL_SAFE_UPDATES = 1;

-- ============================================
-- Step 5: Remove Raw Date Columns
-- ============================================

ALTER TABLE orders
DROP COLUMN order_date,
DROP COLUMN ship_date;

-- ============================================
-- Step 6: Rename Clean Columns & Reorder
-- ============================================

ALTER TABLE orders
CHANGE COLUMN order_date_clean order_date DATE AFTER order_id,
CHANGE COLUMN ship_date_clean ship_date DATE AFTER order_date;

-- ============================================
-- Final Verification
-- ============================================

SELECT *
FROM orders
LIMIT 20;

-- ============================================
-- End of Data Cleaning Phase
-- ============================================
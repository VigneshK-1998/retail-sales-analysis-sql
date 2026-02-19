-- ============================================
-- Retail Sales Analysis
-- Phase 1: Database & Table Schema Creation
-- ============================================

-- Create database
CREATE DATABASE IF NOT EXISTS retail_sales_analysis;

-- Use database
USE retail_sales_analysis;

-- ============================================
-- Create Orders Table (Raw Structure)
-- Dates initially stored as VARCHAR for cleaning
-- ============================================

CREATE TABLE IF NOT EXISTS orders
(
    row_id INT PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    order_date VARCHAR(20) NOT NULL,     -- Raw date (to be cleaned)
    ship_date VARCHAR(20),               -- Raw date (to be cleaned)
    ship_mode VARCHAR(20),
    customer_id VARCHAR(50) NOT NULL,
    customer_name VARCHAR(50) NOT NULL,
    segment VARCHAR(20),
    country VARCHAR(20),
    city VARCHAR(20),
    state VARCHAR(20),
    postal_code VARCHAR(20),
    region VARCHAR(20),
    product_id VARCHAR(20) NOT NULL,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(150),
    sales DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    discount DECIMAL(10,2),
    profit DECIMAL(10,2)
);

-- ============================================
-- End of Schema Creation
-- ============================================

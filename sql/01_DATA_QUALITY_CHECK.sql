-- ============================================
-- Data Quality Checks
-- Author: Abizar Huseni
-- Date: 2026-05-21
-- ============================================

USE olist;
-- Checking for NULLs in critical columns of orders table
-- order_purchase_timestamp and order_delivered_customer_date are essential
-- for revenue analysis and RFM segmentation (recency calculation)

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS null_purchase_date,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS null_delivered_date
FROM orders;

-- Result: 0 null purchase dates, 2965 null delivery dates


-- CHECKING FOR NULL DELIVERY DATES IN WHAT ORDER STATUS
SELECT order_status, COUNT(*) AS NULL_DELIVERY_DATES
FROM orders
WHERE order_delivered_customer_date IS NULL
GROUP BY order_status

-- Result: NULL delivery dates are from non-delivered orders
-- shipped (1107), canceled (619), unavailable (609), invoiced (314),
-- processing (301), delivered (8), created (5), approved (2)
-- These are legitimate — not data errors. Only 8 "delivered" rows are actual issues.




-- checking how many delivered orders do we have and what's the date range?

SELECT COUNT(*) AS total_delivered,
MIN(order_purchase_timestamp) AS earliest_date,
MAX(order_purchase_timestamp) AS latest_date
FROM orders
WHERE order_status = 'delivered'

-- Result: 96,478 delivered orders from Sept 2016 to Aug 2018
-- Will trim to Jan 2017 - Aug 2018 for clean monthly analysis


--  NULL checks on order_items and order_payments

 SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS null_freight_value
FROM order_items;

 SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS null_payment_value,
    SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS null_payment_type
FROM order_payments;

-- Result: order_items — 112,650 rows, 0 NULLs in price or freight_value
-- Result: order_payments — 103,886 rows, 0 NULLs in payment_value or payment_type




--how many times a person bought

SELECT 
    COUNT(customer_id) as customer_id,
    COUNT(DISTINCT customer_id) AS DISTINCT_CUSTOMER_ID,
    COUNT(DISTINCT customer_unique_id) AS CUSTOMER_UNIQUE_ID
FROM customers

-- Result: 99,441 customer_id but only 96,096 customer_unique_id
-- ~3,345 customers placed more than one order with different customer_ids
-- Must use customer_unique_id for RFM segmentation, not customer_id

   



   
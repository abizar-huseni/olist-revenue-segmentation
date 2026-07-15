USE OLIST 

------------------------------------------
--- DATE 15-6-2026 
--- AUTHOR : ABIZAR HUSENI 
--- REVENUE ANALYSIS 
------------------------------------------

-- What's the overall picture of Olist's delivered orders?
-- Ineed to find four numbers in one query:

-- Total number of delivered orders
-- Total number of unique customers (which ID do you use?)
-- Total revenue (revenue = price + freight_value from order_items)
-- Average order value


SELECT 
	COUNT(DISTINCT o.order_id) AS TOTAL_ORDERS,
	COUNT(DISTINCT c.customer_unique_id) AS TOTAL_CUSTOMERS,
	ROUND (SUM(ot.price + ot.freight_value),2) as TOTAL_REVENUE,
	ROUND (SUM(ot.price + ot.freight_value) / COUNT(DISTINCT o.order_id),2) AS AVERAGE_ORDER_VALUE 
FROM orders AS o
JOIN order_items AS ot ON o.order_id = ot.order_id
JOIN customers AS c ON o.customer_id = c.customer_id 
WHERE order_status = 'delivered';

-- Result: 96,478 delivered orders from 93,358 unique customers
-- Total revenue: R$15,419,773.75 (Brazilian Reais)
-- Average order value: R$159.83
-- Most customers ordered only once (96K orders from 93K customers)
--------------------------------------------------------------------------------------------------------------------------------------------------

-- NEXT BUSINESS QUESTION
--How did Olist's revenue change month by month? Are there growth trends or seasonal patterns?

--Year and month of each order
--Total revenue for that month
--Total number of orders for that month

SELECT
	ROUND(SUM(ot.price + ot.freight_value), 2) AS TOTAL_REVENUE,
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
	COUNT(DISTINCT o.order_id) AS TOTAL_ORDERS
FROM orders AS o
JOIN order_items as ot ON o.order_id = ot.order_id
WHERE o.order_status = 'delivered'
AND o.order_purchase_timestamp >= '2017-01-01'
AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp)
ORDER BY order_year ASC,
		order_month ;


-- Result: Strong growth in 2017 (R$127K Jan → R$1.15M Nov, 9x increase)
-- Nov 2017 peak = Black Friday effect
-- 2018 revenue plateaued around R$1M/month, growth stalled
-- Trimmed to Jan 2017 - Aug 2018 to remove sparse 2016 data

--------------------------------------------------------------------------------------------------------------------

-- Revenue by Customer State--
-- Which Brazilian states generate the most revenue? Is it concentrated or spread out?
-- Needed

--Customer state from the customers table
--Revenue from order_items
--Filtered to delivered orders from orders
--That means a three-table JOIN — same as your revenue overview query

SELECT 
	c.customer_state,
	ROUND(SUM(ot.price + ot.freight_value), 2) AS TOTAL_REVENUE,
	COUNT(DISTINCT o.order_id) AS TOTAL_ORDERS
FROM orders AS o
JOIN order_items as ot ON o.order_id = ot.order_id
JOIN customers AS c ON o.customer_id = c.customer_id 
WHERE o.order_status = 'delivered'
AND o.order_purchase_timestamp >= '2017-01-01'
AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY c.customer_state
ORDER BY TOTAL_REVENUE DESC


-- Result: SP dominates with R$5.76M (37% of total revenue), 40K orders
-- Top 3 states (SP, RJ, MG) account for ~62% of revenue
-- Heavy geographic concentration = business risk
-- Opportunity: large population states like BA, CE, PE are underserved
-- Recommendation: pilot marketing campaigns in northeast Brazil to diversify

---------------------------------------------------------------------------------------------------------------------------------------------------------------

--Revenue by Product Category
--Business question: Which product categories generate the most revenue? Which are high-value vs high-volume?


SELECT * 
FROM category_translation

SELECT 
	TOP 15
	ct.product_category_name_english,
	ROUND(SUM(ot.price + ot.freight_value), 2) AS TOTAL_REVENUE,
	COUNT(DISTINCT o.order_id) AS total_orders
FROM orders AS o
JOIN order_items as ot ON o.order_id = ot.order_id
JOIN products as p ON ot.product_id = p.product_id
JOIN category_translation as ct ON p.product_category_name = ct.product_category_name
WHERE o.order_status = 'delivered'
AND o.order_purchase_timestamp >= '2017-01-01'
AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY ct.product_category_name_english
ORDER BY TOTAL_REVENUE DESC

-- Result: health_beauty leads at R$1.41M (8,610 orders)
-- watches_gifts is high-value: R$1.26M from only 5,491 orders (avg ~R$230/order)
-- bed_bath_table is high-volume: 9,267 orders but avg ~R$132/order
-- Top 5 categories generate ~40% of total revenue
-- Recommendation: promote high-value categories (watches, computers)
-- and bundle low-value high-volume categories to increase basket size

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

select * from order_payments
--Revuenue by payments Method 
-- How do customers pay, and does payment method affect order value?


SELECT
	ROUND(SUM(ot.price + ot.freight_value), 2) AS TOTAL_REVENUE,
	COUNT(DISTINCT o.order_id) AS TOTAL_ORDERS,
	op.payment_type AS PAYMENT_TYPES
FROM orders AS o
JOIN order_items as ot ON o.order_id = ot.order_id
JOIN order_payments as op on o.order_id = op.order_id
WHERE o.order_status = 'delivered'
AND o.order_purchase_timestamp >= '2017-01-01'
AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY op.payment_type
ORDER BY TOTAL_REVENUE DESC;


-- Result: credit_card dominates at R$12.3M (77% of revenue, 74K orders)
-- boleto is second at R$2.76M (17%) — significant unbanked customer base
-- voucher has highest avg order value (~R$205) despite low volume
-- debit_card is minimal at R$208K (1.3%)
-- Recommendation: boleto's 17% share shows a large unbanked segment
-- Offer boleto-specific promotions to grow this underserved market

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Customer Purchase Behaviour
-- Business question: How many customers buy once vs multiple times? How much revenue comes from each group?

SELECT 
    order_count,
    COUNT(*) AS number_of_customers
FROM (
    -- your previous query goes here
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM orders AS o
    JOIN customers AS c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp >= '2017-01-01'
    AND o.order_purchase_timestamp < '2018-09-01'
    GROUP BY c.customer_unique_id
) AS customer_orders
GROUP BY order_count
ORDER BY order_count



-- Result: 90,315 customers (97%) bought only once — massive retention problem
-- Only 2,562 (2.7%) came back for a second order
-- Olist is spending money acquiring customers who never return
-- This means growth depends entirely on new customer acquisition, which is expensive
-- Recommendation: 
--   1. Launch a post-purchase email sequence targeting first-time buyers within 30 days
--   2. Offer a 10-15% discount code on the second purchase to drive repeat orders
--   3. Focus RFM segmentation on identifying the 2,562 repeat buyers — 
--      understand what made THEM come back and replicate it


------------------------------------------------------------------------------------------------------------------------------------------------------------------------



	
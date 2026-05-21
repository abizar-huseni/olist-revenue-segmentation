-- ====================================

-- DATE 2026-05-21

-- AUTHOR: ABIZAR HUSENI 

-- TABLE SETUP 

USE olist

-- Renaming tables for consistency
-- Original names had brackets, prefixes, and inconsistent formatting
-- Standardizing to clean lowercase with underscores

EXEC sp_rename 'olist_customers_dataset', 'customers';
EXEC sp_rename '[order items]', 'order_items';
EXEC sp_rename '[order payment]', 'order_payments';
EXEC sp_rename '[order reviews]', 'order_reviews';
EXEC sp_rename 'product_category_name_translation', 'category_translation';

-- =====================================

-- Verify all tables are renamed correctly
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
-- 01_data_quality.sql — MySQL 8+
USE olist_ecommerce;

-- Import the Olist CSVs as tables with their base filenames (without .csv).
SELECT 'orders' table_name, COUNT(*) row_count FROM olist_orders_dataset
UNION ALL SELECT 'customers', COUNT(*) FROM olist_customers_dataset
UNION ALL SELECT 'order_items', COUNT(*) FROM olist_order_items_dataset
UNION ALL SELECT 'products', COUNT(*) FROM olist_products_dataset
UNION ALL SELECT 'sellers', COUNT(*) FROM olist_sellers_dataset
UNION ALL SELECT 'payments', COUNT(*) FROM olist_order_payments_dataset
UNION ALL SELECT 'reviews', COUNT(*) FROM olist_order_reviews_dataset
UNION ALL SELECT 'geolocation', COUNT(*) FROM olist_geolocation_dataset
UNION ALL SELECT 'category_translation', COUNT(*) FROM product_category_name_translation;

SELECT COUNT(*) total_rows, COUNT(DISTINCT order_id) unique_orders,
       COUNT(*)-COUNT(DISTINCT order_id) duplicate_order_rows
FROM olist_orders_dataset;

SELECT COUNT(*) total_item_rows,
       COUNT(DISTINCT CONCAT(order_id, '-', order_item_id)) unique_item_keys,
       COUNT(*)-COUNT(DISTINCT CONCAT(order_id, '-', order_item_id)) duplicate_item_keys
FROM olist_order_items_dataset;

SELECT SUM(order_purchase_timestamp IS NULL) missing_purchase_timestamp,
       SUM(order_delivered_customer_date IS NULL) missing_actual_delivery,
       SUM(order_estimated_delivery_date IS NULL) missing_estimated_delivery
FROM olist_orders_dataset;

SELECT order_status, COUNT(*) orders,
       ROUND(100.0*COUNT(*)/(SELECT COUNT(*) FROM olist_orders_dataset),2) pct_all_orders
FROM olist_orders_dataset GROUP BY order_status ORDER BY orders DESC;

SELECT COUNT(*) customer_rows, COUNT(DISTINCT customer_id) unique_customer_ids,
       COUNT(DISTINCT customer_unique_id) unique_people
FROM olist_customers_dataset;

SELECT SUM(i.product_id IS NOT NULL AND p.product_id IS NULL) missing_product_refs,
       SUM(i.seller_id IS NOT NULL AND s.seller_id IS NULL) missing_seller_refs
FROM olist_order_items_dataset i
LEFT JOIN olist_products_dataset p ON i.product_id=p.product_id
LEFT JOIN olist_sellers_dataset s ON i.seller_id=s.seller_id;

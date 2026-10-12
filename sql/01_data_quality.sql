-- Olist E-Commerce Analytics
-- 01 - Data Quality Checks
-- MySQL 8+

USE olist_ecommerce;

-- Expected full-dataset tables:
-- customers, orders, order_items, order_payments, order_reviews,
-- products, sellers, geolocation, product_category_name_translation

SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT order_id) AS unique_orders,
       COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_order_rows
FROM orders;

SELECT order_status, COUNT(*) AS orders
FROM orders
GROUP BY order_status
ORDER BY orders DESC;

SELECT
    SUM(order_purchase_timestamp IS NULL) AS null_purchase_timestamp,
    SUM(order_approved_at IS NULL) AS null_approved_at,
    SUM(order_delivered_carrier_date IS NULL) AS null_carrier_date,
    SUM(order_delivered_customer_date IS NULL) AS null_customer_delivery,
    SUM(order_estimated_delivery_date IS NULL) AS null_estimated_delivery
FROM orders;

SELECT COUNT(*) AS invalid_timestamp_sequences
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_approved_at < order_purchase_timestamp;

SELECT COUNT(*) AS invalid_delivery_sequences
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date;

SELECT COUNT(*) AS order_rows,
       SUM(c.customer_id IS NULL) AS missing_customer_dimension_rows
FROM orders o
LEFT JOIN customers c ON c.customer_id = o.customer_id;

SELECT COUNT(*) AS order_item_rows,
       COUNT(DISTINCT oi.order_id) AS orders_with_items,
       SUM(o.order_id IS NULL) AS orphan_order_items
FROM order_items oi
LEFT JOIN orders o ON o.order_id = oi.order_id;

SELECT COUNT(*) AS payment_rows,
       COUNT(DISTINCT op.order_id) AS orders_with_payments,
       SUM(o.order_id IS NULL) AS orphan_payments
FROM order_payments op
LEFT JOIN orders o ON o.order_id = op.order_id;

SELECT COUNT(*) AS review_rows,
       COUNT(DISTINCT r.order_id) AS reviewed_orders,
       SUM(o.order_id IS NULL) AS orphan_reviews
FROM order_reviews r
LEFT JOIN orders o ON o.order_id = r.order_id;

SELECT SUM(p.product_id IS NULL) AS orphan_product_items,
       SUM(s.seller_id IS NULL) AS orphan_seller_items
FROM order_items oi
LEFT JOIN products p ON p.product_id = oi.product_id
LEFT JOIN sellers s ON s.seller_id = oi.seller_id;

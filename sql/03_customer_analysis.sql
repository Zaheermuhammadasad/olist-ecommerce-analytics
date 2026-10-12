-- Olist E-Commerce Analytics
-- 03 - Customer Analysis
-- MySQL 8+

USE olist_ecommerce;

-- 1. Customer order frequency
SELECT
    customer_unique_id,
    COUNT(DISTINCT order_id) AS orders,
    MIN(order_purchase_timestamp) AS first_order,
    MAX(order_purchase_timestamp) AS last_order
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY customer_unique_id
ORDER BY orders DESC, last_order DESC;

-- 2. Repeat-customer rate
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS orders
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS customers,
    SUM(CASE WHEN orders = 1 THEN 1 ELSE 0 END) AS one_time_customers,
    SUM(CASE WHEN orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(100.0 * SUM(CASE WHEN orders > 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS repeat_customer_pct
FROM customer_orders;

-- 3. Top customers by GMV
WITH customer_order_value AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY c.customer_unique_id, o.order_id
)
SELECT
    customer_unique_id,
    COUNT(*) AS orders,
    ROUND(SUM(order_value), 2) AS customer_gmv,
    ROUND(AVG(order_value), 2) AS avg_order_value
FROM customer_order_value
GROUP BY customer_unique_id
ORDER BY customer_gmv DESC
LIMIT 25;

-- 4. Customer state performance
SELECT
    c.customer_state,
    COUNT(DISTINCT c.customer_unique_id) AS customers,
    COUNT(DISTINCT o.order_id) AS orders
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY orders DESC;

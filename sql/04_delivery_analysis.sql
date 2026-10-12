-- Olist E-Commerce Analytics
-- 04 - Delivery & Operations Analysis
-- MySQL 8+

USE olist_ecommerce;

-- 1. Overall order-status distribution
SELECT
    order_status,
    COUNT(*) AS orders,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_orders
FROM orders
GROUP BY order_status
ORDER BY orders DESC;

-- 2. Delivered-order performance
SELECT
    COUNT(*) AS delivered_orders,
    SUM(CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1 ELSE 0 END) AS on_time_orders,
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_orders,
    ROUND(100.0 * SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) / COUNT(*), 2) AS late_pct
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

-- 3. Yearly delivery performance
SELECT
    YEAR(order_purchase_timestamp) AS year,
    COUNT(*) AS delivered_orders,
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_orders,
    ROUND(100.0 * SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) / COUNT(*), 2) AS late_pct,
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date)), 2) AS avg_days_vs_estimated
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY year;

-- 4. Delivery delay buckets
WITH delivered AS (
    SELECT
        order_id,
        DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) AS days_late
    FROM orders
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
      AND order_estimated_delivery_date IS NOT NULL
)
SELECT
    CASE
        WHEN days_late <= 0 THEN 'On time or early'
        WHEN days_late BETWEEN 1 AND 7 THEN '1-7 days late'
        WHEN days_late BETWEEN 8 AND 14 THEN '8-14 days late'
        WHEN days_late BETWEEN 15 AND 30 THEN '15-30 days late'
        ELSE 'More than 30 days late'
    END AS delay_bucket,
    COUNT(*) AS orders
FROM delivered
GROUP BY delay_bucket
ORDER BY FIELD(delay_bucket, 'On time or early', '1-7 days late', '8-14 days late', '15-30 days late', 'More than 30 days late');

-- 5. Late delivery by customer state
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_orders,
    ROUND(100.0 * SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) / COUNT(DISTINCT o.order_id), 2) AS late_pct
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY late_pct DESC;

-- 6. Reconciliation check: delivered orders and late orders at the same grain
SELECT
    COUNT(DISTINCT order_id) AS delivered_orders,
    COUNT(DISTINCT CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN order_id END) AS late_orders,
    COUNT(DISTINCT CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN order_id END) AS on_time_or_early_orders
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

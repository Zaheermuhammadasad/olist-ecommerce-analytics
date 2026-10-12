-- Olist E-Commerce Analytics
-- 02 - Sales Analysis
-- MySQL 8+

USE olist_ecommerce;

-- 1. Orders by month
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(*) AS orders
FROM orders
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY month;

-- 2. GMV and AOV by month
-- Revenue is calculated from item price + freight, using order-level aggregation first.
WITH order_value AS (
    SELECT
        oi.order_id,
        SUM(oi.price + oi.freight_value) AS order_value
    FROM order_items oi
    GROUP BY oi.order_id
)
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(*) AS orders,
    ROUND(SUM(COALESCE(ov.order_value, 0)), 2) AS gmv,
    ROUND(SUM(COALESCE(ov.order_value, 0)) / COUNT(*), 2) AS aov
FROM orders o
LEFT JOIN order_value ov ON ov.order_id = o.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY month;

-- 3. Yearly sales performance
WITH order_value AS (
    SELECT order_id, SUM(price + freight_value) AS order_value
    FROM order_items
    GROUP BY order_id
)
SELECT
    YEAR(o.order_purchase_timestamp) AS year,
    COUNT(*) AS orders,
    ROUND(SUM(COALESCE(ov.order_value, 0)), 2) AS gmv,
    ROUND(AVG(COALESCE(ov.order_value, 0)), 2) AS aov
FROM orders o
LEFT JOIN order_value ov ON ov.order_id = o.order_id
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY year;

-- 4. Top product categories by GMV
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
    COUNT(DISTINCT oi.order_id) AS orders,
    COUNT(*) AS items,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS gmv
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
LEFT JOIN product_category_name_translation t
    ON t.product_category_name = p.product_category_name
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
ORDER BY gmv DESC;

-- 5. Top sellers by GMV
SELECT
    oi.seller_id,
    COUNT(DISTINCT oi.order_id) AS orders,
    COUNT(*) AS items,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS gmv
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY gmv DESC
LIMIT 20;

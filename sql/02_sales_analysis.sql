-- 02_sales_analysis.sql
USE olist_ecommerce;

-- GMV by purchase month. GMV = sum of item price, excluding freight.
SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS purchase_month,
       COUNT(DISTINCT o.order_id) AS orders,
       COUNT(*) AS order_item_rows,
       ROUND(SUM(oi.price), 2) AS gmv,
       ROUND(SUM(oi.price) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS aov
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
WHERE o.order_purchase_timestamp IS NOT NULL
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY purchase_month;

-- Top 10 product categories by GMV
SELECT COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS product_category,
       COUNT(*) AS item_rows,
       COUNT(DISTINCT oi.order_id) AS orders,
       ROUND(SUM(oi.price), 2) AS gmv
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o ON o.order_id = oi.order_id
LEFT JOIN olist_products_dataset p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'unknown')
ORDER BY gmv DESC LIMIT 10;

-- Top 10 sellers by GMV
SELECT oi.seller_id, s.seller_state,
       COUNT(DISTINCT oi.order_id) AS orders,
       COUNT(*) AS item_rows,
       ROUND(SUM(oi.price), 2) AS gmv
FROM olist_order_items_dataset oi
LEFT JOIN olist_sellers_dataset s ON oi.seller_id = s.seller_id
GROUP BY oi.seller_id, s.seller_state
ORDER BY gmv DESC LIMIT 10;

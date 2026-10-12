# Data Dictionary — Olist Brazilian E-Commerce

## Source files and grain

| File / logical table | Supplied rows | Grain / key | Main use |
|---|---:|---|---|
| `olist_orders_dataset.csv` | 99,441 | One per `order_id` | Order lifecycle and delivery |
| `olist_customers_dataset.csv` | 99,441 | One per `customer_id`; `customer_unique_id` represents person identity | Customer state and repeat behavior |
| `olist_order_items_dataset.csv` | 112,650 | One per `order_id` + `order_item_id` | Item GMV, freight, category and seller |
| `olist_products_dataset.csv` | 32,951 | One per `product_id` | Product category and dimensions |
| `olist_sellers_dataset.csv` | 3,095 | One per `seller_id` | Seller performance and state |
| `olist_order_payments_dataset.csv` | 103,886 | Payment record; multiple rows per order | Payment mix and installments |
| `olist_order_reviews_dataset.csv` | 99,224 | Review record; multiple rows per order possible | Satisfaction |
| `olist_geolocation_dataset.csv` | 1,000,163 | Multiple locations per ZIP prefix | Geographic mapping after aggregation |
| `product_category_name_translation.csv` | 71 | One per Portuguese category name | English category labels |

## Relationships

- `orders.customer_id` → `customers.customer_id`
- `order_items.order_id` → `orders.order_id`
- `order_items.product_id` → `products.product_id`
- `order_items.seller_id` → `sellers.seller_id`
- `payments.order_id` → `orders.order_id`
- `reviews.order_id` → `orders.order_id`
- `products.product_category_name` → `product_category_name_translation.product_category_name`

Geolocation ZIP prefixes repeat. Do not join raw geolocation rows directly to facts before reducing them to a unique ZIP-prefix lookup.

## Metric definitions

- **Orders:** distinct `order_id`.
- **GMV:** sum of `order_items.price`; excludes freight and is not profit.
- **AOV:** defined GMV divided by distinct orders for the same population.
- **Unique customers:** distinct `customer_unique_id`, not `customer_id`.
- **Repeat customer:** person key with more than one distinct order.
- **Late delivery:** actual delivery timestamp strictly later than estimated timestamp; equality is on time.
- **Eligible delivered order:** delivered status plus non-null actual and estimated delivery timestamps.
- **Review analysis:** aggregate review rows to order grain before joining order-level delivery metrics.

## Data-quality checks

The supplied data contains 99,441 unique order IDs, 112,650 unique composite item keys, 103,886 payment rows and 99,224 review rows. Eight rows have delivered status but a missing actual delivery timestamp; thus, the strict delivery-performance denominator is 96,470 rather than 96,478.

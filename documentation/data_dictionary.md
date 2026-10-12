# Data Dictionary

The project uses the Brazilian E-Commerce Public Dataset by Olist. The table names below correspond to the standard CSV dataset and the intended MySQL model.

## Core Tables

| Table | Grain | Primary key | Main analytical use |
|---|---|---|---|
| customers | one row per customer-location record | customer_id | customer geography and mapping to customer_unique_id |
| orders | one row per order | order_id | order lifecycle, dates, status and delivery |
| order_items | one row per product line in an order | order_id + order_item_id | GMV, freight, products and sellers |
| order_payments | one row per payment record | order_id + payment_sequential | payment method, value and installments |
| order_reviews | review record linked to an order | review_id | satisfaction and review score |
| products | one row per product | product_id | product category and product attributes |
| sellers | one row per seller | seller_id | seller performance and geography |
| geolocation | postal-code-prefix geography | geolocation_zip_code_prefix | geographic enrichment |
| product_category_name_translation | category translation mapping | product_category_name | English category labels |

## Important Orders Fields

- `order_id`: unique order identifier.
- `customer_id`: order-to-customer-location key.
- `order_status`: lifecycle status such as delivered, shipped or canceled.
- `order_purchase_timestamp`: purchase timestamp.
- `order_approved_at`: payment approval timestamp.
- `order_delivered_carrier_date`: date the carrier received the order.
- `order_delivered_customer_date`: customer delivery timestamp.
- `order_estimated_delivery_date`: promised/estimated delivery date.

## Important Order-Item Fields

- `order_id`: links item lines to orders.
- `order_item_id`: item sequence within an order.
- `product_id`: product key.
- `seller_id`: seller key.
- `price`: item price.
- `freight_value`: freight charged for the item line.

## Customer Identity

`customer_id` identifies a customer-location record. `customer_unique_id` is the appropriate field for analysing repeat behaviour across orders because one unique customer can have multiple customer-location records.

## Grain Rules

1. Use `COUNT(DISTINCT order_id)` for order-level counts after joining order items, payments or reviews.
2. Aggregate order items to `order_id` before calculating order-level GMV/AOV.
3. Aggregate reviews to `order_id` before joining reviews to delivery metrics if multiple review records are present.
4. Use `customer_unique_id` for customer-level repeat-purchase analysis.

## Data Quality Checks

Run `sql/01_data_quality.sql` before the analytical scripts. Check duplicates, null timestamps, timestamp sequence errors, orphan keys and referential integrity.

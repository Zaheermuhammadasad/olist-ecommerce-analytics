# Olist E-Commerce Analytics

An end-to-end analytics portfolio project using the Brazilian E-Commerce Public Dataset by Olist. It demonstrates practical SQL, Python/Pandas, data-quality analysis, business interpretation and BI dashboard planning.

## Business questions

- How do order volume, GMV and average order value change over time?
- Which product categories and sellers generate the most item-price GMV?
- What proportion of customers place more than one order?
- Which payment methods and installment patterns are common?
- How does delivery performance vary by year and customer state?
- How does delivery lateness relate to review scores?

## Workflow

**Data understanding → data quality → SQL analysis → Python analysis → business insights → BI dashboard → recommendations**

## Dataset

The public dataset has nine related CSV tables. The full raw CSV files are included in the downloadable project ZIP under `python/data/` and excluded from this GitHub repository because the geolocation file is large. Download the Olist Brazilian E-Commerce dataset separately and put the required CSVs in `python/data/` to run the Python script. The SQL scripts expect tables imported into MySQL using their base filenames (without `.csv`).

## Repository contents

- `sql/` — data quality, sales, customer, delivery, payment and review queries.
- `python/olist_analysis.py` — reproducible Pandas workflow.
- `python/requirements.txt` — dependencies.
- `analysis/business_insights.md` — evidence-based findings and recommendations.
- `documentation/data_dictionary.md` — grains, relationships and definitions.
- `documentation/getting_started.md` — setup steps.
- `dashboard/README.md` — Power BI/Tableau dashboard specification.

## Validated results from the supplied dataset

- 99,441 orders and 99,441 unique order IDs.
- 112,650 order-item rows and 112,650 unique composite item keys.
- Item-price GMV: approximately 13.592 million, excluding freight.
- Strict delivery-performance population: 96,470 delivered orders with both actual and estimated timestamps.
- Late deliveries: 7,826, or 8.11% of the strict delivery-performance population.
- Average purchase-to-delivery duration for that population: 12.56 days.
- Late-delivered orders have lower average review scores than orders delivered on or before their estimate.

Metric definitions and eligibility filters are documented. Results are descriptive, not causal. A native Power BI/Tableau report must still be built separately using the dashboard specification.

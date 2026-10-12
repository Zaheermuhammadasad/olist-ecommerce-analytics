# Getting Started

## Download and prepare data

Download the public Olist Brazilian E-Commerce dataset. Put these CSVs in `python/data/`: orders, customers, order items, products, sellers, payments, reviews, and product category translations. The geolocation CSV is not read by the current script because repeated ZIP prefixes must be aggregated before mapping.

## Run Python analysis

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r python/requirements.txt
python python/olist_analysis.py
```

The script writes CSV summaries, JSON KPIs and charts into `python/outputs/`.

## Load into MySQL Workbench

Create schema `olist_ecommerce`. Import each CSV as a table named after the filename without `.csv` (e.g. `olist_orders_dataset`), then execute the SQL files in numeric order. Inspect column types and table names if Workbench imported them differently.

## Study findings and build dashboard

Trace each insight in `analysis/business_insights.md` to its evidence and SQL query. Follow `dashboard/README.md` to build the native report in Power BI or Tableau, then validate the totals against Python outputs.

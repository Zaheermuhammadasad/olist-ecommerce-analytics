# Getting Started

## 1. Data
The nine source CSVs are supplied in the downloadable project ZIP under `python/data/`. GitHub intentionally excludes the raw CSVs, especially the large geolocation file.

## 2. Run Python analysis

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r python/requirements.txt
python python/olist_analysis.py
```

On Windows, activate with `.venv\\Scripts\\activate`. The script writes CSV summaries, JSON KPIs and charts into `python/outputs/`.

## 3. MySQL Workbench
Create schema `olist_ecommerce` and import CSVs using their filename without `.csv` for table names. Run the five SQL scripts in `sql/` in numeric order. Confirm Workbench's table names and column types before running queries.

## 4. Learn the findings
Read `analysis/business_insights.md`, then trace each claim to its output table and SQL query.

## 5. Dashboard
Follow `dashboard/README.md` to build a native Power BI or Tableau report and validate totals against the Python results.

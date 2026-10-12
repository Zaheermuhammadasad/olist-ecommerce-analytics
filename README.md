# Olist E-Commerce Analytics

An end-to-end analytics portfolio project using the Brazilian E-Commerce Public Dataset by Olist. The project demonstrates practical **SQL, Python, data-quality, business-analysis and BI dashboarding** skills.

## Business Questions

1. **Sales:** How do orders, GMV and average order value change over time?
2. **Customers:** Who are the highest-value customers and how strong is repeat purchasing?
3. **Products & Sellers:** Which categories and sellers drive revenue and order volume?
4. **Payments:** Which payment methods and installment patterns are most common?
5. **Operations & CX:** Where are delivery delays concentrated, and how do delays relate to review scores?

## Workflow

**Data Understanding → Data Quality → SQL Analysis → Python EDA → Business Insights → BI Dashboard → Recommendations**

Every recommendation should be traceable to a reproducible metric or query.

## Dataset

Source: Brazilian E-Commerce Public Dataset by Olist.

The full public dataset contains approximately 100k orders and related tables for customers, orders, order items, products, sellers, payments, reviews, geolocation and category translations.

**Raw CSV files are intentionally not committed to GitHub.** Download the public dataset separately and load it into MySQL using `documentation/data_dictionary.md`.

## Repository Structure

```text
olist-ecommerce-analytics/
├── README.md
├── sql/
│   ├── 01_data_quality.sql
│   ├── 02_sales_analysis.sql
│   ├── 03_customer_analysis.sql
│   ├── 04_delivery_analysis.sql
│   └── 05_payment_review_analysis.sql
├── python/
│   ├── olist_analysis.py
│   ├── load_to_mysql.py
│   ├── requirements.txt
│   └── README.md
├── dashboard/
│   └── README.md
├── analysis/
│   └── business_insights.md
└── documentation/
    └── data_dictionary.md
```

## SQL Layer

The SQL layer covers row counts and duplicates, order-status distribution, monthly sales and GMV, AOV, category and seller performance, customer value and repeat purchasing, payment methods and installments, delivery performance, state-level delivery risk, delay buckets, review scores and delivery-vs-satisfaction analysis.

Queries explicitly control grain so that one-to-many joins do not inflate order-level metrics.

## Python Layer

`python/olist_analysis.py` provides a reproducible Pandas workflow for loading the Olist CSV files, validating types, profiling missing values, creating core KPIs, analysing monthly sales and delivery performance, and exporting tables/charts.

## Dashboard

The recommended Power BI/Tableau dashboard has four pages:

- **Executive Overview:** Orders, GMV, AOV, customers, review score
- **Sales & Products:** monthly trend, category revenue, seller performance
- **Customers & Payments:** customer segments, repeat rate, payment methods and installments
- **Operations & CX:** delivery performance, delay distribution, state-level risk, review-score impact

See `dashboard/README.md` for KPI definitions and the visual specification.

## Development Note

The MySQL schema used during development initially contained only a subset of the Olist tables. Order-level delivery analysis can therefore be performed on that subset, but product/category/seller/payment/review analysis requires the corresponding Olist tables to be loaded first. The repository does not invent results for tables that are not present.

## Portfolio Outcome

The target is a complete analyst workflow:

**clean data → reproducible SQL → Python analysis → business insights → decision-ready dashboard recommendations.**

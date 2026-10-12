# Interactive Dashboard

## Open the dashboard

**[Launch the interactive dashboard preview](https://htmlpreview.github.io/?https://raw.githubusercontent.com/Zaheermuhammadasad/olist-ecommerce-analytics/main/dashboard/olist_recruiter_dashboard.html)**

Source file: olist_recruiter_dashboard.html

The dashboard is a static HTML page with Plotly charts. The charts provide hover details and interactive controls. It loads Plotly from a CDN, so an internet connection is needed when opening the page.

## What's included

- Executive KPI cards for orders, item-price GMV, eligible delivered orders, late-delivery rate, and average delivery duration.
- Late-delivery rate by year.
- Top product categories by item-price GMV.
- Payment-value mix.
- Delivery-delay distribution.
- Average review score by delivery performance.
- A short set of descriptive business insights.

## KPI definitions and caveats

- GMV is the sum of item prices and excludes freight; it is not profit.
- Delivery performance includes delivered-status orders with both actual and estimated delivery timestamps.
- Late means actual delivery is strictly later than the estimated delivery timestamp.
- Review comparisons are descriptive and do not establish causation.
- The dashboard is a browser-based interactive HTML deliverable, not a native Power BI PBIX or Tableau TWB file.

For the full KPI specification and planned extensions, see the project data dictionary and analysis documentation.
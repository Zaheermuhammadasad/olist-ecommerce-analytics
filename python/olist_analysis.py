"""Olist E-Commerce Analytics - reproducible Python analysis.

Place the public Olist CSV files in data/ before running.
The script intentionally calculates metrics from the raw tables rather than
hard-coding results.
"""
from pathlib import Path
import pandas as pd

DATA = Path("data")
OUTPUT = Path("output")
OUTPUT.mkdir(exist_ok=True)

FILES = {
    "orders": "olist_orders_dataset.csv",
    "customers": "olist_customers_dataset.csv",
    "items": "olist_order_items_dataset.csv",
    "payments": "olist_order_payments_dataset.csv",
    "reviews": "olist_order_reviews_dataset.csv",
    "products": "olist_products_dataset.csv",
    "translations": "product_category_name_translation.csv",
    "sellers": "olist_sellers_dataset.csv",
}


def load_csv(name: str) -> pd.DataFrame:
    path = DATA / FILES[name]
    if not path.exists():
        raise FileNotFoundError(f"Missing {path}. Download the Olist dataset first.")
    return pd.read_csv(path)


def main() -> None:
    orders = load_csv("orders")
    customers = load_csv("customers")
    items = load_csv("items")

    orders["order_purchase_timestamp"] = pd.to_datetime(orders["order_purchase_timestamp"])
    orders["order_delivered_customer_date"] = pd.to_datetime(orders["order_delivered_customer_date"])
    orders["order_estimated_delivery_date"] = pd.to_datetime(orders["order_estimated_delivery_date"])

    quality = pd.DataFrame({
        "metric": ["order_rows", "unique_orders", "duplicate_order_rows"],
        "value": [len(orders), orders["order_id"].nunique(), len(orders) - orders["order_id"].nunique()],
    })
    quality.to_csv(OUTPUT / "data_quality.csv", index=False)

    delivered = orders[
        (orders["order_status"] == "delivered")
        & orders["order_delivered_customer_date"].notna()
        & orders["order_estimated_delivery_date"].notna()
    ].copy()
    delivered["days_vs_estimated"] = (
        delivered["order_delivered_customer_date"] - delivered["order_estimated_delivery_date"]
    ).dt.days
    delivered["late"] = delivered["days_vs_estimated"] > 0

    delivery = pd.DataFrame({
        "metric": ["delivered_orders", "late_orders", "late_pct"],
        "value": [len(delivered), int(delivered["late"].sum()), round(delivered["late"].mean() * 100, 2)],
    })
    delivery.to_csv(OUTPUT / "delivery_kpis.csv", index=False)

    monthly = (
        orders.assign(month=orders["order_purchase_timestamp"].dt.to_period("M").astype(str))
        .groupby("month", as_index=False)
        .agg(orders=("order_id", "nunique"))
    )
    monthly.to_csv(OUTPUT / "monthly_orders.csv", index=False)

    customer_orders = (
        orders.merge(customers[["customer_id", "customer_unique_id"]], on="customer_id", how="left")
        .groupby("customer_unique_id", as_index=False)
        .agg(orders=("order_id", "nunique"))
    )
    customer_kpis = pd.DataFrame({
        "metric": ["customers", "repeat_customers", "repeat_customer_pct"],
        "value": [
            len(customer_orders),
            int((customer_orders["orders"] > 1).sum()),
            round((customer_orders["orders"] > 1).mean() * 100, 2),
        ],
    })
    customer_kpis.to_csv(OUTPUT / "customer_kpis.csv", index=False)

    print("Analysis complete. Results written to output/")
    print(quality.to_string(index=False))
    print(delivery.to_string(index=False))


if __name__ == "__main__":
    main()

# Supplier Reporting & Data-Quality Scorecard

A supplier scorecard that ranks marketplace sellers on delivery reliability, customer
satisfaction and volume, and flags where their product data is incomplete. Built
warehouse-first with **BigQuery** and **Power BI (DAX)** on 100,000 real orders.

> Honest note: this uses the public **Olist** Brazilian e-commerce dataset as a
> stand-in for a supplier reporting problem. In a marketplace each seller behaves like
> a supplier, so it is a fair proxy. With a company's internal data this would extend
> into a full supplier scorecard with fill rate and returns.

---

## The problem
Businesses that buy through many suppliers cannot watch them all by hand. A supplier can
look fine while being late on deliveries, collecting poor reviews, or carrying
incomplete product data. This report surfaces those issues in one view a category
manager can act on.

## Architecture
```
Olist CSVs  ->  BigQuery (raw tables)  ->  SQL cleaning views  ->  Power BI (Import)  ->  Dashboard
```
- **BigQuery** is the warehouse (dataset `olist_marketplace`), loaded with a repeatable script.
- **SQL views** clean the data so the report runs on governed data, not raw tables.
- **Power BI** connects via the native BigQuery connector (Import mode, scheduled refresh).

## The dashboard (3 pages)
1. **Scorecard** — suppliers ranked on a blended score (40% on-time, 30% reviews, 30% volume) with red/amber/green status.
2. **Assortment** — sales by category, slow movers, cost to serve (freight % of revenue), top-10 supplier concentration.
3. **Data Quality** — share of products with weak listings, by category.

## Key findings
- Overall on-time rate ~93%, so the scorecard separates consistent suppliers from shaky ones.
- 52.5% of products need listing attention; health & beauty (top revenue category) is ~71% weak, the highest-return fix.
- Top 5 categories drive ~40% of revenue; ~20 categories make under 1% combined.

## Repo structure
```
supplier-scorecard/
├── README.md
├── sql/
│   └── 01_data_cleaning.sql          # BigQuery cleaning/staging views
├── warehouse/
│   └── load_to_bigquery.sh           # loads the 6 CSVs into BigQuery
├── powerbi/
│   ├── supplier_scorecard.pbix       # the Power BI report
│   └── supplier_scorecard_theme.json # custom theme
├── docs/
│   ├── CASE_STUDY.md
│   ├── ONE_PAGE_BRIEF.md
│   └── PROJECT_NOTES.md
└── dashboard.pdf                     # exported report
```
> Raw data is not committed. Download the Olist dataset from its public source and load
> it with `warehouse/load_to_bigquery.sh`.

## How to reproduce
1. Create a BigQuery project and dataset, upload the 6 Olist CSVs to Cloud Shell.
2. Run `bash warehouse/load_to_bigquery.sh YOUR_PROJECT_ID`.
3. Run `sql/01_data_cleaning.sql` to build the cleaning views.
4. Open the `.pbix`, point the BigQuery connection at your project, refresh.

## Tools
BigQuery · SQL · Power BI · DAX

## Data
Olist Brazilian E-Commerce public dataset (CC BY-NC). ~100k orders, 2016–2018.

## Author
Mohammed Faisal Khan

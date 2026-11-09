# Data

The Olist Brazilian E-Commerce public dataset (CC BY-NC), the six source tables this
project uses, plus one trimmed file. About 100k orders, 2016 to 2018.

## Files
- `olist_orders_dataset.csv` - orders, with purchase, delivered and estimated dates
- `olist_order_items_dataset.csv` - one row per item in an order, with price and freight
- `olist_order_reviews_dataset.csv` - raw customer reviews (1 to 5 stars) with comments
- `olist_products_dataset.csv` - product master (category, weight, dimensions, photos)
- `olist_sellers_dataset.csv` - sellers and their location
- `product_category_name_translation.csv` - Portuguese to English category names
- `order_reviews_clean.csv` - reviews trimmed to order_id + review_score, one row per order

## Note on reviews
The raw review comments contain line breaks inside quoted fields, which breaks a plain
CSV load. The model only needs the score, so `order_reviews_clean.csv` (order_id and
review_score) is what gets loaded as the `order_reviews` table. Load that for the
`order_reviews` step in `../load_to_bigquery.sh`.

## Source
Olist's public release of the Brazilian E-Commerce dataset. License: CC BY-NC 4.0.
Included here with attribution for non-commercial, portfolio use.

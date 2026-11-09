#!/usr/bin/env bash
# Seed a BigQuery warehouse with the Olist marketplace data.
# Run in Google Cloud Shell AFTER uploading the 6 CSVs to your Cloud Shell home folder.
# Usage: bash load_to_bigquery.sh YOUR_PROJECT_ID
set -euo pipefail

PROJECT="${1:?Pass your GCP project id: bash load_to_bigquery.sh my-project-id}"
DATASET="olist_marketplace"
LOC="northamerica-northeast2"   # Toronto region

gcloud config set project "$PROJECT"
bq --location="$LOC" mk -f --dataset "$PROJECT:$DATASET"

load () {  # load <table_name> <csv_file>
  echo ">> loading $1"
  bq load --replace --autodetect --skip_leading_rows=1 \
    --source_format=CSV --allow_quoted_newlines=true \
    "$DATASET.$1" "$2"
}

load orders               olist_orders_dataset.csv
load order_items          olist_order_items_dataset.csv
load order_reviews        olist_order_reviews_dataset.csv
load products             olist_products_dataset.csv
load sellers              olist_sellers_dataset.csv
load category_translation product_category_name_translation.csv

echo ">> done. Tables in $PROJECT.$DATASET :"
bq ls "$DATASET"

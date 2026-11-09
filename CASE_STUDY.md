# Building a Supplier Reporting & Data-Quality Scorecard
### A reporting analyst case study
**Mohammed Faisal Khan** | GCP, BigQuery, SQL, Power BI (DAX)

---

## Overview
I built a supplier scorecard that ranks marketplace sellers on delivery reliability,
customer satisfaction and volume, and flags where their product data is incomplete.
It answers the question a category manager asks every month: which suppliers do we
need to review, and where is our catalogue data letting us down.

Built warehouse-first with BigQuery and Power BI, the same workflow a real analytics
team uses, on 100,000 real orders from **Olist**, a Brazilian e-commerce marketplace
that connects small sellers to large online storefronts.

---

## The problem
A business selling through hundreds of suppliers cannot watch them all by hand. Some
suppliers are quietly unreliable: late deliveries, poor reviews, or thin product data
that makes the catalogue hard to manage. Those problems sit buried in the data until
something goes wrong. The reporting analyst's job is to surface them early, in one view
a manager can act on.

I did not have a company's private supplier data, so I used the public dataset from
**Olist**, a Brazilian e-commerce marketplace (100k real orders, 2016 to 2018,
~3,000 sellers). Olist lets small sellers list on big Brazilian storefronts and handles
the logistics, so each seller behaves just like a supplier does for a retailer, a fair
stand-in. I am explicit about the proxy rather than passing it off as retail data.

---

## Approach
I structured the report around three questions, each one layer:

1. **Which suppliers are weak?** A blended scorecard.
2. **What sells, and what barely moves?** An assortment view.
3. **Where is our product data messy?** A data-governance view.

And I built it on the real stack, not flat files:
- **BigQuery** as the warehouse, loaded with a repeatable script.
- **SQL views** for cleaning, so the report runs on governed data.
- **Power BI** connected to the warehouse, star schema, DAX measures.

---

## What I built

**Warehouse and cleaning.** Loaded six source tables into BigQuery, then wrote SQL
views that keep only delivered orders, build an on-time flag (delivered on or before the
promised date), translate categories to English, and flag weak product listings.

**Model.** A star schema with order_items as the fact table and orders, products and
sellers as dimensions.

**Scorecard logic.** A blended Seller Score in DAX: 40% on-time rate, 30% average review,
30% volume, with a 30-order minimum so a seller with two lucky orders cannot top the chart.

---

## Results

**Delivery is mostly fine, so the story is consistency, not disaster.** About 93% of
orders arrived on time. The scorecard's value is separating consistent suppliers from
shaky ones, not finding catastrophes.

**A clear review list, low risk to act on.** Of 627 qualifying sellers, the bottom tier
(157 sellers) sits at a median 90% on-time versus 94% for the top tier, yet holds only
about 7% of revenue. So a manager can act on the weak group without touching the sellers
that drive the business.

**The governance finding is the standout.** Only about 2% of products have truly missing
fields, which is easy to miss and call "clean." But around half of all products have just
one photo, and the share of products needing attention ranges from 2% to 100% depending
on the category. The real issue is listing quality, not blank cells, and it is fixable
by category.

**Assortment is concentrated.** The top five categories drive roughly 40% of revenue,
while about 20 categories together account for under 1%, a clear slow-mover list.

---

## Recommendations
Each one comes straight from a finding above:

1. **Put the bottom tier on a watch list, not a blocklist.** The 157 weakest sellers
   hold only about 7% of revenue, so review them quarterly for delivery consistency
   without disrupting the suppliers that drive the business.

2. **Fix listing quality where it hurts most, starting with health & beauty.** It is the
   number one revenue category, yet about 70% of its products need listing attention
   (mostly single-photo listings). Fixing the biggest category first gives the largest
   return on effort. Run the same pass down the worst-data-health categories after that.

3. **Review the slow movers for delisting.** Around 20 categories together make under 1%
   of revenue. Confirm there is no strategic reason to keep them, then trim to simplify
   the catalogue.

4. **Automate the early warning.** When a supplier's on-time rate or data completeness
   drops below a set line, trigger an alert to the category manager (a Power Automate
   flow), so the report catches problems instead of waiting for the monthly review.

---

## Outcome
The project delivers a single, repeatable monthly view that turns raw marketplace data
into three things a category manager can act on the same day: a ranked list of suppliers
to review, a data-quality heatmap by category, and a slow-mover list. What was a vague
worry ("are our suppliers okay") becomes a prioritized action list backed by numbers.

Because it runs off a warehouse with a refresh, it is not a one-off analysis. It reruns
every month on the latest data with no rebuild.

## Next step
With a company's internal data I would point the same model at their warehouse and add
the two numbers a supplier team cares about most, fill rate and returns, turning this
prototype into a full supplier scorecard.

---

## Honest notes
- Marketplace data used as a proxy for a supplier problem, stated openly.
- Built on flat-file-sourced data loaded into a warehouse to prove the logic end to end.
  In production it would read from the company's own warehouse with scheduled refresh.
- Dataset: Olist Brazilian E-Commerce public dataset (CC BY-NC).

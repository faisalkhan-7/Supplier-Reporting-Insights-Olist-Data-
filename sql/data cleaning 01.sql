-- =====================================================================
-- cleaning the ORDERS table for the seller scorecard
-- i am making a view so power bi reads tidy data instead of the raw table
-- =====================================================================

create or replace view olist_marketplace.vw_orders_clean as

-- first i pull just the columns i need and cut the timestamps down to dates,
-- because for on time delivery i only care about the calendar day, not the clock time
with base as (
  select
    order_id,
    customer_id,
    order_status,
    date(order_purchase_timestamp)       as purchase_date,
    date(order_delivered_customer_date)  as delivered_date,
    date(order_estimated_delivery_date)  as estimated_date
  from olist_marketplace.orders
)

select
  order_id,
  customer_id,
  order_status,
  purchase_date,
  delivered_date,
  estimated_date,

  -- this is the whole point of the project, the on time flag
  -- an order is on time if it arrived on or before the date we promised the customer
  -- i use 1 and 0 (not true/false) so power bi can average them into a percentage
  case
    when delivered_date <= estimated_date then 1
    else 0
  end as is_on_time,

  -- i also calculate how many days late or early each order was
  -- negative means it came early, positive means it was late
  date_diff(delivered_date, estimated_date, day) as delivery_gap_days

from base

-- cleaning step 1: only keep orders that were actually delivered,
-- because judging a cancelled or still shipping order on delivery time makes no sense
where order_status = 'delivered'

  -- cleaning step 2: a few delivered orders have no delivery date at all,
  -- looks like a gap in the source data, so i drop them to keep the math honest
  and delivered_date is not null
;

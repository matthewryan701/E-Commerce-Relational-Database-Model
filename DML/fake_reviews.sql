CREATE VIEW fake_reviews AS
-- All (customer_id, product_id) pairs where an order has been made
WITH bought AS (
  SELECT
    orders.customer_id,
    order_product.product_id,
    orders.delivery_date
  FROM 
    orders
  JOIN 
    order_product
  ON 
    orders.order_id = order_product.order_id
)

-- Left join excluding inner join to find fake reviews, or delivery_date > review_date
SELECT 
  r.*
FROM 
  review r 
LEFT JOIN
  bought b
ON 
  (r.customer_id, r.product_id) = (b.customer_id, b.product_id)
WHERE 
  (b.customer_id, b.product_id) IS NULL OR b.delivery_date > r.review_date
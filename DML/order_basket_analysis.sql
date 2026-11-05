-- Finding total price paid for each order
WITH totals AS (
  SELECT 
    order_id,
    SUM(quantity * unit_price) AS order_total 
  FROM 
    order_product
  GROUP BY 
    order_id),

-- Finding details of the products in each order as list
details AS (
  SELECT 
    op.order_id,
    STRING_AGG(CONCAT('(', p.product_name, ', ', op.colour, ', ', op.quantity, ')'), ', ') AS order_basket
  FROM 
    order_product op
  JOIN 
    product p
  ON 
    op.product_id = p.product_id
  GROUP BY op.order_id)

-- Displaying order_id, order_details and order_total showing the biggest orders first
SELECT 
  d.order_id,
  d.order_basket,
  t.order_total
FROM 
  details d 
JOIN
  totals t
ON 
  d.order_id = t.order_id
ORDER BY
  t.order_total DESC
LIMIT 3
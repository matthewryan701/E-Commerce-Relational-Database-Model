SELECT 
  DISTINCT p.customer_id,
  c.*
FROM 
  (SELECT
    customer_id,
    order_id,
    LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS prev_purchase
  FROM 
    orders) p
JOIN
  customer c
ON 
  p.customer_id = c.customer_id
WHERE  
  p.prev_purchase IS NOT NULL
-- Filtering out fake reviews
WITH real_reviews AS (
  SELECT 
    r.product_id,
    r.customer_id,
    r.rating
  FROM 
    review r
  LEFT JOIN 
    fake_reviews f
  ON 
    (r.product_id, r.customer_id) = (f.product_id, f.customer_id)
  WHERE
    (f.product_id, f.customer_id) IS NULL
)

-- Finding average rating for each product
SELECT
  p.*,
  ROUND(AVG(r.rating), 2) AS avg_rating
FROM 
  product p
LEFT JOIN 
  real_reviews r
ON  
  p.product_id = r.product_id
GROUP BY 
  p.product_id
ORDER BY 5 DESC
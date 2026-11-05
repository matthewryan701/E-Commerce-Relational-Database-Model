-- Function: reject a review if the customer has no delivered order of that product on or before the review date
CREATE OR REPLACE FUNCTION check_review_valid()
RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 
      1
    FROM 
      orders
    JOIN 
      order_product
    ON 
      orders.order_id = order_product.order_id
    WHERE 
      (orders.customer_id, order_product.product_id) = (NEW.customer_id, NEW.product_id)
      AND orders.delivery_date <= NEW.review_date
  ) THEN
    RAISE EXCEPTION 'Review rejected: customer % has no delivered order of product % on or before %',
      NEW.customer_id, NEW.product_id, NEW.review_date;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: run the check before every insert or update on review
CREATE TRIGGER trg_check_review
BEFORE INSERT OR UPDATE ON 
  review
FOR EACH ROW
EXECUTE FUNCTION check_review_valid();
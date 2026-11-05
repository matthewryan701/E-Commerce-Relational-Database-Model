-- Function: block changes to order lines once the order has been delivered
CREATE OR REPLACE FUNCTION check_order_not_delivered()
RETURNS TRIGGER AS $$
BEGIN
  -- UPDATE or DELETE: the existing line must not belong to a delivered order
  IF TG_OP IN ('UPDATE', 'DELETE') THEN
    IF EXISTS (
      SELECT 
        1
      FROM 
        orders
      WHERE 
        orders.order_id = OLD.order_id
        AND orders.delivery_date <= CURRENT_DATE
    ) THEN
      RAISE EXCEPTION '% rejected: order % has already been delivered on %',
        TG_OP, OLD.order_id, (SELECT orders.delivery_date FROM orders WHERE orders.order_id = OLD.order_id);
    END IF;
  END IF;

  -- INSERT or UPDATE: the line must not be added or moved into a delivered order
  IF TG_OP IN ('INSERT', 'UPDATE') THEN
    IF EXISTS (
      SELECT 
        1
      FROM 
        orders
      WHERE 
        orders.order_id = NEW.order_id
        AND orders.delivery_date <= CURRENT_DATE
    ) THEN
      RAISE EXCEPTION '% rejected: order % has already been delivered',
        TG_OP, NEW.order_id;
    END IF;
  END IF;

  -- DELETE must return OLD, otherwise the delete is silently skipped
  IF TG_OP = 'DELETE' THEN
    RETURN OLD;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: run the check before every insert, update or delete on order_product
CREATE TRIGGER trg_check_order_not_delivered
BEFORE INSERT OR UPDATE OR DELETE ON 
  order_product
FOR EACH ROW
EXECUTE FUNCTION check_order_not_delivered();
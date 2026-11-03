```sql
CREATE TABLE CUSTOMER (
    customer_id   INT           PRIMARY KEY,
    first_name    VARCHAR(50)   NOT NULL,
    last_name     VARCHAR(50)   NOT NULL,
    email         VARCHAR(100)  NOT NULL UNIQUE,
    phone_num     VARCHAR(20),                  
    add_line_1    VARCHAR(100)  NOT NULL,
    add_line_2    VARCHAR(100),                
    city          VARCHAR(50)   NOT NULL,
    postcode      VARCHAR(10)   NOT NULL,
    country       VARCHAR(50)   NOT NULL
);

CREATE TABLE PRODUCT (
    product_id     INT            PRIMARY KEY,
    product_name   VARCHAR(100)   NOT NULL,
    description    VARCHAR(500),               
    product_price  DECIMAL(5,2)  NOT NULL
);

CREATE TABLE ORDERS (
    order_id       INT           PRIMARY KEY,
    customer_id    INT           NOT NULL,
    order_date     DATE          NOT NULL,
    delivery_date  DATE,                        
    add_line_1     VARCHAR(100)  NOT NULL,
    add_line_2     VARCHAR(100),               
    city           VARCHAR(50)   NOT NULL,
    postcode       VARCHAR(10)   NOT NULL,
    country        VARCHAR(50)   NOT NULL,
    CHECK (delivery_date >= order_date),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id)
);

CREATE TABLE ORDER_PRODUCT (
    order_id    INT            NOT NULL,
    product_id  INT            NOT NULL,
    quantity    INT            NOT NULL,
    size        VARCHAR(3)    NOT NULL
                CHECK (size IN ('XS', 'S', 'M', 'L', 'XL', 'XXL')),
    colour      VARCHAR(30)    NOT NULL,
    unit_price  DECIMAL(5,2)  NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id)   REFERENCES ORDERS(order_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id)
);

CREATE TABLE REVIEW (
    customer_id  INT           NOT NULL,
    product_id   INT           NOT NULL,
    rating       INT           NOT NULL,
    description  VARCHAR(500),                  
    review_date  DATE          NOT NULL,
    PRIMARY KEY (customer_id, product_id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id),
    FOREIGN KEY (product_id)  REFERENCES PRODUCT(product_id)
);
```

Attached above is the schema for the 5 tables inside my database for a clothing brand e-commerce company. Generate synthetic data for each of the tables, in the form of .csv files where each new row is a new record. Here are the specific requirements for each table:

CUSTOMERS (~1000 rows long): 

* 50% of rows with phone_num NOT NULL, 50% NULL
* 20% of rows with add_line_2 NOT NULL, 80% NULL
* Include UK addresses only


PRODUCT (~80 rows long):

* product_name only includes clothing related products
* 80% of rows with description NOT NULL, 20% NULL
* 100 > product_price > 0


ORDERS (~3000 rows long):

* 98% of rows with delivery_date NOT NULL, 2% NULL

* WHERE delivery_date NOT NULL, delivery_date >= order_date
* 20% of rows with add_line_2 NOT NULL, 80% NULL
* Make delivery_date - order_date range uniformly from 2 days to 21 days
* Include some customer_id that have up to 10 distinct order_id
* Include some customer_id that have only 1 distinct order_id
* Include UK addresses only
* Only include customer_id in CUSTOMERS


ORDER_PRODUCT (~6000 rows long):

* Include some order_id that have only 1 distinct product_id
* Include some order_id that have up to 10 distinct product_id
* Include some quantity = 1
* Include some quantity > 1
* Only include order_id and product_id in CUSTOMERS and PRODUCT
* Include all possible sizes


REVIEW (~800 rows long):

* Only include customer_id and product_id in CUSTOMERS and PRODUCT
* Include a uniformly distributed range of rating from 0 to 5
* Include some customer_id and product_id where that specific customer has not bought that specific product.
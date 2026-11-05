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
    rating       INT           NOT NULL
                 CHECK (rating <= 5 AND rating >= 0),
    description  VARCHAR(500),                  
    review_date  DATE          NOT NULL,
    PRIMARY KEY (customer_id, product_id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id),
    FOREIGN KEY (product_id)  REFERENCES PRODUCT(product_id)
);
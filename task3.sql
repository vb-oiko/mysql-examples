CREATE DATABASE Mail_Company;

USE Mail_Company;

CREATE TABLE Employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    zip_code INT
);

CREATE TABLE Customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    zip_code INT
);

CREATE TABLE Orders_info (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    employee_id INT,
    Date_of_Receipt DATE,
    Expected_Ship_Date DATE,
    Actual_Ship_Date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers (id),
    FOREIGN KEY (employee_id) REFERENCES Employees (id)
);

CREATE TABLE Parts_info (
    id INT AUTO_INCREMENT PRIMARY KEY,
    part_name VARCHAR(50),
    price FLOAT,
    Quantity_in_stock INT
);

CREATE TABLE Parts_in_Orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    part_id INT,
    Quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders_info (id),
    FOREIGN KEY (part_id) REFERENCES Parts_info (id)
);




-- insert customers into table

INSERT INTO Customers (first_name, last_name, zip_code) VALUES ('John', 'Doe', '12345');

INSERT INTO Customers (first_name, last_name, zip_code) VALUES ('Jane', 'Smith', '54321');

INSERT INTO Customers (first_name, last_name, zip_code) VALUES ('Alice', 'Johnson', '67890');

INSERT INTO Customers (first_name, last_name, zip_code) VALUES ('Bob', 'Williams', '98765');

INSERT INTO Customers (first_name, last_name, zip_code) VALUES ('Eve', 'Brown', '23456');


-- insert emploees into table

INSERT INTO Employees (first_name, last_name, zip_code) VALUES ('Johnson', 'Doe', '40411');

INSERT INTO Employees (first_name, last_name, zip_code) VALUES ('Devid', 'Depth', '32016');

INSERT INTO Employees (first_name, last_name, zip_code) VALUES ('Bob', 'Red', '67732');


-- insert parts into table

INSERT INTO Parts_info (part_name, price, Quantity_in_stock) VALUES ('Widget A', 10.99, 100);

INSERT INTO Parts_info (part_name, price, Quantity_in_stock) VALUES ('Bolt B', 1.99, 500);

INSERT INTO Parts_info (part_name, price, Quantity_in_stock) VALUES ('Gasket C', 2.49, 300);

INSERT INTO Parts_info (part_name, price, Quantity_in_stock) VALUES ('Screw D', 0.49, 1000);

INSERT INTO Parts_info (part_name, price, Quantity_in_stock) VALUES ('Spring E', 3.99, 200);

INSERT INTO Parts_info (part_name, price, Quantity_in_stock) VALUES ('Nut F', 0.79, 800);

INSERT INTO Parts_info (part_name, price, Quantity_in_stock) VALUES ('Bearing G', 7.99, 150);

INSERT INTO Parts_info (part_name, price, Quantity_in_stock) VALUES ('Circuit Board H', 19.99, 50);

INSERT INTO Parts_info (part_name, price, Quantity_in_stock) VALUES ('LED Light I', 2.99, 400);

INSERT INTO Parts_info (part_name, price, Quantity_in_stock) VALUES ('Switch J', 1.29, 300);


-- Insert orders for customers
-- Customer 1 has multiple orders handled by different employees
INSERT INTO Orders_info (customer_id, employee_id, Date_of_Receipt, Expected_Ship_Date, Actual_Ship_Date)
VALUES (1, 1, '2023-11-01', '2023-11-05', '2023-11-04');

INSERT INTO Orders_info (customer_id, employee_id, Date_of_Receipt, Expected_Ship_Date, Actual_Ship_Date)
VALUES (1, 2, '2023-11-02', '2023-11-06', '2023-11-05');

-- Customer 2 has multiple orders handled by different employees
INSERT INTO Orders_info (customer_id, employee_id, Date_of_Receipt, Expected_Ship_Date, Actual_Ship_Date)
VALUES (2, 2, '2023-11-03', '2023-11-07', NULL);

INSERT INTO Orders_info (customer_id, employee_id, Date_of_Receipt, Expected_Ship_Date, Actual_Ship_Date)
VALUES (2, 3, '2023-11-04', '2023-11-08', '2023-11-07');

INSERT INTO Orders_info (customer_id, employee_id, Date_of_Receipt, Expected_Ship_Date, Actual_Ship_Date)
VALUES (4, 3, '2023-12-04', '2023-11-18', NULL);


-- Insert parts into orders
INSERT INTO Parts_in_Orders (order_id, part_id, Quantity) VALUES (1, 1, 5);
INSERT INTO Parts_in_Orders (order_id, part_id, Quantity) VALUES (1, 7, 10); 
INSERT INTO Parts_in_Orders (order_id, part_id, Quantity) VALUES (2, 3, 8); 
INSERT INTO Parts_in_Orders (order_id, part_id, Quantity) VALUES (2, 6, 4); 
INSERT INTO Parts_in_Orders (order_id, part_id, Quantity) VALUES (3, 4, 15); 
INSERT INTO Parts_in_Orders (order_id, part_id, Quantity) VALUES (4, 5, 20); 


-- Query all orders in a specified time frame, returning the order number, customer name, number
-- of ordered items and their total sum, as well as expected shipping date and actual shipping date
-- (when the order has been shipped, or NULL when it has not)

SELECT 
    o.id as order_id,
    CONCAT(c.first_name, " ",  c.last_name) as customer_name,
    SUM(po.Quantity) as total_items,
    SUM(po.Quantity * p.price) as total_sum,
    o.Expected_Ship_Date,
    o.Actual_Ship_Date
FROM 
    Orders_info as o
JOIN Customers as c ON c.id = o.customer_id
JOIN Parts_in_Orders as po ON po.order_id = o.id
JOIN Parts_info as p ON po.part_id = p.id
WHERE
    o.Date_of_Receipt BETWEEN DATE("2023-06-15") AND DATE("2024-01-01")
GROUP BY o.id;

-- Select a single order and list both order header info (order number, date and time of the order,
-- customer name) as well as all ordered items (part name, quantity and price).

SELECT
    o.id as order_id,
    o.Date_of_Receipt as date_of_receipt,
    CONCAT(c.first_name, " ",  c.last_name) as customer_name,
    p.part_name,
    po.Quantity,
    p.price
FROM Orders_info as o
JOIN Customers as c ON c.id = o.customer_id
JOIN Parts_in_Orders as po ON po.order_id = o.id
JOIN Parts_info as p ON po.part_id = p.id
WHERE o.id = 1;

-- List all parts (their names) and how many times they have been included in orders (across all
-- orders)
SELECT 
    p.part_name,
    SUM(po.Quantity) as total_quantity
FROM Parts_info as p
JOIN Parts_in_Orders as po ON po.part_id = p.id
GROUP BY p.id;
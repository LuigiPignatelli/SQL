-- RELATIONSHIPS AND JOINS

-- real world data is messy and interrelated --> table are related and interconnected
-- we often have multiple VERSIONS of a signle data --> a book: max price and min price of that book during the year
-- if we sell books, we may want to KEEP TRACK of users

-- how do we represent complex data? Relationship Basics --> THREE TYPES
-- 1. ONE-TO-ONE relationship (one customer has one detail entry)
-- 2. ONE-TO-MANY relationship (one book can have many reviews) --> THESE ARE VERY COMMON
-- 3. MANY-TO-MANY relationship (books can have many authors and authors can write many books)


-- ONE-TO-ONE relationship
-- in one table (customers) we have basic info (name, email, password) and along with it
-- we create a table with more detailed info about our customers
-- in this case this is a one-to-one relationship: one row in the customer table is associated to one row in the detailed table


-- ONE-TO-MANY relationship
-- eg: customers and orders --> one customer can have many orders
-- exercise: create two tables and store: customer_name, email, order date, price
-- NOTICE: if we store the customer in the same table every time they place an order, we end up having duplicate entries!
-- first table: here we store basic info like name, phone number, email, address
-- second table: here we keep track of the orders and who made it and when
USE shop;

TRUNCATE TABLE customers;
DROP TABLE customers;

CREATE TABLE IF NOT EXISTS customers(
	customer_id INT UNSIGNED NOT NULL AUTO_INCREMENT
    ,first_name VARCHAR(8) NOT NULL
    ,last_name VARCHAR(15) NOT NULL
    ,sex CHAR(1)
    ,email VARCHAR(20) UNIQUE
    ,PRIMARY KEY(customer_id)
);
-- in this table customer id is a PK and it uniquely identify a record
-- in our case, customer id 1 is always Antony Sanders

INSERT INTO customers(
	first_name
    ,last_name
    ,sex
    ,email
)
VALUES
('Antony', 'Sanders', 'M', 'tony_sam@yahoo.com')
,('Sam', 'Voight', 'F', 'sam98vt@gmail.com')
,('Vanessa', 'Hindras', 'F', 'van_hin@gmail.com')
,('George', 'Steel', 'M', 'georgeS@hotmail.com')
,('Jack', 'Romejn', 'M', 'JRJ@gmail.com')
,('Alma', 'Nightingale', 'M', 'NightAl@hotmail.com');

SELECT *
FROM shop.customers;

-- TRUNCATE TABLE orders;
-- DROP TABLE orders;
CREATE TABLE IF NOT EXISTS orders(
	order_id INT UNSIGNED NOT NULL AUTO_INCREMENT
    ,customer_id INT UNSIGNED NOT NULL -- this customer_id is a referecnce to the customers table: FK
    ,order_date DATETIME NOT NULL
    ,shipping_methods INT NOT NULL
    ,quantity INT NOT NULL
    ,unit_price DECIMAL(10,2) NOT NULL
    ,PRIMARY KEY(order_id)
	,FOREIGN KEY(customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE -- this deletes the orders when a customer is out
    -- this creates an explicit association between the tables
);
-- in this table, however, customer id is not a PK --> we can have the same customer repeated many times
-- in this case, customer_id is an FK --> it links the two tables
-- FKs are references to another table within a given table

INSERT INTO orders(
	customer_id
	,order_date
	,shipping_methods
    ,quantity
	,unit_price
)
VALUES
(2, '2021-01-31 09:20:10', 1, 10, 9.99)
,(3, '2021-03-01 11:30:00', 1, 5, 10.99)
,(4, '2021-05-05 10:54:00', 2, 10, 12.99)
,(1, '2021-08-20 13:55:00', 3, 2, 35.00)
,(1, '2021-08-21 17:00:30', 4, 30, 5.99);

SELECT *
FROM shop.orders;
-- the id in this table establish the reletionship between cutomers and orders
-- the customer_id num 1 in orders points to the info on customers about that customer

-- get orders and total cost from Antony
SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS customer
    ,COUNT(o.customer_id) AS TotalOrders
    ,SUM(o.quantity) AS total_QYT
    ,SUM(o.quantity * o.unit_price) AS total_price
FROM shop.customers AS c
INNER JOIN
	shop.orders AS o
    ON c.customer_id = o.customer_id
    AND c.customer_id = 1;
-- when using group by, it's better to group by elements that are unique, like customer_id (which is a PK)


-- 1. CROSS JOIN
-- in the cross join we get a "Cartesian Product":  all the possible combination of rows from the two tables
SELECT *
FROM customers AS c, orders AS o
ORDER BY c.customer_id;

-- but we can also do an explicit cross join
SELECT *
FROM customers AS c
CROSS JOIN orders AS o -- NOTICE: we're not using ON keyword
ORDER BY c.customer_id;


-- 2. INNER JOIN
-- this join returns only matching rows for which the predicate in the join clause evaluates as true

-- this is known as "natural join" or "implicit inner join"
SELECT
	c.first_name
    ,c.last_name
    ,o.order_date
    ,o.quantity
    ,o.unit_price
FROM customers AS c, orders AS o
WHERE c.customer_id = o.customer_id
ORDER BY c.customer_id; -- here we're joining customers and orders where customer_ids are equals

-- Not all the customers from the customers table appear in the above table: the last two entries haven't place an order yet
SELECT *
FROM customers AS c;

-- the conventional way to inner join customers and orders is to use the join keyword ("explicit inner join")
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer
    ,o.order_date
    ,o.quantity
    ,o.unit_price
FROM customers AS c
INNER JOIN orders AS o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;
-- in case of cross join or inner join the orders of the tables does not matter: it does matter in case of RIGTH/LEFT join


-- 3. LEFT JOIN
-- the left join returns everything from the left table (even elements that are not in the right table)
-- and it also returns the matching rows with the rigth table

-- eg.: let's say we want all the customers and all the orders they have made, if any
-- what if we want to contact customers that haven't made a order yet and offer them a discount?
SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS customers
	,o.order_date
    ,COUNT(o.order_id) AS num_orders
    ,IFNULL(SUM(o.quantity), 0) AS total_qty
    ,IFNULL(SUM(o.unit_price), 0) AS total_amount -- IFNULL has two parameters: first is to check, second what we want if null
FROM shop.customers AS c
LEFT JOIN shop.orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_amount DESC;
-- we're taking everything from customers and only the rows that match with orders

-- if we do the other way around: we get everything from orders and all rows that macth with the left table (orders)
SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS customer
    ,o.quantity
    ,o.unit_price
FROM orders AS o
LEFT JOIN customers AS c ON o.customer_id = c.customer_id;


-- 4. RIGHT JOIN
-- right join returns everything from the right table and also rows that match with the left table
-- in this case we don't have any orders that don't have a customer already: let's get everything from orders that has a customer

SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS customer
    ,o.quantity
    ,o.unit_price
FROM customers AS c
RIGHT JOIN orders AS o ON c.customer_id = o.customer_id
ORDER BY o.customer_id;
-- accoding to our FK constaints, we cannot delete a user because this user is also referenced in the orders table

-- make a table of shipping
CREATE TABLE IF NOT EXISTS shop.shipping(
	shipping_id INT UNSIGNED NOT NULL AUTO_INCREMENT REFERENCES orders(shipping_method)
    ,shipping_type VARCHAR(15)
    ,shipping_desc VARCHAR(25) NOT NULL
    ,shipping_freigth DECIMAL(5,2)
    ,PRIMARY KEY(shipping_id)
);

INSERT INTO shop.shipping(
	shipping_type
    ,shipping_desc
    ,shipping_freigth
)
VALUES
('standard','basic shipping method', 3.99)
,('local', 'shipping in same region', 6.99)
,('national', 'national shipping method', 10.00)
,('express', 'fastest shipping', 12.99)
,('international', 'entire world', 15.99);

SELECT *
FROM shipping;

SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS customers
	,IFNULL(o.quantity, 0) AS qty 
    ,IFNULL(o.unit_price, 0) AS unit_price
    ,s.shipping_freigth
    ,s.shipping_id
    ,s.shipping_type
FROM customers AS c
INNER JOIN shop.orders AS o ON c.customer_id = o.customer_id 
RIGHT JOIN shop.shipping AS s ON o.shipping_methods = s.shipping_id
ORDER BY
    unit_price DESC
    ,qty DESC;
    
-- on delete cascade
-- it's added to the FOREIGN KEY after the REFERENCES: FOREIGN KEY(order_id) REFERENCES orders(order_id) ON DELETE CASCADE
DESCRIBE orders; -- there is no sign of this new element, but let's give it a try
-- more about FK
-- https://www.w3schools.com/sql/sql_foreignkey.asp

-- delete the customer_id 1 from customers and then check orders
DELETE FROM customers
WHERE customer_id = 1; -- deleting the customer from the table customer affects the orders table
-- this is the power of ON DELETE CASCADE: everything that affects the main table also affects the secondary table

DELETE FROM orders
WHERE customer_id = 4; -- deleting the customer's order did't affect the customer table

SELECT *
FROM orders;

SELECT *
FROM customers;


-- CHALLENGES
-- create two schemas: students, papers
CREATE SCHEMA IF NOT EXISTS school_db;
USE school_db;

CREATE TABLE IF NOT EXISTS students(
	student_id INT NOT NULL AUTO_INCREMENT
    ,student_name VARCHAR(20)
    ,sex CHAR(1)
    ,PRIMARY KEY(student_id)
);

 -- RENAME TABLE school_db.student TO school_db.students;

INSERT INTO students(
	student_name
    ,sex
)
VALUES 
('Caleb', 'M'), ('Samantha', 'F'), ('Raj', 'M'), ('Carlos', 'M'), ('Lisa', 'F');

-- this is the table that contains the FK and that we want to link to STUDENTS
-- the relationship between the two tables is ONE-TO-MANY, meaning that one student can have many papers
-- some students though have no paper
CREATE TABLE IF NOT EXISTS papers(
	paper_id INT NOT NULL AUTO_INCREMENT
    ,student_id INT NOT NULL
    ,paper_title VARCHAR(50)
    ,paper_grade INT NOT NULL CHECK(paper_grade BETWEEN 50 AND 100)
    ,PRIMARY KEY(paper_id)
    ,FOREIGN KEY(student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

INSERT INTO papers(
	student_id
    ,paper_title
    ,paper_grade
)
VALUES
(1, 'My First Book Report', 60),
(1, 'My Second Book Report', 75),
(2, 'Russian Lit Through The Ages', 94),
(2, 'De Montaigne and The Art of The Essay', 98),
(4, 'Borges and Magical Realism', 89);


SELECT *
FROM papers;

SELECT *
FROM students;

-- 1) print the table of all students with essays and grades from the biggest
SELECT
	s.student_name
    ,p.paper_title
    ,p.paper_grade
FROM school_db.students AS s
INNER JOIN school_db.papers AS p ON s.student_id = p.student_id
ORDER BY paper_grade DESC;

-- 2) from the query above get every student, even those that didn't wite a paper
SELECT
	s.student_name
    ,IFNULL(p.paper_title, 'NA') AS paper_name
    ,IFNULL(p.paper_grade, 0) AS paper_grade
FROM school_db.students AS s
LEFT JOIN school_db.papers AS p ON s.student_id = p.student_id;

-- 3) get the average grade of each student
SELECT
	s.student_name
    ,TRUNCATE(
		IFNULL(AVG(p.paper_grade), 0)
        ,2
	) AS avg_grade	
FROM school_db.students AS s
LEFT JOIN school_db.papers AS p ON s.student_id = p.student_id
GROUP BY s.student_id
ORDER BY
	avg_grade DESC;
    
-- 4) display the passing status: passing for grades above 60
SELECT
	s.student_name
    ,TRUNCATE(
		IFNULL(AVG(p.paper_grade), 0)
        ,2
	) AS avg_grade
    ,CASE
		WHEN AVG(p.paper_grade) >= 75 THEN 'PASSING'
        ELSE 'FAILING'
	END AS passing_status
FROM school_db.students AS s
LEFT JOIN school_db.papers AS p ON s.student_id = p.student_id
GROUP BY s.student_id
ORDER BY
	avg_grade DESC;
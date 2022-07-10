-- make a DB table that has  list of all of our customers and the total amoun of money that each customer payed
-- we need info from our customers and payments table

-- this is the total amount of payments for each customers
SELECT c.customerName AS 'Customer Name',
CONCAT('€ ', FORMAT(SUM(p.amount), 2)) AS payments -- use FORMAT() to display 2 decimal places and CONCAT() to put the € in it
FROM customers c
JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY c.customerName
ORDER BY c.customerName;


-- CREATE TABLE FROM QUERY
-- how do we save this query as a new table?
-- we need to create the same fields with the same data type and constraints: they have to match
CREATE TABLE IF NOT EXISTS total_amount(
customerName varchar(50) NOT NULL PRIMARY KEY, 
totalPyments decimal(10, 2) NOT NULL -- this has to have same data type and constraints of the field it takes: amount
);

-- we want to insert the query inside the new table --> BE SURE THE TABLE EXISTS!
-- we cannot us ALIAS and FORMAT()
-- syntax: INSERT INTO table_name + query
INSERT INTO total_amount
SELECT c.customerName,
SUM(p.amount)
FROM customers c
JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY c.customerName
ORDER BY c.customerName;

-- now the table should exist in the tables from classicmodels
SHOW TABLES;

-- and if we run a query it should work
SELECT * FROM total_amount;
-- the only problem with this table is that it does not automatically update
-- we can use a VIEW for that


-- VIEWS
-- TABLE: archive purposes, VIEW: live information
-- the view will allow us to run this query as if it was a table and to not modify the DB
-- create a view called 'customers_total_amount' as the query at the beginning
CREATE OR REPLACE VIEW customers_total_amount AS 
SELECT c.customerName AS 'Customer Name',
CONCAT('€ ', FORMAT(SUM(p.amount), 2)) AS payments -- use FORMAT() to display 2 decimal places and CONCAT() to put the € in it
FROM customers c
JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY c.customerName
ORDER BY c.customerName;

-- we can call it now: the difference between the table total_amount and the view customer_total_amount
--  is that the table does not change and is not updated automatically, while the view is when the DB is
SELECT * FROM customers_total_amount;

-- we no longer need the table total_amount (we can do the same with VIEWS: DROP VIEWS)
DROP TABLE total_amount;


-- EXPORT DATA TO A FLAT FILE
-- flat file: txt, csv
-- create a CVS with all the customers and payments
SELECT * FROM customers -- put this query to an out-file
INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\customers.csv' -- \\ means that the backslash is not a delimiter but a real character
FIELDS -- list all the fields
ENCLOSED BY '"' -- this tells the program that everyting inside the field belongs to that field and it's not a delimiter
TERMINATED BY ',' -- specifies the delimiter between each field
ESCAPED BY '\\' -- how do we tell the program what is a field vs an item in the field? a \ which is escaped (double backslashes)
LINES TERMINATED BY '\r\n';-- make a new line by using the new line (\n) and the carriage (\r)
-- https://stackoverflow.com/questions/15433188/what-is-the-difference-between-r-n-r-and-n
-- in the table \N meant that value is NULL


-- IMPORT DATA FROM A CSV FILE (do not run this: the table exists along with the data)
-- copy table and delete data in it, the load the new data from the csv and and dump the compy table
CREATE TABLE customers_copy LIKE customers;

SELECT * FROM customers_copy; -- the table is empty

LOAD DATA
INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\customers.csv'
INTO TABLE classicmodels.customers_copy
FIELDS
-- we need to know how the csv was made (encoled, terminated, escaped, lines terminated)
ENCLOSED BY '"'
TERMINATED BY ','
ESCAPED BY '\\'
LINES TERMINATED BY '\r\n';

SELECT * FROM customers_copy;
-- the data are back

DROP TABLE customers_copy;


-- CREATE A TABLE BY COPYING IT
-- we want to create a table from customers with all the customers that do not have a creditLimit 

-- the empty table we create comes from an existing table
CREATE TABLE IF NOT EXISTS customers_no_credit -- this table will be empty by default
LIKE classicmodels.customers;

-- insert the query with customers with no credit limit into customers_no_credit table
INSERT INTO customers_no_credit
-- get every property of customers with no credit limit: they're 24
SELECT *
FROM classicmodels.customers
WHERE creditLimit = 0;

SELECT * FROM customers_no_credit;


-- CHANGE PK OF A CUSTOMER ACROSS EACH TABLE WHERE THE ID IS PRESENT
-- change the id from 103 to 3001
-- to safely update the id, we're going to use variables
SELECT *
FROM customers;

-- to make the update, turn off the safe updates mode
-- SET sql_safe_updates = 0 -- TURN OFF
-- SET sql_safe_updates = 1 -- TURN ON
-- SET FOREIGN_KEY_CHECKS=0; -- disable FK: otherwise we get error 1451
-- https://stackoverflow.com/questions/1905470/cannot-delete-or-update-a-parent-row-a-foreign-key-constraint-fails

-- variables
SET @oldCustomerNumber = 103; -- SET @oldCustomerNumber = 103; works the same
SET @newCustomerNumber = 3001;

-- in ORDERS the customerNumber is  MUL key, before this update we need to drop the index
-- and make it a MUL key at the end of this process, after the COMMIT
ALTER TABLE classicmodels.orders
DROP INDEX customerNumber;

DESCRIBE orders;

-- use a TRANSACTION so that if any of the statements below fails it won't commit the changes to the DB
-- syntax: START TRANSACTION (put this statement at the very beginning of the update) and COMMIT (at the very end of the update)
START TRANSACTION;

-- update the id in customers
UPDATE customers
SET customerNumber = @newCustomerNumber
WHERE customerNumber = @oldCustomerNumber;

-- update the id in payments
UPDATE payments
SET customerNumber = @newCustomerNumber
WHERE customerNumber = @oldCustomerNumber;

-- update the id in orders
UPDATE orders
SET customerNumber = @newCustomerNumber
WHERE customerNumber = @oldCustomerNumber;
-- update multiple tables
-- https://stackoverflow.com/questions/4361774/mysql-update-multiple-tables-with-one-query

COMMIT; -- commit the info when the TRANSACTION is over
-- DOES NOT WORK FOR SOME REASON! NO COMMIT, NO CHANGE

-- this query will make the customerNumber from the order table a MUL again
ALTER TABLE orders
MODIFY customerNumber int NOT NULL,
ADD KEY(customerNumber);

-- SET FOREIGN_KEY_CHECKS=1; -- enable FK again
-- THIS METHOD DOES NOT WORK
-- even dropping the index and create a MUL key on customerNumber does not work!

-- let's see the table customers
SELECT *
FROM customers
WHERE customerNumber = 3001;


-- PRICE INCREASE
SELECT productCode,
productName,
MSRP
FROM products;

-- let's perform a query to increase the price of items in a way that it affects all the products
UPDATE products
SET msrp = FORMAT(msrp * 1.10, 2)
WHERE productCode > ''; -- here productCode is a varchar not a int --> it will always be larger thatn empty strings ''.
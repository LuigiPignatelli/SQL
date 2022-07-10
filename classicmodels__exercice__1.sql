-- current database
SELECT database();

-- get all dbs
SHOW DATABASES;

-- get the classicmodels db
USE classicmodels;

-- show all the tables from classicmodels
SHOW TABLES;

-- ADDS NEW RECORDS FOR A NEW CUSTOMER
DESCRIBE customers;

INSERT INTO customers
VALUES 
(2001, 'Hometown Baker', 
'Smith', 'Bob', 
'555-222-1212', '123 Mian Street',
NULL, 'Orlando',
'FL', 32801,
'USA', 1370,
22000);
-- on salesRepEmployeeNumber we have a MUL constraint

-- get the new entry
SELECT *
FROM customers
WHERE customerNumber = 2001;


-- CHANGE THE PHONE NUMBER
-- we need to update the phone number
UPDATE customers
SET phone = '555-555-1212'
WHERE customerNumber = 2001;

SELECT *
FROM customers
WHERE customerNumber = 2001;


-- INSERT A NEW VALUE: we do not have to enter all the values because some of them are NULL
INSERT INTO 
customers(
customerNumber, customerName,
contactLastName, contactFirstName,
phone, addressLine1,
city, country)
VALUES 
(2002, 'Betty\'s Pancakes', 
'Doe', 'Betty', 
'555-234-1212', '221 Second Street',
'Orlando', 'USA');

-- when can omit fields that are not manadatory and insert only those values we're concerned about
SELECT *
FROM customers
WHERE customerNumber = 2002;


-- change the state for the costumer 2002
UPDATE customers
SET state = "FL", postalCode = 32801
WHERE customerNumber = 2002;


-- DELETE CUSTOMER 2002: before deleting do a select
DELETE FROM customers
WHERE customerNumber = 2002;

SELECT *
FROM customers
WHERE customerNumber = 2002;
-- we no longer have a record with that customerName
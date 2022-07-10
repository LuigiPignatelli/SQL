-- create database and table

-- change name of the column by using the CHANGE keyword
ALTER TABLE customers
CHANGE contactFirstName customerFirstName varchar(50),
CHANGE contactLastName customerLastName varchar(50);

SELECT *
FROM customers;
-- REMEMBER: changing the name of the column may broke the interface and therefore the code


-- ADD A NEW COLUMN
ALTER TABLE customers
ADD new_column varchar(20);

-- DROP THE COLUMN: here we need to specify that we're deleting a column, but we do not have to specify the data type
ALTER TABLE customers
DROP COLUMN new_column;


-- CHANGE DATATYPE
DESCRIBE customers;

-- what datatype do we want to change
ALTER TABLE customers
MODIFY salesRepEmployeeNumber int(20);
-- the records that are already there will use more memory space
-- warnings 1681: "integer display width is deprecated"


-- CORRUPTED TABLES: if table is corrupted --> check table
-- this will check the status of the table
CHECK TABLE customers;
-- unfortunately we cannot repair this if it was corrupted
-- this is a ODB storage engine: we would have to export the data in a dump file and reimport it
-- "classicmodel.customers" is a FULLY QUALIFIED TABLE NAME --> we can actually use it to perform query
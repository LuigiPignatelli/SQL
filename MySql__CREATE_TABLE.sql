-- create table called "employees" with the following fields: id, first_name, last_name, employement_date, salary
-- be sure we create the table if it does not exist already --> IF NOT EXISTS

-- add COSTRAINTS (NOT NULL, PRIMARY KEY, FOREIGN KEY, UNIQUE, DEFAULT, CHECK)
-- NOT NULL means that the record cannot be empty
-- PRIMARY KEY is the min number of columns we need to uniquely identify a record (in our case it's the employee_id)
-- UNIQUE is a unique field
-- DEFAULT applyes a value to all records of a field
-- CHECK is just like a condition, in fact we can use comparisons(>,<,) and logical (AND/OR) operators
-- FOREIGN KEY (external key) is the key we use in another table to CONNECT TABLES

/*
What is the difference between PRIMARY KEY and UNIQUE? 
The PK, along with the FK, allows us to connect tables
while UNIQUE refers to a field where the records are unique for each id, but they may change in the future
the UNIQUE constraint does not connect tables, as the PK and FK do
*/

-- Employees and Clients tables are not connected but they're both connected to "Client_rels" by their FKs
-- "Client_rels" table will tell us which employee has been assigned to work to the client in the table "Clients" 

-- create the table "Client_rels" which contains all the IDs
-- notice that this tables has its own PK (relationship_id) and it has the same FKs (remade here from scratch) we have in Employees and Clients
-- it will use these FKs to be connected to those table
-- add auto increment to IDs so that we do not have to change it when inserting values

CREATE TABLE IF NOT EXISTS Client_rels(
relationship_id int NOT NULL AUTO_INCREMENT,
client_id int NOT NULL,
employee_id int NOT NULL,
PRIMARY KEY(relationship_id)
);

-- UNSIGNED is a data type and it means we cannot insert a negative integer
CREATE TABLE IF NOT EXISTS Employees(
employee_id int UNSIGNED NOT NULL AUTO_INCREMENT REFERENCES Client_rels(employee_id), -- "references" means that the PK is also a FK elsewhere
first_name varchar(16) NOT NULL,
last_name varchar(16) NOT NULL,
employement_date date NOT NULL,
salary decimal NOT NULL CHECK(salary >= 1200 AND salary <= 3000),
phone_number varchar(10) NOT NULL UNIQUE,
job varchar(20) NOT NULL DEFAULT "developer",
PRIMARY KEY(employee_id)
-- FOREIGN KEY(employee_id) REFERENCES Client_rels(employee_id)
);

CREATE TABLE IF NOT EXISTS Clients(
client_id int UNSIGNED NOT NULL AUTO_INCREMENT REFERENCES Client_rels(client_id),
client_name varchar(30) NOT NULL UNIQUE,
client_address varchar(20) NOT NULL,
client_vat varchar(16) NOT NULL UNIQUE,
client_phone_number varchar(10) NOT NULL UNIQUE,
PRIMARY KEY(client_id)
);

-- drop table to insert auto-increment later
-- DROP TABLE client_rels, Employees, Clients

-- CREATE TABLE IF NOT EXISTS test(
-- fake_id int unsigned NOT NULL AUTO_INCREMENT,
-- col_1 int,  -- if we do not provide a NOT NULL and do not insert the column during the value creation, this col will have a null value
-- col_2 int NOT NULL,
-- PRIMARY KEY(fake_id)

-- DROP TABLE test;


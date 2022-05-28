-- create a peaple table
-- fields: first_name (varchar 20), last_name (varchar 20), age (int)
-- insert a person 

-- SHOW DATABASES;

-- USE test_1; -- use this database

-- SHOW TABLES; -- how many tables do we have in it?

-- create new table
CREATE TABLE IF NOT EXISTS people(
first_name varchar(20) NOT NULL,
last_name varchar(20) NOT NULL,
age int NOT NULL
);

-- insert data in it
INSERT INTO people(first_name, last_name, age)
VALUES
("John", "Fong", 23),
("Berry", "Black", 34),
("James", "Blond", 32),
("Shean", "Old", 66);

SELECT * FROM people;

-- DROP TABLE people;
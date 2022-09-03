-- sql triggers: code that automatically run when a specific table is CHANGES

/*
-- syntax:
CREATE TRIGGER trigger_name
trigger_time trigger_event ON table_name -- these three components are really important
FOR EACH ROW
BEGIN
... --> this code is executed when the trigger_event happens
END;

trigger_time --> AFTER or BEFORE
trigger event (three changes that can trigger our code to run) --> INSERT, UPDATE or DELATE
*/

-- we can use triggers to VALIDATE data or ENFORCE specific operations on our data (check the birthdate to allow adults to sign up)
-- to do validation on our table we need to check the data BEFORE we INSERT them
-- creating/manipulating/deleting other tables relative to our trigger table --> instagram: it may be usefull when someone unfollows
-- a particular accounts --> we can use a trigger where right AFTER that follow is DELETED, we create new ROW --> like a logging

-- two different ways of using triggers: 1) validating data, 2) manipulating other tables


-- CREATE VALIDATION TRIGGER (before inserting data)
-- the trigger is going to check if age is less than 18
CREATE TABLE trigger_test(
	username VARCHAR(100) NOT NULL
    ,age INT NOT NULL
);

INSERT INTO trigger_test(
	username
    ,age
)
VALUES
('Kratos', 22)
,('Inazuma', 21);

-- now we create a TRIGGER which checks the data against the condition
-- rigth before the data is inserted into the table

DELIMITER $$ -- we change the delimiter temporarely because our code would end right after the first semicolon
-- with this line we actually are setting a new delimiter
-- if we try to execute SELECT * FROM table; it won't execute until we use the new delimiter $$
CREATE TRIGGER valid_age
BEFORE INSERT -- we want to run this code before values are inserted into the table
ON trigger_test
FOR EACH ROW -- validation is applied to each row
BEGIN -- start of trigger statement
	IF new.age < 18 THEN -- NEW referes to data that is about to be inserted, opposite to OLD (the previous data/already present in the table)
		SIGNAL SQLSTATE '45000' -- it's part of the error code and means "unhandled user-defined exception"
		-- every time we want to throw an error we use SIGNAL SQLSTETE + NUMBER
		SET message_text = 'not an adult'; -- this is the error message --> the semicolon indicates the end of the SIGNAL STATE
		-- the semicolon means that SQL recognizes the code and execute it and when it's done with it, it goes to the next code to execute
	END IF;
END; -- end of trigger statement
$$ -- this is the new delimiter
DELIMITER; -- set the delimiter back
-- https://dev.mysql.com/doc/mysql-errors/8.0/en/server-error-reference.html

INSERT INTO trigger_test(
	username
    ,age
)
VALUES
('JoJo', 12); -- we get the ERROR: 'not an adult'

INSERT INTO trigger_test(
	username
    ,age
)
VALUES
('Braless Wonder', 30); -- this user has been added successfuly

SELECT *
FROM trigger_test;
-- create new data based on another action
-- AFTER a follow is DELETED we're going to insert a new row

-- 1. create unfollows table
CREATE TABLE IF NOT EXISTS unfollowers(
	follower_id INT UNSIGNED NOT NULL
    ,followee_id INT UNSIGNED NOT NULL
    ,created_at TIMESTAMP DEFAULT NOW()
    ,FOREIGN KEY(follower_id) REFERENCES users(user_id) -- control the user exists in the users table
    ,FOREIGN KEY(followee_id) REFERENCES users(user_id) -- control the user being followed exists in the user table
    ,PRIMARY KEY(follower_id, followee_id) -- a user can only follow another user once
   -- we can have one PK with two values inside 
); -- we're connecting users by their ids

-- CREATE TRIGGER TO TRACK UNFOLLOW EVENTS
DELIMITER $$
CREATE TRIGGER check_unfollow
AFTER DELETE ON followers FOR EACH ROW
BEGIN
	-- this is the code that is going to insert the data into the table
    INSERT INTO unfollowers(
		follower_id
        ,followee_id
    )
    VALUES (OLD.follower_id, OLD.followee_id); -- with the OLD keyword we're saying "get me what was in the table followers"
    -- since this is not a validation we do not need to insert a SIGNAL SQLSTATE
END
$$

DELIMITER ;

-- instead of using the INSERT INTO along with VALUES --> ALTERNATIVE SYNTAX
/*
INSERT INTO table_name
SET column_1 = OLD.value_1
	column_2 = OLD.value_2;
*/

/*
SELECT *
FROM instagram_db.followers
LIMIT 5;
-- let's say user with id 2 unfollows user with id 1
*/


DELETE FROM followers
WHERE follower_id = 2 AND followee_id = 1;

-- if we now see the unfollowers table we get the deleted follower relationship
SELECT *
FROM instagram_db.unfollowers;

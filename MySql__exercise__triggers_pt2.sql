-- EXAMPLE OF VALIDATION USING TRIGGERS
-- prevent users from following themselves
-- use the instagram_db 
DELIMITER $$
CREATE TRIGGER avoid_self_follow -- the trigger_name's name has to be avalid name
BEFORE INSERT ON followers FOR EACH ROW
BEGIN
	-- we need to check that follower_id (the user when is followed) is not the same as the followee_id (user when follows someone else)
    IF NEW.follower_id = NEW.followee_id THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'user cannot follow themselves';
    END IF;
END;
$$ -- remember this is the new delimiter and indicates that this is the end of the trigger
DELIMITER ;

-- CREATE USER TEST (remember that because of the constraint of the FK we cannot insert something that does not exist in the users table)
/*
INSERT INTO users(username)
VALUES ('Kiddo');


SELECT *
FROM instagram_db.users
ORDER BY user_id DESC;
*/

INSERT INTO followers(
	follower_id
	,followee_id
)
VALUES (111, 111); -- Error Code: 1644. user cannot follow themselves


/*
SELECT *
FROM instagram_db.followers
WHERE follower_id = followee_id;

DELETE FROM followers
WHERE follower_id = followee_id;
*/
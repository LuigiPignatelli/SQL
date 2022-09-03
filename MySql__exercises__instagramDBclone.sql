-- 1. find 5 oldest users 
DESCRIBE users;
-- how many users do we have?
SELECT
	COUNT(u.user_id) AS totalUsers
FROM instagram_db.users AS u;


SELECT
	u.username
    ,u.account_creation
FROM instagram_db.users AS u
ORDER BY
	u.account_creation
LIMIT 5;


-- 2. schedule an AD campain: what day of the week do most users register on?
-- V1: in this version we use a subquery in the FORM statement and get the MAX value in the outer query
-- https://stackoverflow.com/questions/12167809/return-all-rows-with-the-max-value-in-sql
SELECT
	tab.day_name
    ,tab.day_week
	,MAX(tab.users) AS max_users
FROM (
	SELECT
		DAYNAME(u.account_creation) AS day_name
		,DAYOFWEEK(u.account_creation) AS day_week
		,COUNT(u.user_id) AS users
	FROM instagram_db.users AS u
	GROUP BY day_week
	ORDER BY users DESC
) AS tab;

-- V2: two separate queries --> in the first one we get the max value and store it in a var
-- in the second one, we use that var in the WHERE statement to get all the values
/*
SELECT @max := max(value) from scores;
SELECT id, value FROM scores WHERE value = @max;
*/
-- 1. gather the info and save the value
SELECT @max_value := MAX(sub.users) AS max_value -- notice: in the MAX(), we're using the "users", which is derived from a COUNT()
FROM (
	SELECT
		COUNT(u.user_id) AS users
	FROM instagram_db.users AS u
	GROUP BY DAYOFWEEK(u.account_creation)
) sub; -- WALRUS operator (:=) is an ASSIGMENT operator in MySql
-- https://dev.mysql.com/doc/refman/8.0/en/assignment-operators.html

-- 2. use the variable @max_value
SELECT
	DAYNAME(u.account_creation) AS day_name
	,DAYOFWEEK(u.account_creation) AS day_week
	,COUNT(u.user_id) AS users
FROM instagram_db.users AS u
GROUP BY day_week
HAVING users = @max_value -- we need to use HAVING because users is a product of a group by
ORDER BY users DESC;

-- V3: join a value to the table and give it the same alias of the main column
-- we need to join two queries, but here is not possible to execute the query down below
/* -- query example
SELECT id, value FROM
scores
INNER JOIN (Select max(value) as value from scores) as max USING(value)
*/


-- 3. find inactive users, those who never posted a photo
SELECT
	u.username
    -- ,p.photo_url
FROM instagram_db.users AS u
LEFT JOIN instagram_db.photos AS p ON u.user_id = p.user_id
WHERE p.photo_url IS NULL;

-- V1: count total inactive users
SELECT
	COUNT(sub.inactive_users) AS total_inactive_users
FROM (
	SELECT
		u.username AS inactive_users
	FROM instagram_db.users AS u
	LEFT JOIN instagram_db.photos AS p ON u.user_id = p.user_id
	WHERE p.photo_url IS NULL
) sub;

-- V2: count total inactive users
/*
SELECT
	(SELECT COUNT(user_id) AS total_users FROM instagram_db.users) - COUNT(tab.username) AS inactive_users
FROM(
	SELECT
		u.username
		,COUNT(p.photo_url) AS num_photos
	FROM instagram_db.users AS u
	INNER JOIN instagram_db.photos AS p ON u.user_id = p.user_id
	GROUP BY u.user_id
	ORDER BY num_photos DESC
) AS tab;
*/


-- 4. most liked photo in our database
-- otherwise we can use the same approach used in problem 2 V1
SELECT @most_liked_photo := MAX(sub.photo_likes) AS most_liked_photo
FROM (
	SELECT
		COUNT(l.photo_id) AS photo_likes
	FROM instagram_db.likes AS l
	GROUP BY
		l.photo_id
) AS sub; -- here we just need to get the number of times that photo is repeated --> it means users liked it

SELECT
	u.username
	,p.photo_url
	,COUNT(l.photo_id) AS photo_likes
FROM instagram_db.users AS u
INNER JOIN instagram_db.photos AS p ON u.user_id = p.user_id
INNER JOIN instagram_db.likes AS l ON p.photo_id = l.photo_id
GROUP BY
	u.user_id
	,p.photo_id
HAVING photo_likes = @most_liked_photo;


-- 5. how many time does the average user post? total number of post / total number of users
SELECT
	ROUND(COUNT(p.photo_id) / COUNT(DISTINCT u.user_id), 2) AS avg_user_post
FROM instagram_db.users AS u
INNER JOIN instagram_db.photos AS p ON u.user_id = p.user_id;


-- 6. top 5 most used tags
SELECT
    -- t.tag_id
    t.tag_content
    ,COUNT(t.tag_content) AS tags_count
    -- ,pt.photo_id
FROM instagram_db.tags AS t
INNER JOIN instagram_db.photos_tags AS pt ON t.tag_id = pt.tag_id
GROUP BY t.tag_id
ORDER BY tags_count DESC
LIMIT 5;


-- 7. find users who have liked every single photo on the site
-- first of all, find the total number of photos
-- users who have as many likes as the existing photos in the DB are bots
SELECT
	COUNT(user_bots.user_id) AS num_user_bots
FROM (
	-- run from this query on to find the users who have liked every photo on our DB
	SELECT
		u.user_id
		,u.username -- users who ever liked anything should be 77
		,COUNT(l.photo_id) AS likes
	FROM instagram_db.users AS u
	INNER JOIN instagram_db.likes AS l ON u.user_id = l.user_id
	GROUP BY u.user_id
	HAVING likes = (
		SELECT
			COUNT(sub.photo_id) AS total_photos
		FROM instagram_db.photos AS sub
		-- get total number of photos
	)
) AS user_bots;


-- BONUS CHALLENGE:
-- find the most popular photo for each user
-- what if the user has two popular photos, how do we get both of them?
SELECT
	sub.user_id
    ,sub.photo_url
	,MAX(sub.likes) AS max_likes_per_user
FROM (
	SELECT
		u.user_id
		,p.photo_url
		,COUNT(l.photo_id) AS likes
	FROM instagram_db.users AS u
	INNER JOIN instagram_db.photos AS p ON u.user_id = p.user_id
	INNER JOIN instagram_db.likes AS l ON p.photo_id = l.photo_id
	GROUP BY
		p.photo_url
) AS sub
GROUP BY
	sub.user_id;


-- find the most popular user
SELECT
	p.user_id
    ,u.username
    ,COUNT(p.photo_id) AS likes
FROM instagram_db.users AS u
INNER JOIN instagram_db.photos AS p ON u.user_id = p.user_id 
INNER JOIN instagram_db.likes AS l ON p.photo_id = l.photo_id
GROUP BY
	p.user_id
ORDER BY
	likes DESC
LIMIT 1;
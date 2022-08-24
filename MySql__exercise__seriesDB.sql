-- MANY-TO-MANY relationship
-- examples:
-- 1) books - authors --> books can be written by many authors, and authors can have many books
-- 2) students - classes --> a student can attend many classes and classes can have many students
-- 3) blog post - tags --> a post can have many tags (twitter) and tags can point to many posts

-- to build our DB we need 3 tables and one table called the "union table" will link the other two tables:
-- TABLES: Reviewers, Reviews (Union table) and Series
-- Reviews has a FK, series_id, pointing to the Series table and a FK, reviewer_id, pointing to the Reviewers table

CREATE DATABASE tv_series_db;

USE tv_series_db;

CREATE TABLE users(
	reviewer_id INT UNSIGNED NOT NULL AUTO_INCREMENT
    ,first_name VARCHAR(10) NOT NULL
    ,last_name VARCHAR(15) NOT NULL
    ,sex CHAR(1)
    ,birth_date DATE NOT NULL
    ,age INT AS (TIMESTAMPDIFF(YEAR, birth_date, NOW()))
    ,PRIMARY KEY(reviewer_id)
);

INSERT INTO users(
	first_name
    ,last_name
    ,sex
    ,birth_date
)
VALUES
('Thomas', 'Stoneman', 'M', '1977-11-24')
,('Wyatt', 'Skaggs', 'M', '1996-12-01')
,('Kimbra', 'Masters', 'F', '1999-06-05')
,('Domingo', 'Cortes', 'M', '1988-02-08')
,('Colt', 'Steele', 'M', '1992-04-03')
,('Pinkie', 'Petit', 'F', '1995-02-26')
,('Marlon', 'Crafford', 'M', '1987-09-15');

SELECT *
FROM reviewers;

CREATE TABLE series(
	series_id INT UNSIGNED NOT NULL AUTO_INCREMENT
    ,series_name VARCHAR(50)
    ,series_year YEAR(4) NOT NULL -- we only want the year to work with: the year(4) DT prevents users from inserting more nums
    ,series_genre VARCHAR(10) NOT NULL
    ,PRIMARY KEY(series_id)
);
-- both the PKs, reviewer_id and series_id, are important because we're going to use them as FKs

INSERT INTO series(
	series_name
    ,series_year
    ,series_genre
)
VALUES
('Archer', 2009, 'Animation')
,('Arrested Development', 2003, 'Comedy')
,("Bob's Burgers", 2011, 'Animation')
,('Bojack Horseman', 2014, 'Animation')
,("Breaking Bad", 2008, 'Drama')
,('Curb Your Enthusiasm', 2000, 'Comedy')
,("Fargo", 2014, 'Drama')
,('Freaks and Geeks', 1999, 'Comedy')
,('General Hospital', 1963, 'Drama')
,('Halt and Catch Fire', 2014, 'Drama')
,('Malcolm In The Middle', 2000, 'Comedy')
,('Pushing Daisies', 2007, 'Comedy')
,('Seinfeld', 1989, 'Comedy')
,('Stranger Things', 2016, 'Drama')
,('Buffy The Vampire Slayer','1997', 'Drama')
,('Frasier', 1993, 'Comedy');

SELECT *
FROM series;

-- the reviews table depends on these two tables
CREATE TABLE reviews(
	review_id INT UNSIGNED NOT NULL AUTO_INCREMENT
    ,rating DECIMAL(2,1) NOT NULL CHECK(rating BETWEEN 0 AND 10)
    ,reviewer_id INT NOT NULL REFERENCES users(reviewer_id)
    ,series_id INT NOT NULL REFERENCES series(series_id)
    ,PRIMARY KEY(review_id)
    -- ,FOREIGN KEY(reviewer_id) REFERENCES reviewers(reviewer_id)
    -- ,FOREIGN KEY(series_id) REFERENCES series(series_id)
);

-- insert data into this table
INSERT INTO reviews(
	series_id
    ,reviewer_id
    ,rating
)
VALUES
(1,1,8.0),(1,2,7.5),(1,3,8.5),(1,4,7.7),(1,5,8.9),
(2,1,8.1),(2,4,6.0),(2,3,8.0),(2,6,8.4),(2,5,9.9),
(3,1,7.0),(3,6,7.5),(3,4,8.0),(3,3,7.1),(3,5,8.0),
(4,1,7.5),(4,3,7.8),(4,4,8.3),(4,2,7.6),(4,5,8.5),
(5,1,9.5),(5,3,9.0),(5,4,9.1),(5,2,9.3),(5,5,9.9),
(6,2,6.5),(6,3,7.8),(6,4,8.8),(6,2,8.4),(6,5,9.1),
(7,2,9.1),(7,5,9.7),
(8,4,8.5),(8,2,7.8),(8,6,8.8),(8,5,9.3),
(9,2,5.5),(9,3,6.8),(9,4,5.8),(9,6,4.3),(9,5,4.5),
(10,5,9.9),
(13,3,8.0),(13,4,7.2),
(14,2,8.5),(14,3,8.9),(14,4,8.9);

SELECT *
FROM reviews;

-- CHALLENGES
-- 1. get the average of each series and the series that have not been rated/watched yet
SELECT
	s.series_name
    ,IFNULL(
		TRUNCATE(
			AVG(r.rating)
			,2
		)
		,0
	) AS avg_rating
    ,COUNT(r.reviewer_id) AS watched
FROM tv_series_db.series AS s
LEFT JOIN tv_series_db.reviews AS r ON s.series_id = r.series_id
LEFT JOIN tv_series_db.users AS u ON r.reviewer_id = u.reviewer_id
GROUP BY -- group by ID is important because the name, for example, can change, while the ID is unique
	s.series_id
ORDER BY avg_rating DESC;


-- 2. how many ratings do we have and how many male and female from our sample watched the show
SELECT
	s.series_name
    ,COUNT(CASE WHEN u.sex = 'M' THEN 1 END) AS male -- by using a combination of COUNT and CASE we can extract one value from a col 
    ,COUNT(CASE WHEN u.sex = 'F' THEN 0 END) AS female
FROM series AS s
LEFT JOIN reviews AS r ON s.series_id = r.series_id
LEFT JOIN users AS u ON r.reviewer_id = u.reviewer_id
GROUP BY
	s.series_id
ORDER BY
	s.series_name;
    

-- 3. how many ratings did each user give to the series watched? and what's the average?
-- get also the min and max and calculate the distance
SELECT
	CONCAT(u.first_name, ' ', u.last_name) AS users
    ,COUNT(r.rating) AS numRatings
    ,IFNULL(
		TRUNCATE(
			AVG(r.rating)
            ,2)
        ,0
	) AS avg_user_rating
	,ROUND(
		IFNULL(VAR_POP(r.rating),0)
        ,2
	) AS variance -- VAR_POP() or VARIANCE(): it calculates the mean and applies the fomula SUM(current_value - avg)^2)/n
    ,IFNULL(MAX(r.rating), 0) AS max_rating
    ,IFNULL(MIN(r.rating), 0) AS min_rating
    ,IFNULL((MAX(r.rating) - MIN(r.rating)), 0) AS distance
    ,CASE
		WHEN COUNT(r.rating) = 0 OR COUNT(r.rating) IS NULL THEN 'INACTIVE'
        ELSE 'ACTIVE'
	END AS user_status
FROM tv_series_db.users AS u
LEFT JOIN tv_series_db.reviews AS r ON u.reviewer_id = r.reviewer_id
GROUP BY
	u.reviewer_id
ORDER BY
	user_status
	,users;
-- what does the variance tell us? on average, the values' distance from the mean is 2.4 for Colt Steele

/*
example of calculated variance:
user = Thomas Stoneman
avg_user_rating = 8.02
n = 5
S = ((8.0 - 8.02)^2 + (8.1 - 8.02)^2 + (7.0 - 8.02)^2 + (7.5 - 8.02)^2 + (9.5 - 8.02)^2)/5
= (0.0004 + 0.0064 + 1.0404 + 0.2704 + 2.1904)/5 -- the variance also has the mean!
*/

-- 4. get only the series that do not have a rating
SELECT
	s.series_name AS unrated_series
    -- ,r.rating
FROM tv_series_db.series AS s
LEFT JOIN tv_series_db.reviews AS r ON s.series_id = r.series_id
WHERE r.rating IS NULL;


-- 5. get the average rating for genre and how many series we have for each genre
SELECT
	-- s.series_name
    s.series_genre
    ,COUNT(s.series_genre) AS all_series
    ,TRUNCATE(
		AVG(IFNULL(r.rating, 0))
        ,2
	) AS avg_rating_all_series
FROM tv_series_db.series AS s
LEFT JOIN tv_series_db.reviews AS r ON s.series_id = r.series_id
GROUP BY
	s.series_genre
ORDER BY
	avg_rating_all_series DESC;
    
-- only voted movies
SELECT
    s.series_genre
    ,COUNT(r.rating) AS users
    ,ROUND(
		AVG(r.rating)
        ,2
	) AS avg_category_rating
FROM tv_series_db.reviews AS r
INNER JOIN tv_series_db.series AS s ON r.series_id = s.series_id
GROUP BY
	s.series_genre
ORDER BY
	avg_category_rating DESC;
    

-- 6. calculate mean rating of the sample and the variance
SELECT
	s.series_genre
    ,ROUND(
		AVG(r.rating)
        ,2
	) AS avg_category_rating
    ,MAX(r.rating) AS max_value
    ,MIN(r.rating) AS min_value
    ,ROUND(
		VAR_POP(r.rating)
        ,2
	) AS variance
FROM tv_series_db.reviews AS r
INNER JOIN tv_series_db.series AS s ON r.series_id = s.series_id
GROUP BY
	s.series_genre
ORDER BY
	avg_category_rating;
-- what does that tell us?
-- the variance is high for drama --> on average the values' distance in the Drama category is 3.61


-- 7. get series, rating and reviewe
USE university_db;

-- 1. all professors
SELECT professors.first_name,
professors.last_name
FROM professors;

-- num of professors
SELECT COUNT(professors.first_name) AS total_num_prof
FROM professors;


-- 2. student's email with age larger than 18
-- we do not have the age field. How do we get this? use this current year and the year of our students
-- to get the current year we need to use the CURDATE() function
SELECT students.first_name,
students.last_name,
students.email
FROM students
WHERE (YEAR(CURDATE()) - YEAR(students.birth_date)) >= 18;

SELECT COUNT(students.first_name) as student_age_18
FROM students
WHERE (YEAR(CURDATE()) - YEAR(students.birth_date)) >= 18;


-- 3. finished courses
-- SELECT COUNT(course_name) AS finished_courses -- number of finished courses
SELECT c.course_name, -- list of finished courses
c.ending_date
FROM courses AS c
WHERE ending_date <= CURDATE(); -- already finished courses


-- 4. next scheduled courses
SELECT course_name,
starting_date
FROM courses
WHERE starting_date >= CURDATE(); -- next courses


-- 5. prossimi corsi che costano meno di [scegli cifra]
SELECT course_name,
cost
FROM courses
WHERE starting_date >= CURDATE() AND cost <= 500;
-- two courses will start after the current date, but only one satisfies the cost condition


-- 6. tutti i corsi di un docente
SELECT
professors.first_name,
professors.last_name,
courses.course_name
FROM professors
JOIN courses on professors.prof_id = courses.prof_id
WHERE professors.prof_id IN (1, 4) -- notice that the WHERE clouse goes after the JOIN
-- WHERE professors.prof_id = 4 AND professors.prof_id = 2 -- t doesn' work because the prof_id can't be 4 and 2 at the same time!
ORDER BY professors.prof_id;


-- 7. tutti i corsi passati di un docente
-- two tables: courses and professors
SELECT p.first_name,
p.last_name,
c.course_name
FROM professors AS p
JOIN courses AS c ON p.prof_id = c.prof_id
WHERE CURDATE() > c.ending_date AND p.prof_id = 1;


-- EXTRA each course with students
SELECT c.course_name,
s.first_name, s.last_name
FROM students AS s
JOIN students_courses AS sc ON sc.student_id = s.student_id
JOIN courses AS c ON c.course_id = sc.course_id
ORDER BY c.course_id;

-- 8. numero studenti iscritti ad un particolare corso
SELECT c.course_name,
COUNT(s.first_name) AS num_students
FROM courses AS c
-- usually the WHERE clause goes here
JOIN students_courses AS sc ON sc.course_id = c.course_id
JOIN students AS s ON s.student_id = sc.student_id -- here we do not need this line --> use something else in COUNT()
WHERE c.course_id = 2 -- to get all the courses with all the participants, comment out this line of code
GROUP BY course_name
ORDER BY c.course_id ASC;


-- 9. corsi che hanno raggiunto capacità massima (we could add a check constraint to the courses table)
SELECT c.course_name,
COUNT(s.first_name) AS num_total_students, -- in here we can just count the num of times the course is repeated as course_id
-- so that this way we do not need the student join 
c.max_capacity
FROM courses AS c
JOIN students_courses AS sc ON c.course_id = sc.course_id
JOIN students AS s ON sc.student_id = s.student_id -- we do not need to use the students table
GROUP BY c.course_name
HAVING COUNT(s.first_name) >= c.max_capacity;


-- 10. numero di corsi frequentati da uno studente
-- here we need two tables: students and students_courses
SELECT
s.first_name, s.last_name,
COUNT(sc.course_id) AS num_courses -- COUNT is the num of times the courses are associated with the student
FROM students AS s
JOIN students_courses AS sc ON s.student_id = sc.student_id
-- WHERE s.student_id = 1 -- to get the courses attended by all students, comment out this line of code
GROUP BY s.first_name, s.last_name;


-- 11. lista di corsi frequentati da uno studente
-- here we need three tables: courses, students_courses and students
SELECT c.course_name,
s.first_name, s.last_name
FROM courses AS c
JOIN students_courses AS sc ON c.course_id = sc.course_id
JOIN students AS s ON sc.student_id = s.student_id
WHERE s.student_id = 1;
-- they key difference with the one above is the COUNT() function that flattens the redundant value for the students


-- 12. calcolare quante volte i corsi sono stati proposti
-- how many tables do we need here? only courses
SELECT c.course_name,
COUNT(c.course_name) AS times_per_course
FROM courses AS c
-- WHERE YEAR(c.ending_date) = "2021" -- this would not allow us to look for the same course in different years
GROUP BY c.course_name
HAVING COUNT(c.course_name) > 1;
-- HAVING COUNT(c.course_name) > 1 AND YEAR(c.ending_date) = "2021"; -- this line does not work this way!
-- only one course was proposed more than once during the 2021


-- 13. l'insegnante con più corsi insegnati
SELECT
table_subquery.prof_fn,
table_subquery.prof_ln,
table_subquery.num_total_courses
-- MAX(num_total_courses) AS num_courses
FROM (
	SELECT p.first_name as prof_fn,
	p.last_name as prof_ln,
	COUNT(c.course_name) AS num_total_courses
	FROM professors AS p
	JOIN courses AS c ON p.prof_id = c.prof_id
	GROUP BY p.first_name, p.last_name
	ORDER BY COUNT(c.course_name) DESC
) as table_subquery;
-- WHERE table_subquery.num_total_courses = (SELECT MAX(table_subquery.num_total_courses) FROM table_subquery);
-- HAVING table_subquery.num_total_courses = MAX(table_subquery.num_total_courses);


-- 14. top 3 studenti più partecipi
SELECT s.first_name,
s.last_name,
COUNT(sc.course_id) AS num_courses
FROM students AS s
JOIN students_courses AS sc ON s.student_id = sc.student_id
GROUP BY s.first_name, s.last_name -- here we can group by sc.student_id
ORDER BY COUNT(sc.course_id) DESC -- use "num_courses"
LIMIT 3;


-- 15. il prossimo corso che abbiamo rilactiato
SELECT c.course_name,
c.starting_date
FROM courses AS c
WHERE c.starting_date > CURDATE()
ORDER BY c.starting_date
LIMIT 1;


-- 16. lista studenti che hanno frequentato i corsi di un insegnante specifico
-- we need three tables: courses and students and students_courses
-- in this query the join can be done on student_id between the table students and students_courses
-- and on course_id between students_courses and courses
SELECT s.first_name,
s.last_name,
c.course_name,
p.last_name
FROM courses AS c
JOIN students_courses AS sc ON c.course_id = sc.course_id
JOIN students AS s ON sc.student_id = s.student_id
JOIN professors AS p ON p.prof_id = c.prof_id -- this last inner join is not necessary because we could use the prof_id in sc or c
WHERE c.prof_id = 1
ORDER BY s.student_id;


-- 13. l'insegnante con più corsi insegnati
SELECT
table_subquery.prof_fn,
table_subquery.prof_ln,
MAX(table_subquery.num_total_courses) AS num_courses
FROM (
	SELECT p.first_name as prof_fn,
	p.last_name as prof_ln,
	COUNT(c.course_name) AS num_total_courses
	FROM professors AS p
	JOIN courses AS c ON p.prof_id = c.prof_id
	GROUP BY p.first_name, p.last_name
	ORDER BY COUNT(c.course_name) DESC
) as table_subquery;
-- WHERE table_subquery.num_total_courses = (SELECT MAX(table_subquery.num_total_courses) FROM table_subquery);
-- HAVING table_subquery.num_total_courses = MAX(table_subquery.num_total_courses);


SELECT p.first_name,
p.last_name,
COUNT(c.course_name) AS num_total_courses
FROM professors AS p
JOIN courses AS c ON p.prof_id = c.prof_id
GROUP BY p.first_name, p.last_name
ORDER BY COUNT(c.course_name) DESC;


-- -------------------------------------------------------------------------------------------------
-- CORRECTIONS

-- 2. EMAIL OF ADULT STUDENTS
-- to get all the user that at the current date are legally considered adults, we can't just get the year
-- because this whould make adults even those that aren't yet --> to get the exact date (not only the year)
-- we need to use DATE_SUB, INTERVAL, YEAR and CURDATE()
-- DATE_SUB subtracts a date from an interval and returns a new date --> DATE_SUB(date, INTERVAL value interval, day||month||year)
SELECT s.first_name,
s.last_name,
s.email
FROM students AS s
WHERE s.birth_date <= DATE_SUB(CURDATE(), INTERVAL 18 YEAR); -- compare whole dates!

SELECT COUNT(s.first_name) AS current_legal_adults
FROM students AS s
WHERE s.birth_date <= DATE_SUB(CURDATE(), INTERVAL 18 YEAR);

/*
SELECT students.first_name,
students.last_name,
students.email
FROM students
WHERE (YEAR(CURDATE()) - YEAR(students.birth_date)) >= 18;
*/

-- quuery n. 6 -- ALTERNATIVE WAY
-- another way of doing this query is to just use the table courses and get the id of the professor, without using the join
SELECT *
FROM courses AS c
WHERE c.prof_id = 1 OR c.prof_id = 2
ORDER BY c.prof_id, c.starting_date;
-- this is much more simpler than joining three tables
/*
SELECT
professors.first_name,
professors.last_name,
courses.course_name
FROM professors
JOIN courses on professors.prof_id = courses.prof_id
WHERE professors.prof_id IN (1, 4)
ORDER BY professors.prof_id;
*/

-- query n. 7 -- ALTERNATIVE WAY
-- since we can use the prof_id inside the courses table, we can just use courses
SELECT *
FROM courses AS c
WHERE c.prof_id = 1 AND CURDATE() > c.ending_date;


-- query n. 8 -- ALTERNATIVE WAY
-- all students attended one particular course
-- can we just use the students_courses table?
SELECT 
COUNT(sc.student_id) AS attending_students
FROM students_courses AS sc
WHERE sc.course_id = 1;

-- query n. 8 -- ALTERNATIVE WAY 1 --> use inner join to get the name of the course
SELECT
c.course_name,
COUNT(sc.student_id) AS attending_students
FROM courses AS c
JOIN students_courses AS sc ON c.course_id = sc.course_id
WHERE sc.course_id = 1;


-- query n. 9 -- ALTERNATIVE WAY: corsi che hanno raggiunto capacità massima
-- to execute this query we just need two tables: courses and students_courses
SELECT c.course_name,
COUNT(sc.course_id) AS num_total_students, -- how many times this course was chosen by a student?
c.max_capacity
FROM courses AS c
JOIN students_courses AS sc ON c.course_id = sc.course_id
GROUP BY c.course_name
HAVING COUNT(sc.course_id) >= c.max_capacity; -- HAVING is applayed on all the calculations we've done before the statement

-- query n. 10 -- ALTERNATIVE WAY --> numero di corsi frequentati da uno studente
-- we can use just one table: students_courses
SELECT sc.student_id,
COUNT(sc.course_id) AS num_courses
FROM students_courses AS sc
WHERE sc.student_id = 1 OR sc.student_id = 7
GROUP BY student_id;

-- query n. 11 -- ALTERNATIVE WAY
-- get two tables: courses and students_courses
SELECT c.course_id,
c.course_name,
sc.student_id
FROM courses AS c
JOIN students_courses AS sc ON c.course_id = sc.course_id
WHERE sc.student_id = 1;

-- query n. 13 -- ALTERNATIVE WAY
-- professor with the highest number of courses
-- one tables: courses
SELECT c.prof_id,
COUNT(c.course_name) AS num_total_courses
FROM courses AS c
GROUP BY c.prof_id
ORDER BY COUNT(c.course_name) DESC;

-- query n. 13 -- ALTERNATIVE WAY 1
SELECT p.first_name,
p.last_name,
COUNT(c.course_name) AS num_total_courses -- how many times prof_id appears on courses --> COUNT(c.prof_id)
FROM professors AS p
JOIN courses AS c ON p.prof_id = c.prof_id
GROUP BY c.prof_id
ORDER BY num_total_courses DESC; -- instead of using COUNT(c.course_name) use the ALIAS


-- query n. 15 -- ALTERNATIVE WAY: first released course
SELECT c.course_name,
c.starting_date
FROM courses AS c
ORDER BY c.starting_date ASC
LIMIT 1; 

-- query n. 16 -- ALTERNATIVE WAY: different order of join
SELECT s.first_name,
s.last_name,
c.prof_id
FROM students AS s
JOIN students_courses AS sc ON s.student_id = sc.student_id
JOIN courses AS c ON c.course_id = sc.course_id
WHERE c.prof_id = 1
GROUP BY s.student_id; -- grouping by ID is the best way to avoid problems when two records share common info
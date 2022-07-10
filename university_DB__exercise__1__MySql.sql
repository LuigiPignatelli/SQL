-- create DB
-- create 4 tables (course, professors, students, students_courses)

-- courses: course_id, course_name, cost, prof_id, student_id, starting_date, ending_date, max_capacity
CREATE TABLE IF NOT EXISTS courses(
course_id int UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT REFERENCES students_courses(course_id),
course_name varchar(20) NOT NULL UNIQUE, -- this is not a unique value!
cost decimal NOT NULL,
starting_date date NOT NULL,
ending_date date NOT NULL,
max_capacity int NOT NULL,
prof_id int NOT NULL
);

-- this should work!
-- ALTER TABLE table_name DROP INDEX index_name (column)
-- ALTER TABLE courses
-- DROP INDEX course_name;

-- professors: prof_id, first_name, last_name,
CREATE TABLE IF NOT EXISTS professors(
prof_id int UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT REFERENCES courses(prof_id),
first_name varchar(10) NOT NULL, 
last_name varchar(15) NOT NULL,
prof_email varchar(20) NOT NULL
);

-- students: student_id, first_name, last_name, email, birth_date
CREATE TABLE IF NOT EXISTS students(
student_id int UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT REFERENCES students_courses(student_id),
first_name varchar(10) NOT NULL,
last_name varchar(15) NOT NULL,
email varchar(20) NOT NULL UNIQUE,
birth_date date
);

-- students courses: id, student_id, ciurse_id
CREATE TABLE IF NOT EXISTS students_courses(
id int UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
student_id int NOT NULL,
course_id int NOT NULL
);

-- UNIQUE constraint should not suppose to be there --> but this has no effect
-- 	course_name	varchar(25)	NO	UNI
/*
ALTER TABLE courses
MODIFY course_name varchar(25) NOT NULL;
*/

-- DESCRIBE courses;


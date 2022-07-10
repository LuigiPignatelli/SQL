-- INSERT DATA FOR STUDENTS,
-- USE university_db;

INSERT IGNORE INTO students(first_name, last_name, email, birth_date)
VALUES
("Vasily", "Smyslov", "vs@gmail.com", "1995-12-01"),
("Jon", "Doe", "jd@yahoo.com", "2010-03-01"),
("Tayler", "Knight", "tk@gmail.com", "1987-01-07"),
("Tony", "Almond", "ta@ghotmail.com", "2000-11-12"),
("Jessica", "Cast", "jc@yahooo.com", "1999-10-10"),
("Margaret", "Hood", "mh@gmail.com", "1995-02-01"),
("Miguel", "Costas", "mc@gmail.com", "1990-07-02"),
("Manuel", "Starl", "ms@gmail.com", "1979-03-14"),
("Karla", "Moon", "km@yahoo.com", "1999-01-01"),
("London", "Murray", "lm@gmail.com", "1992-04-29"),
("Praty", "Pradesh", "pp@hotmail.com", "1991-08-30"),
("Teresa", "Schat", "ts@virgilio.com", "1993-12-25"),
("Paolo", "Madama", "pm@gmail.com", "1994-02-27"),
("Karl", "Smidth", "ks@hotmail.com", "1989-09-01"),
("Otto", "Gerly", "og@hotmail.com", "1988-10-21"),
("Max", "Fey", "mf@yahoo.com", "1997-12-26"),
("Turk", "Ata", "tat@@gmail.com", "1990-02-28"),
("Mark", "Foller", "mfo@yahoo.com", "1991-01-30"),
("Marco", "Rasso","mr@hotmail.com", "2011-01-17"),
("Al", "Gam", "ag@gmail.com", "1998-06-12");


INSERT INTO professors(first_name, last_name, prof_email)
VALUES
("James", "Frinck", "jm67frinck@gmail.com"),
('Cameron', 'Dav', 'cam.dav@yahoo.com'),
('Joseph', 'Strainer', 'joseph.st@gmail.com'),
('Antony', 'Scamuzzi', 'tony99zi@hotmail.com'),
('Lorely', 'Flame', 'flame@yahoo.com'),
('Roger', 'Nelson', 'prince@hotmail.com'),
('Xiang', 'Qua', 'xiang.qua@gmail.com'),
('Jerry', 'Kaspanfeld', 'comedy.j@gmail');


-- INSERT DATE FOR COURSES,
INSERT INTO courses(course_name, cost, starting_date, ending_date, max_capacity, prof_id)
VALUES
("Problem Solving 101", 200, "2021-01-01", "2021-02-28", 7, 1),
("Problem Solving 101", 300, "2021-03-01", "2021-04-30", 10, 3),
("Programming 1", 150, "2021-01-02", "2021-03-31", 10, 2),
("Programming 2", 150, "2021-04-01", "2021-06-01", 12, 4),
("Math 101", 250, "2021-09-01", "2021-12-31", 6, 8),
("Math 102", 300, "2022-01-06", "2022-03-01", 10, 6),
("AI 1", 400, "2021-05-01", "2021-06-01", 9, 7),
("AI 2", 450, "2021-09-01", "2021-11-01", 8, 5),
("Computer Science", 200, "2021-12-01", "2022-02-10", 15, 7),
("Statistics", 200, "2021-11-01", "2022-01-01", 15, 1),
("Programming 3", 300, "2022-09-01", "2022-10-01", 8, 2),
("AI 3", 500, "2022-10-01", "2022-11-01", 6, 4);


-- INSERT DATE FOR STUDENTS-COURSES
INSERT IGNORE INTO students_courses(student_id, course_id)
VALUES
(1, 1), (1, 2), (1, 10),
(2, 10), (2, 9), (2, 11), (2, 12),
(3, 3), (3, 4), (3, 9),
(4, 7), (4, 8), (4, 9),
(5, 5), (5, 6), (5, 9), (5, 10),
(6, 1), (6, 5), (6, 6),
(7, 6), (7, 11), (7, 12),
(8, 6), (8, 1), (8, 2),
(9, 7), (9, 8),
(10, 1), (10, 2), (10, 3), (10, 4),
(11, 5), (11, 8), (11, 10),
(12, 10), (12, 9),
(13, 1), (13, 3), (13, 9),
(14, 6), (14, 1), (14, 5), (14, 8), (14, 10),
(15, 10), (15, 11), (15, 12),
(16, 1), (16, 7), (16, 3),
(17, 2), (17, 4), (17, 7),
(18, 1), (18, 2), (18, 11), (18, 12),
(19, 3), (19, 4), (19, 9), (19, 10),
(20, 3), (20, 4), (20, 5);
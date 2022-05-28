/*
syntax
insert --> this is the keyword we use to reference the field
insert first row with no field
auto-increment
multiple insert
*/

-- "values" --> will be the first row for that table
-- since we have auto_increment we do not need the first field and record

INSERT INTO Clients(client_name, client_address, client_vat, client_city, client_phone_number)
VALUES
("DryCleaning", "Columbus Avenue 10", 4382710291, "NY", 5041321908),
("GrannyCatering", "Jackson Palace 99", "5342938411", "NY", "1045111297"),
("HomeService", "Jackson Palace 2", "2145890132", "LA", "9925788312"),
("GetBetter Inc.", "Elliot Bay Tower 22", "1774598262", "TX", "0453519921"),
("BreakingChemistry", "5th Avenue", "1224598267", "ST", "3334123678"),
("ChocolateFactory", "Columbus street 19", "9343218870", "NW", "4453212920");

-- INSERT INTO test(col_2)
-- VALUES(22)

-- INSERT INTO employees(first_name, last_name, employement_date, salary, phone_number, job) -- the id field is auto_incremented, we do not need it here
-- VALUES
-- ("Michael", "Scrot", "1999-01-1", 1800, "3332415890", "Regional Manager"),
-- ("Jerry", "Sainfidu", "1999-11-30", 1200, "4321119785", "Cloud Developer"),
-- ("Elen", "Bane", "1999-12-29", 1200, "2236457011", "Developer");

/* INSERT INTO employees(first_name, last_name, employement_date, salary, phone_number, job)
VALUES
("Tony", "Hill", "1999-03-7", 1350, "1023456789", "Front End"),
("Mary","Mounts","1999-04-12",1500,"1122056789","Mobile Developer"),
("Pamela","Beet", "1999-01-1", 1200, "3214569870", "Secretary");
*/

INSERT INTO employees(first_name, last_name, employement_date, salary, phone_number, job)
VALUES
("Michael", "Scrot", "1999-01-1", 1800, "3332415890", "Regional Manager"),
("Jerry", "Sainfidu", "1999-11-30", 1200, "4321119785", "Cloud Developer"),
("Elen", "Bane", "1999-12-29", 1200, "2236457011", "Developer"),
("Tony", "Hill", "1999-03-7", 1350, "1023456789", "Front End"),
("Mary","Mounts","1999-04-12",1500,"1122056789","Mobile Developer"),
("Pamela","Beet", "1999-01-1", 1200, "3214569870", "Secretary"),
("Marco", "Rossi", "2000-03-2", 1450, 1214398990, "Front End"),
("Tarmicle", "Roving", "2000-03-7", 1600, 1124519875, "Back End"),
("Fiona", "Germi", "2000-03-10", 1500, 9451039875, "Cloud Developer");


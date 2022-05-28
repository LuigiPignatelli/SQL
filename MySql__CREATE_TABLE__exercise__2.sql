CREATE TABLE IF NOT EXISTS pastries(
pastrie_id int UNSIGNED NOT NULL AUTO_INCREMENT,
pastrie_name varchar(15) NOT NULL UNIQUE,
pastrie_quantity int UNSIGNED NOT NULL,
pastrie_origin varchar(15) NULL,
PRIMARY KEY(pastrie_id)
);

-- INSERT INTO pastries(pastrie_name, pastrie_quantity, pastrie_origin)
-- VALUES
-- ("cannolo", 3, "Sicily"),
-- ("zeppola", 4, "Apulia"),
-- ("bignè", 5, "Campania");

SELECT * FROM pastries;
SHOW COLUMNS FROM pastries;
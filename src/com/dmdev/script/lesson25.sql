-- https://www.postgresql.org/docs/current/sql-altertable.html

ALTER TABLE IF EXISTS employee
    ADD COLUMN gender INT;

UPDATE employee
set gender = 0
WHERE id > 5;

UPDATE employee
set gender = 1
WHERE id <= 5;

ALTER TABLE employee
    ALTER COLUMN gender SET NOT NULL;

ALTER TABLE employee
    DROP COLUMN gender;

SELECT *
FROM employee;
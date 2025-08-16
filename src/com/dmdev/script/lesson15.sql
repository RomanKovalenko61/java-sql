SELECT *
FROM employee;

UPDATE employee
SET company_id = 1,
    salary     = 1700
WHERE id = 10
RETURNING *;

UPDATE employee
SET company_id = 1,
    salary     = 1700
WHERE id = 10 OR id = 9
RETURNING id, first_name || ' ' || employee.last_name fio;
SELECT avg(empl.salary)
FROM (SELECT *
      FROM employee
      ORDER BY salary DESC
      LIMIT 2) empl;

SELECT *,
       (SELECT avg(salary) FROM employee) avg,
       (SELECT max(salary) FROM employee) max
FROM employee;

SELECT *,
       (SELECT max(salary) FROM employee) - salary diff
FROM employee;

SELECT *
FROM employee
WHERE company_id IN (1, 2);

SELECT *
FROM employee
WHERE company_id IN (SELECT id FROM company WHERE date > '2000-01-01');

SELECT *
FROM (VALUES (1, 'Google', '2001-01-01'),
             (2, 'Apple', '2002-10-29'),
             (3, 'Facebook', '1995-09-13')) t
-- https://postgrespro.ru/docs/postgresql/current/functions-window

SELECT *
FROM company;

INSERT INTO employee (first_name, last_name, company_id, salary)
VALUES ('Vasya', 'Petrov', 2, 3000),
       ('Sid', 'Sidorov', 3, 2800),
       ('Bro', 'Brown', 1, 5000);

SELECT *
FROM employee;

SELECT c.name,
       count(e.id)
FROM company c
         LEFT JOIN employee e ON e.company_id = c.id
GROUP BY c.name
ORDER BY c.name;

SELECT count(e.id)
FROM company c
         LEFT JOIN employee e ON e.company_id = c.id;

SELECT c.name,
       e.last_name,
       e.salary,
--       count(e.id) OVER (),
--       max(salary) OVER (PARTITION BY c.name),
--       min(salary) OVER (PARTITION BY c.name)
       lag(e.salary) OVER (ORDER BY e.salary) - e.salary
--       avg(salary) OVER (),
--        row_number() OVER (PARTITION BY c.name),
--        dense_rank() OVER (PARTITION BY c.name ORDER BY salary NULLS FIRST ) -- rank() OVER (ORDER BY salary NULLS FIRST )
FROM company c
         LEFT JOIN employee e ON e.company_id = c.id
ORDER BY c.name;
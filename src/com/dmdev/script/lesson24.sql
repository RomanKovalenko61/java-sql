SELECT *
FROM (SELECT c.name,
             e.last_name,
             e.salary,
--       count(e.id) OVER (),
             max(salary) OVER (PARTITION BY c.name),
             min(salary) OVER (PARTITION BY c.name),
             lag(e.salary) OVER (ORDER BY e.salary) - e.salary
      --       avg(salary) OVER (),
--        row_number() OVER (PARTITION BY c.name),
--        dense_rank() OVER (PARTITION BY c.name ORDER BY salary NULLS FIRST ) -- rank() OVER (ORDER BY salary NULLS FIRST )
      FROM company c
               LEFT JOIN employee e ON e.company_id = c.id
      ORDER BY c.name) t
WHERE name = 'Facebook';

CREATE VIEW employee_view AS
SELECT c.name,
       e.last_name,
       e.salary,
--       count(e.id) OVER (),
       max(salary) OVER (PARTITION BY c.name),
       min(salary) OVER (PARTITION BY c.name),
       lag(e.salary) OVER (ORDER BY e.salary) - e.salary
--       avg(salary) OVER (),
--        row_number() OVER (PARTITION BY c.name),
--        dense_rank() OVER (PARTITION BY c.name ORDER BY salary NULLS FIRST ) -- rank() OVER (ORDER BY salary NULLS FIRST )
FROM company c
         LEFT JOIN employee e ON e.company_id = c.id
ORDER BY c.name;

SELECT *
FROM employee_view
WHERE name = 'Facebook';

CREATE MATERIALIZED VIEW m_employee_view AS
SELECT c.name,
       e.last_name,
       e.salary,
--       count(e.id) OVER (),
       max(salary) OVER (PARTITION BY c.name),
       min(salary) OVER (PARTITION BY c.name),
       lag(e.salary) OVER (ORDER BY e.salary) - e.salary
--       avg(salary) OVER (),
--        row_number() OVER (PARTITION BY c.name),
--        dense_rank() OVER (PARTITION BY c.name ORDER BY salary NULLS FIRST ) -- rank() OVER (ORDER BY salary NULLS FIRST )
FROM company c
         LEFT JOIN employee e ON e.company_id = c.id
ORDER BY c.name;

SELECT *
FROM m_employee_view
WHERE max = 5000;

INSERT INTO employee (first_name, last_name, company_id, salary)
VALUES ('Rich', 'Gold', 1, 1340);

-- Не увидим нового сотрудника. Чтобы его увидеть надо обновить view
SELECT *
FROM m_employee_view;

-- Увидим нового сотрудника
SELECT *
FROM employee_view;

REFRESH MATERIALIZED VIEW m_employee_view;

-- Теперь видим нового сотрудника т.к. Обновили view
SELECT *
FROM m_employee_view;
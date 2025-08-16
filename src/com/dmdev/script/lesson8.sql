INSERT INTO employee(first_name, last_name, salary)
VALUES ('Ivan', 'Sidorov', 500),
       ('Ivan', 'Ivanov', 1000),
       ('Petr', 'Petrov', 2000),
       ('Sveta', 'Svetikova', 1500);

SELECT DISTINCT id,
                first_name f_name,
                last_name  l_name,
                salary
FROM employee empl
ORDER BY f_name, salary DESC
LIMIT 2
OFFSET 2;
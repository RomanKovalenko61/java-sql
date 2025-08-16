-- объединяет выборки
SELECT first_name
FROM employee
WHERE company_id IS NOT NULL
UNION ALL
SELECT first_name
FROM employee
WHERE salary IS NULL;

-- обрезает дубли
SELECT first_name
FROM employee
WHERE company_id IS NOT NULL
UNION
SELECT first_name
FROM employee
WHERE salary IS NULL;

SELECT id, first_name
FROM employee
WHERE company_id IS NOT NULL
UNION
SELECT id, first_name
FROM employee
WHERE salary IS NULL;

-- для удаления дубликатов из одного SELECT можно использовать DISTINCT
SELECT DISTINCT first_name
FROM employee
WHERE company_id IS NOT NULL
UNION ALL
SELECT first_name
FROM employee
WHERE salary IS NULL;
-- https://postgrespro.ru/docs/postgresql/current/functions

-- sum, avg, max, min, count
-- upper, lower
-- concat, first_name || ' ' || last_name
-- now
-- see pg_catalog -> routines all functions
-- see pg_catalog -> operators all operators
SELECT lower(first_name),
       first_name || ' ' || last_name fio,
       now()
FROM employee empl;

SELECT now(), 1 * 2 + 3;
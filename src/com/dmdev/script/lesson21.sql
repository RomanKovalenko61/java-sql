SELECT c.name,
       e.first_name
FROM company c
         LEFT JOIN employee e
                   ON c.id = e.company_id;

SELECT c.name,
       e.first_name
FROM employee e
         LEFT JOIN company c
                   ON c.id = e.company_id;

SELECT c.name,
       e.first_name
FROM employee e
         RIGHT JOIN company c
                    ON c.id = e.company_id;


SELECT c.name,
       e.first_name
FROM employee e
         FULL JOIN company c
                   ON c.id = e.company_id;
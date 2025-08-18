SELECT count(*)
FROM company;

SELECT c.name,
       e.first_name
FROM company c
         LEFT JOIN employee e ON c.id = e.company_id;

SELECT c.name,
       count(e.id) cnt
FROM company c
         LEFT JOIN employee e ON c.id = e.company_id
GROUP BY c.id;

SELECT c.name,
       count(e.id) cnt
FROM company c
         LEFT JOIN employee e ON c.id = e.company_id
GROUP BY c.id
HAVING count(e.id) > 0;
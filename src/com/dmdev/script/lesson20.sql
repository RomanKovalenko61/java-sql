-- ALTER SEQUENCE employee_id_seq RESTART WITH 1;


CREATE TABLE company
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(128) UNIQUE NOT NULL,
    date DATE                NOT NULL CHECK ( date > '1995-01-01' AND date < '2020-01-01')
);

INSERT INTO company (name, date)
VALUES ('Google', '2001-01-01'),
       ('Apple', '2002-10-29'),
       ('Facebook', '1995-09-13'),
       ('Amazon', '2005-06-17');

SELECT *
FROM company;

CREATE TABLE employee
(
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR(128) NOT NULL,
    last_name  VARCHAR(128) NOT NULL,
    company_id INT REFERENCES company (id) ON DELETE CASCADE,
    salary     INT,
    UNIQUE (first_name, last_name)
);

INSERT INTO employee(first_name, last_name, salary, company_id)
VALUES ('Ivan', 'Sidorov', 500, 1),
       ('Ivan', 'Ivanov', 1000, 2),
       ('Arni', 'Paramonov', NULL, 2),
       ('Petr', 'Petrov', 2000, 3),
       ('Sveta', 'Svetikova', 1500, NULL);

SELECT *
FROM employee;

CREATE TABLE contact
(
    id     SERIAL PRIMARY KEY,
    number VARCHAR(9) NOT NULL,
    type   TEXT
);

INSERT INTO contact(number, type)
VALUES ('234-56-78', 'домашний'),
       ('987-65-43', 'рабочий'),
       ('565-25-91', 'мобильный'),
       ('332-55-67', NULL),
       ('465-11-22', NULL);

SELECT *
FROM contact;

CREATE TABLE employee_contact
(
    employee_id INT REFERENCES employee (id),
    contact_id  INT REFERENCES contact (id)
);

INSERT INTO employee_contact
VALUES (1, 1),
       (1, 2),
       (2, 2),
       (2, 3),
       (2, 4),
       (3, 5);

SELECT *
FROM employee_contact;

-- Декартово произведение каждый с каждым
SELECT company.name,
       employee.first_name || ' ' || employee.last_name fio
FROM employee,
     company;

-- аналог JOIN
SELECT company.name,
       employee.first_name || ' ' || employee.last_name fio
FROM employee,
     company
WHERE employee.company_id = company.id;

-- (INNER) JOIN
-- CROSS JOIN
-- LEFT (OUTER) JOIN
-- RIGHT (OUTER) JOIN
-- FULL (OUTER) JOIN

SELECT c.name,
       employee.first_name || ' ' || employee.last_name fio
FROM employee
         JOIN company c
              ON employee.company_id = c.id;

SELECT c.name,
       employee.first_name || ' ' || employee.last_name fio,
       ec.contact_id,
       -- c2.number || ' ' || c2.type
       concat(c2.number, ' ', c2.type) -- ignored null
FROM employee
         JOIN company c
              ON employee.company_id = c.id
         JOIN employee_contact ec ON employee.id = ec.employee_id
         JOIN contact c2 ON c2.id = ec.contact_id;

SELECT *
FROM company
         CROSS JOIN (SELECT count(*) FROM employee) t;
CREATE TABLE employee
(
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR(128) NOT NULL,
    last_name  VARCHAR(128) NOT NULL,
    company_id INT REFERENCES company (id),
    salary     INT,
    UNIQUE (first_name, last_name)
--     FOREIGN KEY (company_id) REFERENCES company (id)
);

DROP TABLE employee;

INSERT INTO employee(first_name, last_name, salary, company_id)
VALUES ('Ivan', 'Sidorov', 500, 1),
       ('Ivan', 'Ivanov', 1000, 2),
       ('Arni', 'Paramonov', NULL, 2),
       ('Petr', 'Petrov', 2000, 3),
       ('Sveta', 'Svetikova', 1500, NULL);
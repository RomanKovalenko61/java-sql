
-- https://postgrespro.ru/docs/postgresql/current/sql-createtrigger
-- https://postgrespro.ru/docs/postgresql/current/pltcl-trigger
-- https://habr.com/ru/companies/otus/articles/857396/

-- before
INSERT INTO aircraft (model)
VALUES ('new boeing');
-- after


CREATE TABLE audit
(
    id         INT,
    table_name TEXT,
    date       TIMESTAMP
);

CREATE OR REPLACE FUNCTION audit_function() RETURNS TRIGGER
    LANGUAGE plpgsql
AS
$$
begin
    INSERT INTO audit (id, table_name, date)
    VALUES (new.id, tg_table_name, now());
    return null; -- new old
end;
$$;

CREATE TRIGGER audit_aircraft_trigger
    AFTER UPDATE OR INSERT OR DELETE
    ON aircraft
    FOR EACH ROW
EXECUTE FUNCTION audit_function();

INSERT INTO aircraft (model)
VALUES ('new boeing');

SELECT *
FROM audit;
SELECT *
FROM ticket
WHERE id = 29
  AND passenger_no = 'DSA581';

SELECT id
FROM ticket
WHERE id = 29;

CREATE UNIQUE INDEX unique_flight_id_seat_no_idx ON ticket (flight_id, seat_no);
-- flight_id + seat_no

SELECT *
FROM ticket
WHERE flight_id = 5; -- Index

SELECT *
FROM ticket
WHERE seat_no = 'B1'; -- Full scan

SELECT *
FROM ticket
WHERE seat_no = 'B1'
  AND flight_id = 5; -- Maybe Index

SELECT count(distinct flight_id) FROM ticket; -- 9
SELECT count(flight_id) FROM ticket; -- 55
--  Селективность 9 / 55 = 0.163 плохая ниже 20 процентов. Ближе к 1 самое то
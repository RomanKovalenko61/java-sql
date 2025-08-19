VALUES (1, 2), (3, 4), (5, 6), (7, 8)
UNION
VALUES (1, 2), (3, 4), (5, 6), (7, 8);

VALUES (1, 2), (3, 4), (5, 6), (7, 8)
UNION ALL
VALUES (1, 2), (3, 4), (5, 6), (7, 8);

VALUES (1, 2), (3, 4), (5, 6), (7, 8)
INTERSECT
VALUES (1, 2), (3, 4), (5, 6), (7, 8);

VALUES (1, 2), (3, 4), (5, 6), (7, 8)
INTERSECT
VALUES (1, 2), (3, 4), (5, 6), (7, 11);

VALUES (1, 2), (3, 4), (5, 6), (7, 8)
EXCEPT
VALUES (1, 2), (3, 4), (5, 6), (7, 11);

-- 3 variant
SELECT aircraft_id,
       s.seat_no
FROM seat s
WHERE aircraft_id = 1
EXCEPT
SELECT f.aircraft_id,
       t.seat_no
FROM ticket t
         JOIN flight f ON f.id = t.flight_id
WHERE f.flight_no = 'MN3002'
  AND f.departure_date::date = '2020-06-14';
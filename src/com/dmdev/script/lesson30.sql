EXPLAIN
SELECT *
FROM ticket;
-- Seq Scan on ticket  (cost=0.00..1.55 rows=55 width=60)

-- Seq Scan on ticket  (cost=0.00..1.69 rows=9 width=60)
--   Filter: ((passenger_name)::text ~~ 'Иван%'::text)
EXPLAIN
SELECT *
FROM ticket
WHERE passenger_name LIKE 'Иван%';


-- Seq Scan on ticket  (cost=0.00..1.82 rows=1 width=60)
--   Filter: (((passenger_name)::text ~~ 'Иван%'::text) AND ((seat_no)::text = 'B1'::text))
EXPLAIN
SELECT *
FROM ticket
WHERE passenger_name LIKE 'Иван%'
  AND seat_no = 'B1';


-- HashAggregate  (cost=1.82..1.92 rows=9 width=16)
--   Group Key: flight_id
--   ->  Seq Scan on ticket  (cost=0.00..1.55 rows=55 width=8)
EXPLAIN
SELECT flight_id,
       count(*)
FROM ticket
GROUP BY flight_id;

-- HashAggregate  (cost=1.96..2.08 rows=9 width=48)
--   Group Key: flight_id
--   ->  Seq Scan on ticket  (cost=0.00..1.55 rows=55 width=8)
EXPLAIN
SELECT flight_id,
       count(*),
       sum(cost)
FROM ticket
GROUP BY flight_id;

-- синтаксический (rule-based) давно не используется
-- стоимостной (cost-based)

-- page-cost (input-output) = 1.0
-- cpu_cost = 0.01

-- 55 * 0.01 = 0.55 (cpu_cost)
-- 1 * 1.0 = 1.0 (page_cost)
-- summary 1.55

--  8 + 6 + 28 + 8 + 2 + 8 = 60    width = 60

SELECT avg(bit_length(passenger_no) / 8),
       avg(bit_length(passenger_name) / 8),
       avg(bit_length(seat_no) / 8)
FROM ticket;

SELECT reltuples,
       relkind,
       relpages
FROM pg_class
WHERE relname = 'ticket'; -- reltuples=55 relkind = 'r' relpages = 1
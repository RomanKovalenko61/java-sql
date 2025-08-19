
-- nested loop
-- hash join
-- merge join

EXPLAIN ANALYSE
SELECT *
FROM test1
WHERE number1 < 1000;
-- Bitmap Heap Scan on test1  (cost=91.09..796.11 rows=5522 width=17) (actual time=0.267..1.076 rows=5571 loops=1)
--   Recheck Cond: (number1 < 1000)
--   Heap Blocks: exact=594
--   ->  Bitmap Index Scan on test1_number1_idx  (cost=0.00..89.71 rows=5522 width=0) (actual time=0.209..0.209 rows=5571 loops=1)
--         Index Cond: (number1 < 1000)
-- Planning Time: 0.075 ms
-- Execution Time: 1.223 ms


CREATE TABLE test2
(
    id       SERIAL PRIMARY KEY,
    test1_id INT REFERENCES test1 (id) NOT NULL,
    number1  INT                       NOT NULL,
    number2  INT                       NOT NULL,
    value    VARCHAR(32)               NOT NULL
);

INSERT INTO test2 (test1_id, number1, number2, value)
SELECT id,
       random() * number1,
       random() * number2,
       value
FROM test1;

CREATE INDEX test2_number1_idx ON test2 (number1);
CREATE INDEX test2_number2_idx ON test2 (number2);

EXPLAIN ANALYSE
SELECT *
FROM test1
         JOIN test2 t ON test1.id = t.test1_id
LIMIT 100;
-- Limit  (cost=0.29..36.58 rows=100 width=38) (actual time=0.013..0.151 rows=100 loops=1)
--   ->  Nested Loop  (cost=0.29..36284.95 rows=100000 width=38) (actual time=0.012..0.146 rows=100 loops=1)
--         ->  Seq Scan on test2 t  (cost=0.00..1637.00 rows=100000 width=21) (actual time=0.008..0.012 rows=100 loops=1)
--         ->  Index Scan using test1_pkey on test1  (cost=0.29..0.35 rows=1 width=17) (actual time=0.001..0.001 rows=1 loops=100)
--               Index Cond: (id = t.test1_id)
-- Planning Time: 0.739 ms
-- Execution Time: 0.178 ms

EXPLAIN ANALYSE
SELECT *
FROM test1 t1
         JOIN test2 t2
              ON t1.id = t2.test1_id;
-- Hash Join  (cost=2886.00..4785.51 rows=100000 width=38) (actual time=13.961..56.121 rows=100000 loops=1)
--   Hash Cond: (t2.test1_id = t1.id)
--    ->  Seq Scan on test2 t2  (cost=0.00..1637.00 rows=100000 width=21) (actual time=0.008..5.969 rows=100000 loops=1)
--   ->  Hash  (cost=1636.00..1636.00 rows=100000 width=17) (actual time=15.229..15.230 rows=100000 loops=1)
--         Buckets: 131072  Batches: 1  Memory Usage: 5896kB
--         ->  Seq Scan on test1 t1  (cost=0.00..1636.00 rows=100000 width=17) (actual time=0.005..4.569 rows=100000 loops=1)
-- Planning Time: 0.159 ms
-- Execution Time: 57.566 ms


EXPLAIN ANALYSE
SELECT *
FROM test1 t1
         JOIN (SELECT *
               FROM test2
               ORDER BY test1_id) t2 ON t1.id = t2.test1_id
ORDER BY t1.id;
-- Merge Join  (cost=11993.16..16986.06 rows=100000 width=38) (actual time=25.328..74.873 rows=100000 loops=1)
--   Merge Cond: (test2.test1_id = t1.id)
--   ->  Sort  (cost=11992.82..12242.82 rows=100000 width=21) (actual time=25.300..32.739 rows=100000 loops=1)
--         Sort Key: test2.test1_id
--         Sort Method: external merge  Disk: 3128kB
--         ->  Seq Scan on test2  (cost=0.00..1637.00 rows=100000 width=21) (actual time=0.008..4.811 rows=100000 loops=1)
--   ->  Index Scan using test1_pkey on test1 t1  (cost=0.29..3243.29 rows=100000 width=17) (actual time=0.023..12.282 rows=100000 loops=1)
-- Planning Time: 0.171 ms
-- Execution Time: 78.420 ms

-- 1 4 5 6 8 9 10 22 ... test2.test1_id
-- 1 2 4 5 7 9 10 18 ... test1.id
-- 1 4 5 9 10 ...


CREATE INDEX test2_test1_id_idx ON test2 (test1_id);

EXPLAIN ANALYSE
SELECT *
FROM test1 t1
         JOIN test2 t2 ON t1.id = t2.test1_id
ORDER BY t1.id;
-- Merge Join  (cost=0.69..7987.34 rows=100000 width=38) (actual time=0.014..65.568 rows=100000 loops=1)
--   Merge Cond: (t1.id = t2.test1_id)
--   ->  Index Scan using test1_pkey on test1 t1  (cost=0.29..3243.29 rows=100000 width=17) (actual time=0.006..13.731 rows=100000 loops=1)
--   ->  Index Scan using test2_test1_id_idx on test2 t2  (cost=0.29..3244.29 rows=100000 width=21) (actual time=0.005..14.446 rows=100000 loops=1)
-- Planning Time: 0.631 ms
-- Execution Time: 68.140 ms
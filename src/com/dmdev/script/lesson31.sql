--  Т.к. Таблица маленькая нет смысли читать индекс (еще одна страница), сразу читаем таблицу с диска
-- Индекс хранит номер страницы на диске, в котором хранится искомая строчка
EXPLAIN
SELECT *
FROM ticket
WHERE id = 25;

CREATE TABLE test1
(
    id      SERIAL PRIMARY KEY,
    number1 INT         NOT NULL,
    number2 INT         NOT NULL,
    value   VARCHAR(32) NOT NULL
);

CREATE INDEX test1_number1_idx ON test1 (number1);
CREATE INDEX test1_number2_idx ON test1 (number2);

INSERT INTO test1 (number1, number2, value)
SELECT random() * generate_series,
       random() * generate_series,
       generate_series
FROM generate_series(1, 100000);

SELECT relname,
       reltuples,
       relkind,
       relpages
FROM pg_class
WHERE relname LIKE 'test1%';

ANALYSE test1;

EXPLAIN
SELECT *
FROM test1
WHERE number1 = 1000; -- Index scan

EXPLAIN
SELECT *
FROM test1
WHERE number1 = 1000
  AND value = '123'; -- Index scan

EXPLAIN
SELECT *
FROM test1
WHERE number1 = 1000
   OR value = '123'; -- Seq scan

EXPLAIN
SELECT number1
FROM test1
WHERE number1 = 1000; -- Index only scan

EXPLAIN
SELECT number1, value
FROM test1
WHERE number1 = 1000; -- Index scan

EXPLAIN
SELECT *
FROM test1
WHERE number1 < 1000 AND number1 > 90000; -- Bitmap Heap Scan on test1  (cost=13.42..647.76 rows=500 width=17)

-- index only scan
-- index scan
-- bitmap scan (index scan, heap scan) Последовательность 0 и 1, потом по ней решается какие страницы нужно просканировать

-- 0 0 0 0 0 0 0 0 0 0 0 0 ...  636 times
-- 0 1 0 0 1 0 1 1 0 0 0 0    считываем batch найденные страницы и recheck условия выборки

-- склеиваем два bitmap где-либо в одном есть 1
EXPLAIN
SELECT *
FROM test1
WHERE number1 < 1000 OR number2 > 90000;
-- Bitmap Heap Scan on test1  (cost=106.21..835.30 rows=6169 width=17)
--   Recheck Cond: ((number1 < 1000) OR (number2 > 90000))
--   ->  BitmapOr  (cost=106.21..106.21 rows=6206 width=0)
--         ->  Bitmap Index Scan on test1_number1_idx  (cost=0.00..89.71 rows=5522 width=0)
--               Index Cond: (number1 < 1000)
--         ->  Bitmap Index Scan on test1_number2_idx  (cost=0.00..13.42 rows=684 width=0)
--               Index Cond: (number2 > 90000)

-- склеиваем два bitmap где оба 1
EXPLAIN
SELECT *
FROM test1
WHERE number1 < 1000 AND number2 > 90000;
-- Bitmap Heap Scan on test1  (cost=103.40..225.20 rows=38 width=17)
--  Recheck Cond: ((number2 > 90000) AND (number1 < 1000))
--  ->  BitmapAnd  (cost=103.40..103.40 rows=38 width=0)
--        ->  Bitmap Index Scan on test1_number2_idx  (cost=0.00..13.42 rows=684 width=0)
--              Index Cond: (number2 > 90000)
--        ->  Bitmap Index Scan on test1_number1_idx  (cost=0.00..89.71 rows=5522 width=0)
--              Index Cond: (number1 < 1000)


-- добавили еще Filter: ((value)::text = '123'::text) после   ->  BitmapAnd  (cost=103.38..103.38 rows=38 width=0)
-- и дополнили  Recheck Cond: ((number2 > 90000) AND (number1 < 1000))
EXPLAIN
SELECT *
FROM test1
WHERE number1 < 1000 AND number2 > 90000 AND value = '123';
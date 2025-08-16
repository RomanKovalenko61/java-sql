SELECT DISTINCT id,
                first_name f_name,
                last_name  l_name,
                salary
FROM employee empl
WHERE salary IN (1000, 1100, 2000)
   OR (first_name LIKE 'Iv%'
    AND last_name ILIKE '%ov%')
ORDER BY f_name, salary DESC;
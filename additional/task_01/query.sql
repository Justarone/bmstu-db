WITH times AS (
    SELECT DISTINCT t1.id, var1, var2, greatest(t1.valid_from_dttm, t2.valid_from_dttm) AS valid_from_dttm,
    least(t1.valid_to_dttm, t2.valid_to_dttm) AS valid_to_dttm
    FROM table1 t1
    JOIN table2 t2
    ON t1.id = t2.id
)
SELECT *
FROM times
WHERE valid_from_dttm <= valid_to_dttm
ORDER BY valid_from_dttm;

WITH numbered AS (
    SELECT ROW_NUMBER() OVER(
        PARTITION BY fio, status
        ORDER BY day_date
    ) AS i, fio, status, day_date
    from empls_visits
)
SELECT fio, status, min(day_date) as date_from,
max(day_date) as date_to
FROM numbered n
group by fio, status, day_date - make_interval(days => i::int);

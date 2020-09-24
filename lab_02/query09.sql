-- Инструкция SELECT, использующая простое выражение CASE
-- Подпись некоторых хоккеистов, которые празднуют юбилей.

SELECT firstName, lastName, birthDate
    CASE EXTRACT(YEAR FROM birthDate)
        WHEN 2000 THEN '20 в этом году!'
        WHEN 1990 THEN '30 в этом году!'
        WHEN 1980 THEN '40 в этом году!'
        ELSE 'Не празднует юбилей в этом году('
    END AS Anniversary
FROM player_info;

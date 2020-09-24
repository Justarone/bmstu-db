-- Инструкция SELECT, использующая предикат LIKE.
-- Вывод всех хоккеистов с фамилией, оканчивающейся на -ov (большинство - русские)
SELECT DISTINCT firstName, lastName, nationality
FROM player_info
WHERE lastName LIKE '%ov';

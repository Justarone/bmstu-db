-- Инструкция SELECT, использующая предикат BETWEEN
-- Вывод всех хоккеистов от 20 до 30 лет
SELECT DISTINCT firstName, lastName, birthDate
FROM player_info
WHERE birthDate BETWEEN '1990-01-01' AND '2000-12-12';

-- Инструкция SELECT, использующая предикат сравнения.
-- Вывод всех канадских хоккеистов
SELECT DISTINCT firstName, lastName, nationality 
FROM player_info
WHERE nationality = 'CAN';

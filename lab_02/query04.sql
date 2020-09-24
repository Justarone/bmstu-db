-- Инструкция SELECT, использующая предикат IN с вложенным подзапросом.
-- Вывод хоккеистов, кто хоть раз забивал более 3 за матч
SELECT firstName, lastName, nationality
FROM player_info
WHERE player_id IN (
    SELECT DISTINCT player_id
    FROM game_skaters_stats
    WHERE goals > 3
);

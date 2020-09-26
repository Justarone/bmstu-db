-- Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
-- Вывод максимального кол-ва голов игрока в одном матче И сравнение со средним из всех его тесок

WITH CoolPlayers (player_id, goals)
AS (
    SELECT player_id, MAX(goals)
    FROM game_skaters_stats
    GROUP BY player_id
)
SELECT firstName, lastName, goals AS MaxGoals,
AVG(goals) OVER (PARTITION BY firstName) AS AvgGoals
FROM player_info
JOIN CoolPlayers
ON player_info.player_id = CoolPlayers.player_id;

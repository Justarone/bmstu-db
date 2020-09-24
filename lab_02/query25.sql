-- Инструкция SELECT, использующая простое обобщенное табличное выражение
-- Вывод максимального кол-ва голов игрока в одном матче И сравнение со средним из всех его тесок

WITH CoolPlayers (player_id, goals)
AS (
    SELECT player_id, MAX(goals)
    FROM game_skaters_stats
    GROUP BY player_id
)

SELECT firstName, goals AS MaxGoals,
AVG(goals) OVER (PARTITION BY firstName) AS AvgGoals,
ROW_NUMBER() OVER(PARTITION BY firstName, goals, AVG(goals)) AS rn
FROM player_info
JOIN CoolPlayers
ON player_info.player_id = CoolPlayers.player_id;

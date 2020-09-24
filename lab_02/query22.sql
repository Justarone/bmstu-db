-- Инструкция SELECT, использующая простое обобщенное табличное выражение
-- Вывод всех крутых игроков, которые хоть раз забивали больше 3 голов за матч

WITH CoolPlayers (player_id, goals)
AS (
    SELECT player_id, MAX(goals)
    FROM game_skaters_stats
    GROUP BY player_id
    HAVING MAX(goals) > 3
)
SELECT firstName, lastName, goals AS MaxGoals
FROM player_info
JOIN CoolPlayers
ON player_info.player_id = CoolPlayers.player_id;

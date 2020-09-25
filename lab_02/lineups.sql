-- Выводит всех игроков какой-то команды в заданные периоды времени

WITH games_in_interval (game_id) AS (
    SELECT game_id, date_time
    FROM game
    WHERE date_time > '2010-01-01' AND date_time < '2020-01-01'
),
lineups AS (
    SELECT firstName, lastName, MIN(games_in_interval.date_time) AS from_date,
    MAX(games_in_interval.date_time) AS to_date,
    COUNT(*) AS games_number, (team_info.shortName || ' ' || team_info.teamName) AS team
    FROM game_skaters_stats
    JOIN games_in_interval
    ON game_skaters_stats.game_id = games_in_interval.game_id
    JOIN team_info
    ON game_skaters_stats.team_id = team_info.team_id
    JOIN  player_info
    ON game_skaters_stats.player_id = player_info.player_id
    WHERE team_info.shortName LIKE 'Tampa%'
    GROUP BY firstName, lastName, team_info.shortName, team_info.teamName
)
SELECT *, to_date - from_date AS time
FROM lineups
ORDER BY games_number DESC;

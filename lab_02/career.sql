-- Для заданного игрока находим все клубы, в которых он играл в ризличные периоды (то есть можно посмотреть кареьеру игрока)
WITH career AS (
    SELECT firstName, lastName, team_id,
    MIN(game.date_time) AS from_date, 
    MAX(game.date_time) AS to_date
    FROM game_skaters_stats
    JOIN player_info
    ON game_skaters_stats.player_id = player_info.player_id
    JOIN game
    ON game_skaters_stats.game_id = game.game_id
    GROUP BY (game_skaters_stats.player_id, firstName, lastName, team_id)
    HAVING player_info.lastName LIKE 'Jagr'
)
SELECT firstName, lastName, shortName, teamName, from_date, to_date
FROM career
JOIN team_info
ON team_info.team_id = career.team_id;

-- Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING
-- Вывод матчей в формате "хозяева - гости - кол-во моментов - среднее среди времен моментов"

SELECT (hteam.shortName || ' ' || hteam.shortName) AS home,
(ateam.shortName || ' ' || ateam.shortName) AS away,
mt.moments, mt.avg_time
FROM game
JOIN team_info ateam
ON ateam.team_id = game.away_team_id
JOIN team_info hteam
ON hteam.team_id = game.home_team_id
JOIN (
    SELECT game_id, COUNT(*) AS moments,
    AVG((period - 1) * 1200 + periodTime) AS avg_time
    FROM game_plays
    GROUP BY game_id
) AS mt ON mt.game_id = game.game_id;

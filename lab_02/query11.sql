-- Создание новой временной локальной таблицы из результирующего набора данных инструкций SELECT
-- Все матчи между командами (джоин для печати названия) и сортировка в порядке убывания общего количества голов 

SELECT (ateam.shortName || ' ' || ateam.teamName) AS awayName,
(hteam.shortName || ' ' || hteam.teamName) AS homeName,
game.away_goals, game.home_goals
INTO my_temp
FROM game 
JOIN team_info ateam 
ON ateam.team_id = game.away_team_id 
JOIN team_info hteam
ON hteam.team_id = game.home_team_id
ORDER BY game.home_goals + game.away_goals DESC;

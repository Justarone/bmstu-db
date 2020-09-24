-- Инструкция SELECT, использующая вложенные коррелированные подзапросы в качетсве производных таблиц в предложении FROM
-- Все игроки, которые выходили на лед при участии определенной команды в определенный период времени 
-- (изначально другой немного запрос планировался, но пусть будет этот)

SELECT DISTINCT firstName, lastName, birthDate
FROM player_info
JOIN (

    SELECT game_shifts.game_id, player_id
    FROM game_shifts 
    JOIN (
        SELECT game_id
        FROM game 
        JOIN team_info ateam 
        ON ateam.team_id = game.away_team_id 
        JOIN team_info hteam
        ON hteam.team_id = game.home_team_id
        WHERE (ateam.shortName LIKE '%Tampa%' OR hteam.shortName LIKE '%Tampa%') -- team
        AND 
        (game.date_time > '2017-01-01' AND game.date_time < '2017-01-07') -- time
    ) AS extGame ON game_shifts.game_id = extGame.game_id

) AS timeAndTeam ON player_info.player_id = timeAndTeam.player_id;

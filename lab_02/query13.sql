-- Иструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3.
-- не знаю, зачем но строим для всех таблицу: Игрок | его голы | всего голов | всего моментов

SELECT player_info.firstName, player_info.lastName, flexstat.goals,
flexstat.game_goals, flexstat.game_moments
FROM player_info
-- Собираем игры, в которых участвовал игрок, и инфу о них
JOIN (
    SELECT game_skaters_stats.player_id, goals, extgame.game_goals AS game_goals,
    extgame.game_moments as game_moments
    FROM game_skaters_stats
    -- Собираем кол-во голов в игре и игровых моментов
    JOIN (
        SELECT game.game_id, (game.away_goals + game.home_goals) AS game_goals, 
        fullgame.moments AS game_moments
        FROM game
        -- Собираем кол-во игровых моментов
        JOIN (
            SELECT game_id, COUNT(*) AS moments
            FROM game_plays
            GROUP BY game_id
        ) AS fullgame ON fullgame.game_id = game.game_id

    ) AS extgame ON extgame.game_id = game_skaters_stats.game_id

) AS flexstat ON player_info.player_id = flexstat.player_id;

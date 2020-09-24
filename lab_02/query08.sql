-- Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов.
-- Найти общее кол-во голов у молодых игроков, а также кол-во игр в качестве вратаря

SELECT player_info.*,
(
    SELECT SUM(goals + assists)
    FROM game_skaters_stats
    WHERE game_skaters_stats.player_id = player_info.player_id
) AS points,
(
    SELECT make_interval(secs => SUM(shift_end - shift_start))
    FROM game_shifts
    WHERE game_shifts.player_id = player_info.player_id
) AS AllTimeOnIce
FROM player_info
WHERE birthDate > '1999-01-01' AND primaryPosition <> 'G';

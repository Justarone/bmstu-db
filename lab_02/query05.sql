-- Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом
-- Вывод хоккеистов, кто хоть раз играл смену больше 2 минут (полевые игроки)
SELECT firstName, lastName, primaryPosition
FROM player_info
WHERE EXISTS (
    SELECT player_id
    FROM game_shifts
    WHERE player_id = player_info.player_id AND shift_end - shift_start > 120
) AND primaryPosition <> 'G';

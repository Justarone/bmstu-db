-- Определяемая пользователем скалярная функция CLR
-- Функция получения id по фамилии
-- И Функция получения кол-ва голов в первой игре

CREATE OR REPLACE FUNCTION get_id_by_lastname(lastname VARCHAR)
RETURNS INTEGER
AS $$
    res = plpy.execute(f"\
            SELECT player_id \
            FROM player_info \
            WHERE lastName = '{lastname}' \
        ", 1)
    return res[0]['player_id'] if len(res) > 0 else -1
$$ LANGUAGE PLPYTHON3U;

CREATE OR REPLACE FUNCTION goals_in_first_game(playerid int)
RETURNS INTEGER
AS $$
    res = plpy.execute(f"\
        SELECT goals \
        FROM game_skaters_stats gss \
        JOIN game \
        ON gss.game_id = game.game_id \
        WHERE player_id = '{playerid}' \
        ORDER BY date_time; \
    ", 1)
    return res[0]['goals'] if len(res) > 0 else -1
$$ LANGUAGE PLPYTHON3U;

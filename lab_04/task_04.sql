-- Хранимая процедура CLR
-- Функция удаляет всех "фейковых игроков", добавленных после того, как был повешен триггер из task_05

CREATE OR REPLACE PROCEDURE remove_fakes()
AS $$
    res = plpy.cursor(" \
        SELECT player_id AS id \
        FROM fake_player_info; \
    ")
    plan = plpy.prepare(f"DELETE FROM player_info WHERE player_id = $1;", ["INT"])
    for id in map(lambda elem: elem['id'], res):
        plpy.execute(plan, [id])
    plpy.execute("DELETE from fake_player_info")
$$ LANGUAGE PLPYTHON3U;

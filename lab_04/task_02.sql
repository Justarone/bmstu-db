-- Пользовательская агрегатная функция CLR

CREATE OR REPLACE FUNCTION avg_goals_all_players()
RETURNS NUMERIC
AS $$
    res = plpy.execute(" \
        SELECT sum(goals) as goals \
        FROM game_skaters_stats gss \
        GROUP BY player_id; \
    ")
    return sum(map(lambda x: x['goals'], res)) / len(res)
$$ LANGUAGE PLPYTHON3U;

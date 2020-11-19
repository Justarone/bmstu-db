-- Пользовательская агрегатная функция CLR
-- Среднее кол-во голов среди всех игроков лиги

CREATE OR REPLACE FUNCTION avg_goals_all_players()
RETURNS NUMERIC
AS $$
    #TODO: сделать агрегацию питоном
    res = plpy.execute(" \
        SELECT sum(goals) as goals \
        FROM game_skaters_stats gss \
        GROUP BY player_id; \
    ")
    return sum(map(lambda x: x['goals'], res)) / len(res)
$$ LANGUAGE PLPYTHON3U;

CREATE OR REPLACE FUNCTION avg_goals_all_players2()
RETURNS NUMERIC
AS $$
    from functools import reduce

    def update_goals(map, r):
        if r['player_id'] in map.keys():
            map[r['player_id']] += r['goals']
        else:
            map[r['player_id']] = r['goals']

    res = plpy.execute(" \
        SELECT player_id, goals \
        FROM game_skaters_stats; \
    ")

    grouped_res = dict();
    reduce(lambda prev, el: update_goals(grouped_res, el), res)

    return sum(grouped_res.values()) / len(grouped_res)
$$ LANGUAGE PLPYTHON3U;

-- Определяемый пользователем тип данных CLR

-- создать таблицу с таким типом
-- добавить 1 запись
-- заселектить все
-- заселектить fi, saves
CREATE TYPE goalie_main_stats AS (
    fi VARCHAR (61),
    games BIGINT,
    minutes BIGINT,
    shots BIGINT,
    saves BIGINT
);

CREATE OR REPLACE FUNCTION get_goalies_main_stats()
RETURNS SETOF goalie_main_stats
AS $$
    res = plpy.cursor(" \
        WITH ggs(gid, games, mins, shots, saves) AS ( \
            SELECT player_id as gid, count(*) AS games, \
            sum(timeOnIce) / 60 AS mins, sum(shots) AS shots, \
            sum(saves) AS saves \
            FROM game_goalie_stats ggs \
            GROUP BY player_id \
        ) \
        SELECT firstName || ' ' || lastName AS fi, games, mins, shots, saves \
        FROM ggs \
        JOIN player_info pi \
        ON pi.player_id = ggs.gid \
    ")
    for record in map(lambda x: (x['fi'], x['games'], x['mins'], x['shots'], x['saves']), res):
        yield record
$$ LANGUAGE PLPYTHON3U;

-- создать таблицу с таким типом
-- добавить 1 запись
-- заселектить все
-- заселектить fi, saves

-- CREATE TYPE goalie_main_stats AS (
    -- fi VARCHAR (61),
    -- games BIGINT,
    -- minutes BIGINT,
    -- shots BIGINT,
    -- saves BIGINT
-- );

CREATE TABLE IF NOT EXISTS my_goalies OF goalie_main_stats;

INSERT INTO my_goalies
WITH ggs(gid, games, mins, shots, saves) AS (
    SELECT player_id as gid, count(*) AS games,
    sum(timeOnIce) / 60 AS mins, sum(shots) AS shots,
    sum(saves) AS saves
    FROM game_goalie_stats ggs
    GROUP BY player_id
)
SELECT firstName || ' ' || lastName AS fi, games, mins, shots, saves
FROM ggs
JOIN player_info pi
ON pi.player_id = ggs.gid 
LIMIT 1;

SELECT * FROM my_goalies;
SELECT fi, saves FROM my_goalies;

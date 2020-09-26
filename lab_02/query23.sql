-- Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение
-- "неудобные соперники моих соперников - мои друзья"

DROP TABLE IF EXISTS rand_team_ids_n;
DROP TABLE IF EXISTS teams_rivals;

WITH rand_team_ids AS (
    SELECT team_id as rival
    FROM team_info
    ORDER BY RANDOM()
)
SELECT ROW_NUMBER() OVER() AS N, rival
INTO rand_team_ids_n
FROM rand_team_ids;

WITH teams_n AS (
    SELECT ROW_NUMBER() OVER() AS N, team_id
    FROM team_info
)
SELECT team_id, rival
INTO teams_rivals
FROM teams_n
JOIN rand_team_ids_n
ON rand_team_ids_n.N = teams_n.N;

SELECT *
FROM teams_rivals
ORDER BY team_id;

WITH RECURSIVE Friends (team_id, rival, Level) AS (
    SELECT team_id, rival, 0 AS Level
    FROM teams_rivals
    WHERE team_id = 1
    UNION ALL
    SELECT f.team_id, tr.rival, Level + 1
    FROM teams_rivals AS tr 
    INNER JOIN Friends AS f
    ON f.rival = tr.team_id AND Level < 20
)
SELECT team_id, rival, Level 
FROM Friends;

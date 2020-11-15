-- Скалярная функция
-- Функция, которая возвращает средний возраст "опытных" игроков (сыгравших MIN_GAMES или больше матчей в НХЛ)

CREATE OR REPLACE FUNCTION expert_avg_age(MIN_GAMES integer)
RETURNS NUMERIC
AS $$
DECLARE
    age NUMERIC DEFAULT 0;
BEGIN
    EXECUTE 'WITH id_games_bd (player_id, games_cnt, birthDate) AS (
        SELECT pi.player_id, count(*) as game_cnt, birthDate
        FROM player_info pi
        JOIN game_skaters_stats gss
        ON gss.player_id = pi.player_id
        GROUP BY pi.player_id
        HAVING count(*) >= $1
    )
    SELECT avg(CURRENT_DATE - birthDate) / 365
    FROM id_games_bd;'
    INTO age
    USING MIN_GAMES;
    RETURN age;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION goals_scored(id int) 
RETURNS INT
AS $$
DECLARE
    res int := 0;
BEGIN
    EXECUTE 'SELECT sum(goals)
    FROM game_skaters_stats
    WHERE player_id = $1
    GROUP BY player_id;'
    USING id
    INTO res;
    RETURN res;
END;
$$ LANGUAGE PLPGSQL;


-- Старый вариант c LANGUAGE SQL
-- CREATE OR REPLACE FUNCTION expert_avg_age(MIN_GAMES int) 
-- RETURNS NUMERIC
-- AS $$
    -- WITH id_games_bd (player_id, games_cnt, birthDate) AS (
        -- SELECT pi.player_id, count(*) as game_cnt, birthDate
        -- FROM player_info pi
        -- JOIN game_skaters_stats gss
        -- ON gss.player_id = pi.player_id
        -- GROUP BY pi.player_id
        -- HAVING count(*) >= $1
    -- )
    -- SELECT avg(CURRENT_DATE - birthDate) / 365
    -- FROM id_games_bd;
-- $$ LANGUAGE SQL;

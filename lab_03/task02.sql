-- Подставляемая табличная функция
-- Возвращает список экспертов в виде (id, кол-во игр)

CREATE OR REPLACE FUNCTION list_of_experts(MIN_GAMES int) 
RETURNS TABLE (
    player_id INT,
    game_cnt BIGINT
)
AS $$
BEGIN
    RETURN QUERY SELECT pi.player_id, count(*) as game_cnt
    FROM player_info pi
    JOIN game_skaters_stats gss
    ON gss.player_id = pi.player_id
    GROUP BY pi.player_id
    HAVING count(*) >= MIN_GAMES;
END;
$$ LANGUAGE PLPGSQL;

-- Создание типа (с проверкой, существует ли уже такой)
-- DO $$
-- BEGIN
    -- IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'expert') THEN
        -- CREATE TYPE expert AS (
            -- player_id INT,
            -- game_cnt BIGINT
        -- );
    -- END IF;
-- END$$;

-- Вариант с типом record (его неудобно join'ить)
-- CREATE OR REPLACE FUNCTION list_of_experts(IN MIN_GAMES int, OUT first_name VARCHAR(30),
                                           -- OUT last_name VARCHAR(30), OUT birth_date DATE, OUT game_cnt BIGINT) 
-- RETURNS SETOF record
-- AS $$
-- BEGIN
    -- RETURN QUERY EXECUTE 'SELECT pi.firstName, pi.lastName, pi.birthDate, count(*) as game_cnt
    -- FROM player_info pi
    -- JOIN game_skaters_stats gss
    -- ON gss.player_id = pi.player_id
    -- GROUP BY pi.player_id
    -- HAVING count(*) >= $1;'
    -- USING MIN_GAMES;
-- END;
-- $$ LANGUAGE PLPGSQL;

-- Старый вариант c LANGUAGE SQL
-- CREATE OR REPLACE FUNCTION list_of_experts(IN MIN_GAMES int, OUT first_name VARCHAR(30),
                                           -- OUT last_name VARCHAR(30), OUT birth_date DATE, OUT game_cnt BIGINT) 
-- RETURNS SETOF record
-- AS $$
    -- SELECT pi.firstName, pi.lastName, pi.birthDate, count(*) as game_cnt
    -- FROM player_info pi
    -- JOIN game_skaters_stats gss
    -- ON gss.player_id = pi.player_id
    -- GROUP BY pi.player_id
    -- HAVING count(*) >= $1
-- $$ LANGUAGE SQL;

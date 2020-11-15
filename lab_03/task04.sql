-- Рекурсивная хранимая функция или функция с рекурсивным ОТВ
-- "неудобные соперники моих соперников - мои друзья"

CREATE OR REPLACE FUNCTION generate_rivals()
RETURNS TABLE(
    team_id INT,
    rival INT
)
AS $$
BEGIN
    DROP TABLE IF EXISTS t1;
    CREATE TEMP TABLE t1 (
        N int,
        rival int
    );

    INSERT INTO t1 (N, rival)
    WITH rand_team_ids AS (
        SELECT team_info.team_id as rival
        FROM team_info
        ORDER BY RANDOM()
    )
    SELECT ROW_NUMBER() OVER() AS id, rand_team_ids.rival
    FROM rand_team_ids;

    RETURN QUERY
    WITH teams_n AS (
        SELECT ROW_NUMBER() OVER() AS N, team_info.team_id
        FROM team_info
    )
    SELECT teams_n.team_id, t1.rival
    FROM teams_n
    JOIN t1 
    ON t1.N = teams_n.N;
END;
$$ LANGUAGE PLPGSQL;



CREATE OR REPLACE FUNCTION generate_friends_and_rivals()
RETURNS TABLE (
    team_id INT,
    friend_id INT
)
AS $$
BEGIN
    DROP TABLE IF EXISTS rivals;
    CREATE TEMP TABLE rivals (
        team_id int,
        rival int
    );

    INSERT INTO rivals (team_id, rival)
    SELECT * FROM generate_rivals();

    -- analyze rivals list and return friends
    RETURN QUERY
    WITH RECURSIVE Friends (team_id, rival, Level) AS (
        SELECT rivals.team_id, rival, 1 AS Level
        FROM rivals
        UNION ALL
        SELECT f.team_id, rivals.rival, Level + 1
        FROM rivals
        INNER JOIN Friends AS f
        ON f.rival = rivals.team_id AND Level < 2
    )
    SELECT Friends.team_id, rival AS friend
    FROM Friends
    WHERE Level = 2;
END;
$$ LANGUAGE PLPGSQL;

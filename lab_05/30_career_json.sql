CREATE OR REPLACE FUNCTION career_json(pid INT)
RETURNS json
AS $$
DECLARE
    temp VARCHAR = '';
    ftable VARCHAR = '';
    res VARCHAR = '';
    elem RECORD;
BEGIN
    SELECT primaryPosition 
    FROM player_info 
    WHERE player_id = pid
    INTO temp;

    IF temp <> 'G' THEN
        SELECT 'game_skaters_stats'
        INTO ftable;
    ELSE
        SELECT 'game_goalie_stats'
        INTO ftable;
    END IF;

        -- полевой игрок
    FOR elem IN
        EXECUTE 'WITH career (pid, tid, fdate, tdate) AS (
            SELECT player_id, team_id,
            MIN(g.date_time) AS from_date, 
            MAX(g.date_time) AS to_date
            FROM ' || ftable || ' gss
            JOIN game g
            ON gss.game_id = g.game_id
            GROUP BY (gss.player_id, team_id)
            HAVING gss.player_id = ' || pid || '
        )
        SELECT * 
        FROM career
        ORDER BY fdate'
    LOOP
        SELECT res || ',{"team_id": ' || elem.tid || ', "interval":' || '{"from":"' || elem.fdate|| '","to":"' || elem.tdate || '"}}'
        INTO res;
    END LOOP;

    SELECT '[' || trim(both ',' from res) || ']'
    INTO res;
    RETURN res::json;
END;
$$ LANGUAGE PLPGSQL;

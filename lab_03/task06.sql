-- Рекурсивная хранимая процедура или хранимая процедура с рекурсивным ОТВ
-- Рекурсивно обходим и печатаем цепочку врагов

DROP TABLE IF EXISTS rivals;
SELECT * 
INTO rivals
FROM generate_rivals();

CREATE OR REPLACE FUNCTION get_team_name_by_id(team_id int)
RETURNS VARCHAR
AS $$
DECLARE
    res VARCHAR;
BEGIN
    SELECT shortName || ' ' || teamName
    FROM team_info
    INTO res
    WHERE team_info.team_id = get_team_name_by_id.team_id;
    RETURN res;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE PROCEDURE _cycle_chain_rivals(team_id int, start_id int)
AS $$
DECLARE
    rival int;
    team_name VARCHAR(41);
BEGIN
    SELECT *
    INTO team_name
    FROM get_team_name_by_id(team_id);
    RAISE NOTICE '%', team_name;

    IF team_id = start_id THEN
        RAISE NOTICE 'That''s the end:)';
    ELSE
        SELECT rivals.rival
        FROM rivals
        WHERE rivals.team_id = _cycle_chain_rivals.team_id
        INTO rival;
        CALL _cycle_chain_rivals(rival, start_id);
    END IF;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE PROCEDURE cycle_chain_rivals(team_id int)
AS $$
DECLARE
    elem rivals%ROWTYPE;
    team_name VARCHAR(41);
BEGIN
    SELECT *
    FROM rivals
    WHERE rivals.team_id = cycle_chain_rivals.team_id
    INTO elem;

    RAISE NOTICE 'chain starts from id #%', team_id;

    SELECT *
    INTO team_name
    FROM get_team_name_by_id(team_id);

    RAISE NOTICE '%', team_name;

    call _cycle_chain_rivals(elem.rival, elem.team_id);
END;
$$ LANGUAGE PLPGSQL;


-- FOR ELEM IN
    -- SELECT * FROM rivals
-- LOOP
    -- RAISE NOTICE '% hates %!!!\n', ELEM.team_id, ELEM.rival;
-- END LOOP;

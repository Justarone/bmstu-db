-- Хранимая процедура с курсором
-- Вывод всех с похожим именем

CREATE OR REPLACE PROCEDURE all_with_same_name(name VARCHAR)
AS $$
DECLARE
    player player_info%ROWTYPE;
    players_cur REFCURSOR;
BEGIN
    OPEN players_cur FOR 
        SELECT *
        FROM player_info
        WHERE firstName LIKE '%' || name || '%';
    LOOP
        FETCH players_cur INTO player;
        IF NOT FOUND THEN
            EXIT;
        END IF;

        IF player.firstName = name THEN
            RAISE NOTICE '% % has exactly % name', player.firstName, player.lastName, name;
        ELSE
            RAISE NOTICE '% % has similar to % name', player.firstName, player.lastName, name;
        END IF;
    END LOOP;
    CLOSE players_cur;
END;
$$ LANGUAGE PLPGSQL;


CREATE OR REPLACE PROCEDURE all_with_same_name2(name VARCHAR)
AS $$
DECLARE
    player player_info%ROWTYPE;
    players_cur CURSOR FOR 
        SELECT *
        FROM player_info
        WHERE firstName LIKE '%' || name || '%';
BEGIN
    FOR player IN players_cur LOOP
        IF player.firstName = name THEN
            RAISE NOTICE '% % has exactly % name', player.firstName, player.lastName, name;
        ELSE
            RAISE NOTICE '% % has similar to % name', player.firstName, player.lastName, name;
        END IF;
    END LOOP;
END;
$$ LANGUAGE PLPGSQL;

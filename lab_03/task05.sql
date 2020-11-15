-- Хранимая процедура без параметров или с параметрами
-- Сдвигаем дни рождения всех игроков

-- TODO: переписать на что-то более логичное

CREATE OR REPLACE PROCEDURE shift_birthdates(diff interval)
AS $$
BEGIN
    UPDATE player_info
    SET birthDate = birthDate + diff;
END;
$$ LANGUAGE PLPGSQL;


-- составление таблицы "игрок - кол-во голов за все время"
CREATE OR REPLACE PROCEDURE players_goals()
AS $$
BEGIN
    DROP TABLE IF EXISTS player_goals;
    CREATE TABLE player_goals (
        player_id INT PRIMARY KEY,
        goals BIGINT
    );
    INSERT INTO player_goals (player_id, goals)
    SELECT player_id, count(goals)
    FROM game_skaters_stats
    GROUP BY player_id;
END;
$$ LANGUAGE PLPGSQL;

-- Триггер AFTER
-- Ведение списка фейковых игроков

CREATE TABLE IF NOT EXISTS fake_player_info (
    player_id INT PRIMARY KEY,
    firstName VARCHAR(30) NOT NULL,
    lastName VARCHAR(30) NOT NULL,
    nationality VARCHAR(5) NOT NULL,
    birthCity VARCHAR(30) NOT NULL,
    primaryPosition VARCHAR(2) NOT NULL,
    birthDate DATE NOT NULL,
    CHECK (char_length(firstName) > 0 AND char_length(lastName) > 0)
);
CREATE OR REPLACE FUNCTION update_table_of_fakes_also()
RETURNS TRIGGER
AS $$
BEGIN
    INSERT INTO fake_player_info 
    VALUES (NEW.player_id, NEW.firstName, NEW.lastName,
            NEW.nationality, NEW.birthCity, NEW.primaryPosition,
            NEW.birthDate);
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

DROP TRIGGER IF EXISTS remember_fakes ON player_info;

CREATE TRIGGER remember_fakes
AFTER INSERT ON player_info
FOR ROW EXECUTE PROCEDURE update_table_of_fakes_also();

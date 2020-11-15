-- Триггер INSTEAD OF
-- Вставка в топ10 (а вернее говоря вставка в фейковую таблицу вместо топ10)

CREATE OR REPLACE VIEW top10teams AS
SELECT * FROM team_info
ORDER BY team_id
LIMIT 10;

CREATE TABLE IF NOT EXISTS fake_top (
    team_id INT PRIMARY KEY,
    franshizeId INT NOT NULL,
    shortName VARCHAR(20) NOT NULL,
    teamName VARCHAR(20) NOT NULL,
    abbreviation VARCHAR(3) NOT NULL
);

CREATE OR REPLACE FUNCTION fake_top_update()
RETURNS TRIGGER
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT team_id
        FROM top10teams
        WHERE team_id = NEW.team_id AND 
        shortName = NEW.shortName AND
        teamName = NEW.teamName
        ) 
    THEN
        IF NOT EXISTS (
            SELECT team_id 
            FROM fake_top
            WHERE team_id = NEW.team_id
            )
        THEN
            INSERT INTO fake_top
            VALUES (NEW.team_id, NEW.franshizeId, NEW.shortName,
                    NEW.teamName, NEW.abbreviation);
            RAISE NOTICE 'Top is already done, your team was added in fake_top table';
            RETURN NEW;
        END IF;
        RAISE NOTICE 'Top is already done, your team is found in fake_top table';
    ELSE
        RAISE NOTICE 'Team already exists in top!';
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE PLPGSQL;

DROP TRIGGER IF EXISTS add_fakes ON top10teams;

CREATE TRIGGER add_fakes
INSTEAD OF INSERT ON top10teams
FOR ROW EXECUTE PROCEDURE fake_top_update();

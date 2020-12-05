CREATE TABLE IF NOT EXISTS warning_connections (
    id INT PRIMARY KEY,
    cnt INT NOT NULL DEFAULT 1
);

CREATE OR REPLACE PROCEDURE warn_db(id int)
AS $$
BEGIN
    IF (SELECT count(*) FROM warning_connections wc WHERE wc.id = warn_db.id) > 0 THEN
        UPDATE warning_connections wc SET
            cnt = cnt + 1
        WHERE wc.id = warn_db.id;
    ELSE
        INSERT INTO warning_connections VALUES (warn_db.id, 1);
    END IF;
END;
$$ LANGUAGE PLPGSQL;


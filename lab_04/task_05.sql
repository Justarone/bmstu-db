-- Триггер CLR
-- Добавляет фейковых игроков в отдельную таблицу (чтобы затем можно было их легко удалить)

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

CREATE OR REPLACE FUNCTION update_fake_table_also()
RETURNS TRIGGER
AS $$
    plpy.execute("INSERT INTO {} VALUES ('{}', '{}', '{}', '{}', '{}', '{}', '{}');".format('fake_player_info',
            TD['new']['player_id'], TD['new']['firstname'], TD['new']['lastname'], TD['new']['nationality'],
            TD['new']['birthcity'], TD['new']['primaryposition'], TD['new']['birthdate'])
    )
    return None
$$ LANGUAGE PLPYTHON3U;

DROP TRIGGER IF EXISTS remember_fakes ON player_info;

CREATE TRIGGER remember_fakes
AFTER INSERT ON player_info
FOR ROW EXECUTE PROCEDURE update_fake_table_also();

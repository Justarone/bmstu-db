-- Создать хранимую процедуру, которая не уничтожая базу данных, уничтожает все те таблицы текущей базы данных в схеме 'dbo' (но я делаю 'public', потому что у меня postgres), имена которых начинаются с фразы 'TableName'. Созданную хранимую процедуру протестировать

CREATE TABLE IF NOT EXISTS TableName1 (
    a int
);

CREATE TABLE IF NOT EXISTS TableName2 (
    a int
);

CREATE TABLE IF NOT EXISTS TableName3 (
    a int
);

CREATE TABLE IF NOT EXISTS TableName4 (
    a int
);

CREATE OR REPLACE PROCEDURE rm_all_like(tablename varchar)
AS $$
DECLARE
    elem varchar = '';
BEGIN
    FOR elem IN
        EXECUTE 'SELECT table_name FROM information_schema.tables
        WHERE table_type=''BASE TABLE'' AND table_name LIKE ''' || tablename || '%'''
    LOOP
        EXECUTE 'DROP TABLE ' || elem;
    END LOOP;
END;
$$ LANGUAGE PLPGSQL;

-- Вызываем функцию командой `call rm_all_like('tablename')` и удалятся все созданные выше таблицы (TableName...)
-- PS: tablename, возможно, нужно было захардкодить, но лучше сделать больше, чем меньше
-- PS2: примечательно, что в постгресе все приводится к нижнему регистру, поэтому удалять надо именно 'tablename', а не 'TableName'

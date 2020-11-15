-- Хранимая процедура доступа к метаданным
-- Вывод таблиц с именем, содержащим маску

CREATE OR REPLACE PROCEDURE show_all_tables_masked(mask VARCHAR)
AS $$
DECLARE
    name VARCHAR;
BEGIN
    FOR name IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_name LIKE '%' || mask || '%' 
    LOOP
        RAISE NOTICE 'Table with name %!', name;
    END LOOP;
END;
$$ LANGUAGE PLPGSQL;

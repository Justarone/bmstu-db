CREATE OR REPLACE FUNCTION check_key_existance(obj json, key anyelement) 
RETURNS BOOLEAN
AS $$
BEGIN
    RETURN obj->key IS NOT NULL;
END;
$$ LANGUAGE PLPGSQL;

SELECT 'Does Ovechkin has more than 2 teams?' AS question, check_key_existance(career, 2) AS answer
FROM player_info
WHERE lastName = 'Ovechkin';
SELECT 'Does Jagr has more than 2 teams?' AS question, check_key_existance(career, 2) AS answer
FROM player_info
WHERE lastName = 'Jagr';

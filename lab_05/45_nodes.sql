WITH JagrTeams AS (
    SELECT jsonb_array_elements(career::jsonb)
    FROM player_info
    WHERE lastname = 'Jagr'
)
SELECT * FROM JagrTeams;

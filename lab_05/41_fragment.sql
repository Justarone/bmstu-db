SELECT firstName || ' ' || lastName, career->0
FROM player_info
WHERE career->0 IS NOT NULL;

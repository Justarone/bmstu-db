SELECT firstName || ' ' || lastName, career->0->'team_id' AS firstteamid,
shortName || ' ' || teamName as firstTeamName
FROM player_info pi
JOIN team_info ti
ON (pi.career->0->>'team_id')::INT = ti.team_id
WHERE career->0 IS NOT NULL;

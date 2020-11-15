SELECT r.team_id, pi.shortName || ' ' || pi.teamName as team,
ri.shortName || ' ' || ri.teamName as rival
FROM rivals r
JOIN team_info pi
ON pi.team_id = r.team_id
JOIN team_info ri
ON ri.team_id = r.rival;
CALL cycle_chain_rivals(1);

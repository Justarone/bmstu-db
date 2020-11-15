-- SELECT * FROM player_info WHERE lastName = 'Ovechkin';
-- CALL shift_birthdates(make_interval(years => 1));
-- SELECT * FROM player_info WHERE lastName = 'Ovechkin';
-- CALL shift_birthdates(make_interval(years => -1));

CALL players_goals();
SELECT firstName || ' ' || lastName as FI, goals
FROM player_goals pg
JOIN player_info pi
ON pg.player_id = pi.player_id
WHERE lastName = 'Ovechkin';

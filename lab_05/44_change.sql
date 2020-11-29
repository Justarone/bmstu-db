SELECT firstName || ' ' || lastName as FI, career
FROM player_info
WHERE lastName = 'Ovechkin';

UPDATE player_info SET
career = jsonb_set(career::jsonb, '{-1, team_id}'::text[], '1'::jsonb, false)
WHERE lastName = 'Ovechkin';

SELECT firstName || ' ' || lastName AS FI, career
FROM player_info
WHERE lastName = 'Ovechkin';

UPDATE player_info SET
career = jsonb_set(career::jsonb, '{-1, team_id}'::text[], '15'::jsonb, false)
WHERE lastName = 'Ovechkin';

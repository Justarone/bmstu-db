SELECT pi1.firstName, pi1.lastName, goals, pi2.firstName, pi2.lastName, goals_against
FROM scored_more_group(ARRAY[8475791, 8476453]) smg -- Kucherov and Hall
JOIN player_info pi1
on pi1.player_id = smg.player_id
JOIN player_info pi2
on pi2.player_id = smg.scored_more_than;

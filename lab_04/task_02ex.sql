SELECT avg_goals_all_players();
SELECT avg_goals_all_players2();

-- players and their goals:
-- WITH pg (player_id, goals) AS (
    -- SELECT player_id, sum(goals)
    -- FROM game_skaters_stats gss
    -- GROUP BY player_id
-- )
-- SELECT avg(goals)
-- FROM pg;


-- SELECT firstName, lastName, goals
-- FROM pg
-- JOIN player_info pi
-- ON pg.player_id = pi.player_id
-- ORDER BY goals;

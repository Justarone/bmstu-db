-- Многооператорная табличная функция
-- Забили больше, чем игроки, чьи id представлены в группе

CREATE OR REPLACE FUNCTION scored_more_group(ids int[]) 
RETURNS TABLE (
    player_id INT,
    goals BIGINT,
    scored_more_than INT,
    goals_against BIGINT
)
AS $$
DECLARE
    id int default 1;
BEGIN
    FOREACH id in ARRAY $1 LOOP
        IF EXISTS (
                SELECT player_id
                FROM player_info
                WHERE player_id = id;
            )
        THEN
            RETURN QUERY EXECUTE '
            WITH id_goals(goals) as (
                SELECT sum(goals)
                FROM game_skaters_stats
                WHERE player_id = $1
                GROUP BY player_id
            )
            SELECT player_id, sum(gss.goals), $1, ig.goals
            FROM game_skaters_stats gss, id_goals ig
            GROUP BY player_id, ig.goals
            HAVING sum(gss.goals) > ig.goals;
            '
            USING id;
        ELSE
            RAISE NOTICE 'Player with % id was not found', id;
    END LOOP;
END;
$$ LANGUAGE PLPGSQL;

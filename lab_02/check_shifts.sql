WITH calculated AS (
    SELECT game_id, player_id, SUM(shift_end - shift_start) AS toi
    FROM game_shifts
    GROUP BY player_id, game_id
)

SELECT toi, (eventimeonice + shorthandedtimeonice + powerplaytimeonice) AS timeonice
FROM game_skaters_stats
JOIN calculated
ON game_skaters_stats.player_id = calculated.player_id AND game_skaters_stats.game_id = calculated.game_id;

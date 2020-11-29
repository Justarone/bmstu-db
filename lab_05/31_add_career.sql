ALTER TABLE player_info ADD IF NOT EXISTS career json;
UPDATE player_info SET
career = career_json(player_id);

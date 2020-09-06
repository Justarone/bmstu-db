CREATE TABLE IF NOT EXISTS player_info (
    player_id INT PRIMARY KEY,
    firstName VARCHAR(30),
    lastName VARCHAR(30),
    nationality VARCHAR(5),
    birthCity VARCHAR(30),
    primaryPosition VARCHAR(2),
    birthDate DATE,
    link VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS team_info (
    team_id INT PRIMARY KEY,
    franshizeId INT,
    shortName VARCHAR(20),
    teamName VARCHAR(20),
    abbreviation VARCHAR(3),
    link VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS game (
    game_id INT PRIMARY KEY,
    season INT,
    type VARCHAR(1),
    date_time DATE,
    date_time_GMT TIMESTAMP,
    away_team_id INT,
    home_team_id INT,
    away_goals INT,
    home_goals INT,
    outcome VARCHAR(20),
    home_rink_start_side VARCHAR(5),
    venue VARCHAR(40),
    venue_link VARCHAR(50),
    venue_time_zone_id VARCHAR(20),
    venue_time_zone_offset INT,
    venue_time_zone_tz VARCHAR(5),
    FOREIGN KEY (away_team_id) REFERENCES team_info(team_id),
    FOREIGN KEY (home_team_id) REFERENCES team_info(team_id)
);

CREATE TABLE IF NOT EXISTS game_goalie_stats (
    game_id INT,
    player_id INT,
    team_id INT,
    timeOnIce INT,
    assists INT,
    goals INT,
    pim INT,
    shots INT,
    saves INT,
    powerPlaySaves INT,
    shortHandedSaves INT,
    evenSaves INT,
    shortHandedShotsAgainst INT,
    evenShotsAgainst INT,
    powerPlayShotsAgainst INT,
    decision VARCHAR(3),
    savePrecentage NUMERIC(11, 8),
    powerPlaySavePrecentage NUMERIC(11, 8),
    evenStrengthSavePrecentage NUMERIC(11, 8),
    FOREIGN KEY (game_id) REFERENCES game(game_id),
    FOREIGN KEY (player_id) REFERENCES player_info(player_id),
    FOREIGN KEY (team_id) REFERENCES team_info(team_id)
);

CREATE TABLE IF NOT EXISTS game_skaters_stats (
    game_id INT,
    player_id INT,
    team_id INT,
    timeOnIce INT,
    assists INT,
    goals INT,
    shots INT,
    hits INT,
    powerPlayGoals INT,
    powerPlayAssists INT,
    penaltyMinutes INT,
    faceoffWins INT,
    faceoffTaken INT,
    takeaways INT,
    giveaways INT,
    shortHandedGoals INT,
    shortHandedAssists INT,
    blocked INT,
    plusMinus INT,
    evenTimeOnIce INT,
    shortHandedTimeOnIce INT,
    powerPlayTimeOnIce INT,
    FOREIGN KEY (game_id) REFERENCES game(game_id),
    FOREIGN KEY (player_id) REFERENCES player_info(player_id),
    FOREIGN KEY (team_id) REFERENCES team_info(team_id)
);

CREATE TABLE IF NOT EXISTS game_shifts (
    game_id INT,
    player_id INT,
    period INT,
    shift_start INT,
    shift_end INT,
    FOREIGN KEY (game_id) REFERENCES game(game_id),
    FOREIGN KEY (player_id) REFERENCES player_info(player_id)
);

CREATE TABLE IF NOT EXISTS game_plays (
    play_id VARCHAR(15) PRIMARY KEY,
    game_id INT,
    play_num INT,
    team_id_for INT,
    team_id_against INT,
    event VARCHAR(40),
    secondaryType VARCHAR(255),
    x INT,
    y INT,
    period INT,
    periodType VARCHAR(15),
    periodTime INT,
    periodTimeRemaining INT,
    dateTime DATE,
    goals_away INT,
    goals_home INT,
    description VARCHAR(255),
    st_x INT,
    st_y INT,
    rink_side VARCHAR(5),
    FOREIGN KEY (game_id) REFERENCES game(game_id),
    FOREIGN KEY (team_id_for) REFERENCES team_info(team_id),
    FOREIGN KEY (team_id_against) REFERENCES team_info(team_id)
);

CREATE TABLE IF NOT EXISTS game_plays_players (
    play_id VARCHAR(15),
    game_id INT,
    play_num INT,
    player_id INT,
    playerType VARCHAR(15),
    FOREIGN KEY (play_id) REFERENCES game_plays(play_id),
    FOREIGN KEY (game_id) REFERENCES game(game_id),
    FOREIGN KEY (player_id) REFERENCES player_info(player_id)
);

CREATE TABLE IF NOT EXISTS game_teams_stats (
    game_id INT,
    team_id INT,
    HoA VARCHAR(4),
    won BOOLEAN,
    settled_in VARCHAR(9),
    head_coach VARCHAR(40),
    goals INT,
    shots INT,
    hits INT,
    pim INT,
    powerPlayOpportunities INT,
    powerPlayGoals INT,
    faceoffWinPercentage NUMERIC(11, 8),
    giveaways INT,
    takeaways INT,
    FOREIGN KEY (game_id) REFERENCES game(game_id),
    FOREIGN KEY (team_id) REFERENCES team_info(team_id)
);

\copy player_info from '~/hdd/datasets/NHL_game_stats/player_info.csv' delimiter ',' csv header;
\copy team_info from '~/hdd/datasets/NHL_game_stats/team_info.csv' delimiter ',' csv header ;
\copy game from '~/hdd/datasets/NHL_game_stats/game.csv' delimiter ',' csv header ;
\copy game_goalie_stats from '~/hdd/datasets/NHL_game_stats/game_goalie_stats.csv' delimiter ',' csv header null 'NA';
\copy game_skaters_stats from '~/hdd/datasets/NHL_game_stats/game_skater_stats.csv' delimiter ',' csv header null 'NA';
\copy game_teams_stats from '~/hdd/datasets/NHL_game_stats/game_teams_stats.csv' delimiter ',' csv header null 'NA';
\copy game_shifts from '~/hdd/datasets/NHL_game_stats/game_shifts.csv' delimiter ',' csv header null 'NA';
\copy game_plays from '~/hdd/datasets/NHL_game_stats/game_plays.csv' delimiter ',' csv header null 'NA';
\copy game_plays_players from '~/hdd/datasets/NHL_game_stats/game_plays_players.csv' delimiter ',' csv header null 'NA';

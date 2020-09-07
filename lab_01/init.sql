DROP DATABASE IF EXISTS mydb;
CREATE DATABASE mydb;
\c mydb

CREATE TABLE IF NOT EXISTS player_info (
    player_id INT PRIMARY KEY,
    firstName VARCHAR(30) NOT NULL,
    lastName VARCHAR(30) NOT NULL,
    nationality VARCHAR(5) NOT NULL,
    birthCity VARCHAR(30) NOT NULL,
    primaryPosition VARCHAR(2) NOT NULL,
    birthDate DATE NOT NULL,
    link VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS team_info (
    team_id INT PRIMARY KEY,
    franshizeId INT NOT NULL,
    shortName VARCHAR(20) NOT NULL,
    teamName VARCHAR(20) NOT NULL,
    abbreviation VARCHAR(3) NOT NULL,
    link VARCHAR(40)
);

CREATE TABLE IF NOT EXISTS game (
    game_id INT PRIMARY KEY,
    season INT NOT NULL,
    type VARCHAR(1) NOT NULL,
    date_time DATE NOT NULL,
    date_time_GMT TIMESTAMP NOT NULL,
    away_team_id INT NOT NULL,
    home_team_id INT NOT NULL,
    away_goals INT NOT NULL,
    home_goals INT NOT NULL,
    outcome VARCHAR(20) NOT NULL,
    home_rink_start_side VARCHAR(5) NOT NULL,
    venue VARCHAR(40) NOT NULL,
    venue_link VARCHAR(50) NOT NULL,
    venue_time_zone_id VARCHAR(20) NOT NULL,
    venue_time_zone_offset INT NOT NULL,
    venue_time_zone_tz VARCHAR(5) NOT NULL,
    FOREIGN KEY (away_team_id) REFERENCES team_info(team_id),
    FOREIGN KEY (home_team_id) REFERENCES team_info(team_id)
);

CREATE TABLE IF NOT EXISTS game_goalie_stats (
    game_id INT NOT NULL,
    player_id INT NOT NULL,
    team_id INT NOT NULL,
    timeOnIce INT NOT NULL,
    assists INT NOT NULL,
    goals INT NOT NULL,
    pim INT NOT NULL,
    shots INT NOT NULL,
    saves INT NOT NULL,
    powerPlaySaves INT NOT NULL,
    shortHandedSaves INT NOT NULL,
    evenSaves INT NOT NULL,
    shortHandedShotsAgainst INT NOT NULL,
    evenShotsAgainst INT NOT NULL,
    powerPlayShotsAgainst INT NOT NULL,
    decision VARCHAR(3) NOT NULL,
    savePrecentage NUMERIC(11, 8),
    powerPlaySavePrecentage NUMERIC(11, 8),
    evenStrengthSavePrecentage NUMERIC(11, 8),
    FOREIGN KEY (game_id) REFERENCES game(game_id),
    FOREIGN KEY (player_id) REFERENCES player_info(player_id),
    FOREIGN KEY (team_id) REFERENCES team_info(team_id)
);

CREATE TABLE IF NOT EXISTS game_skaters_stats (
    game_id INT NOT NULL,
    player_id INT NOT NULL,
    team_id INT NOT NULL,
    timeOnIce INT NOT NULL,
    assists INT NOT NULL,
    goals INT NOT NULL,
    shots INT NOT NULL,
    hits INT NOT NULL,
    powerPlayGoals INT NOT NULL,
    powerPlayAssists INT NOT NULL,
    penaltyMinutes INT NOT NULL,
    faceoffWins INT NOT NULL,
    faceoffTaken INT NOT NULL,
    takeaways INT NOT NULL,
    giveaways INT NOT NULL,
    shortHandedGoals INT NOT NULL,
    shortHandedAssists INT NOT NULL,
    blocked INT NOT NULL,
    plusMinus INT NOT NULL,
    evenTimeOnIce INT NOT NULL,
    shortHandedTimeOnIce INT NOT NULL,
    powerPlayTimeOnIce INT NOT NULL,
    FOREIGN KEY (game_id) REFERENCES game(game_id),
    FOREIGN KEY (player_id) REFERENCES player_info(player_id),
    FOREIGN KEY (team_id) REFERENCES team_info(team_id)
);

CREATE TABLE IF NOT EXISTS game_shifts (
    game_id INT NOT NULL,
    player_id INT NOT NULL,
    period INT NOT NULL,
    shift_start INT NOT NULL,
    shift_end INT NOT NULL,
    FOREIGN KEY (game_id) REFERENCES game(game_id),
    FOREIGN KEY (player_id) REFERENCES player_info(player_id)
);

CREATE TABLE IF NOT EXISTS game_plays (
    play_id VARCHAR(15) PRIMARY KEY,
    game_id INT NOT NULL,
    play_num INT NOT NULL,
    team_id_for INT,
    team_id_against INT,
    event VARCHAR(40) NOT NULL,
    secondaryType VARCHAR(255),
    x INT,
    y INT,
    period INT NOT NULL,
    periodType VARCHAR(15) NOT NULL,
    periodTime INT NOT NULL,
    periodTimeRemaining INT NOT NULL,
    dateTime DATE NOT NULL,
    goals_away INT NOT NULL,
    goals_home INT NOT NULL,
    description VARCHAR(255) NOT NULL,
    st_x INT,
    st_y INT,
    rink_side VARCHAR(5),
    FOREIGN KEY (game_id) REFERENCES game(game_id),
    FOREIGN KEY (team_id_for) REFERENCES team_info(team_id),
    FOREIGN KEY (team_id_against) REFERENCES team_info(team_id)
);

CREATE TABLE IF NOT EXISTS game_plays_players (
    play_id VARCHAR(15) NOT NULL,
    game_id INT NOT NULL,
    play_num INT NOT NULL,
    player_id INT NOT NULL,
    playerType VARCHAR(15) NOT NULL,
    FOREIGN KEY (play_id) REFERENCES game_plays(play_id),
    FOREIGN KEY (game_id) REFERENCES game(game_id),
    FOREIGN KEY (player_id) REFERENCES player_info(player_id)
);

CREATE TABLE IF NOT EXISTS game_teams_stats (
    game_id INT NOT NULL,
    team_id INT NOT NULL,
    HoA VARCHAR(4) NOT NULL,
    won BOOLEAN NOT NULL,
    settled_in VARCHAR(9) NOT NULL,
    head_coach VARCHAR(40) NOT NULL,
    goals INT NOT NULL,
    shots INT NOT NULL,
    hits INT NOT NULL,
    pim INT NOT NULL,
    powerPlayOpportunities INT NOT NULL,
    powerPlayGoals INT NOT NULL,
    faceoffWinPercentage NUMERIC(11, 8) NOT NULL,
    giveaways INT NOT NULL,
    takeaways INT NOT NULL,
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

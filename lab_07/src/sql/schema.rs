table! {
    game (game_id) {
        game_id -> Int4,
        season -> Int4,
        #[sql_name = "type"]
        type_ -> Varchar,
        date_time -> Date,
        date_time_gmt -> Timestamp,
        away_team_id -> Int4,
        home_team_id -> Int4,
        away_goals -> Int4,
        home_goals -> Int4,
        outcome -> Varchar,
        home_rink_start_side -> Varchar,
        venue -> Varchar,
        venue_link -> Varchar,
        venue_time_zone_id -> Varchar,
        venue_time_zone_offset -> Int4,
        venue_time_zone_tz -> Varchar,
    }
}

table! {
    game_skaters_stats (game_id, player_id) {
        game_id -> Int4,
        player_id -> Int4,
        team_id -> Int4,
        timeonice -> Int4,
        assists -> Int4,
        goals -> Int4,
        shots -> Int4,
        hits -> Int4,
        powerplaygoals -> Int4,
        powerplayassists -> Int4,
        penaltyminutes -> Int4,
        faceoffwins -> Int4,
        faceofftaken -> Int4,
        takeaways -> Int4,
        giveaways -> Int4,
        shorthandedgoals -> Int4,
        shorthandedassists -> Int4,
        blocked -> Int4,
        plusminus -> Int4,
        eventimeonice -> Int4,
        shorthandedtimeonice -> Int4,
        powerplaytimeonice -> Int4,
    }
}

table! {
    player_info (player_id) {
        player_id -> Int4,
        firstname -> Varchar,
        lastname -> Varchar,
        nationality -> Varchar,
        birthcity -> Varchar,
        primaryposition -> Varchar,
        birthdate -> Date,
        career -> Nullable<Json>,
    }
}

table! {
    team_info (team_id) {
        team_id -> Int4,
        franshizeid -> Int4,
        shortname -> Varchar,
        teamname -> Varchar,
        abbreviation -> Varchar,
    }
}

table! {
    warning_connections (id) {
        id -> Int4,
        cnt -> Int4,
    }
}

joinable!(game_skaters_stats -> game (game_id));
joinable!(game_skaters_stats -> player_info (player_id));
joinable!(game_skaters_stats -> team_info (team_id));

allow_tables_to_appear_in_same_query!(
    game,
    game_skaters_stats,
    player_info,
    team_info,
    warning_connections,
);

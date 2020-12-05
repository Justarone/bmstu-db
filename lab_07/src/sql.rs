use chrono::NaiveDate;
use diesel::pg::PgConnection;
use diesel::prelude::*;
use dotenv::dotenv;
use schema::*;
use std::env;

pub mod schema;

pub mod models;
use models::*;

const MY_ID: i32 = 5432;

fn connect() -> PgConnection {
    dotenv().ok();
    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    PgConnection::establish(&database_url).expect(&format!("Error connecting to {}", database_url))
}

fn single_table_query(connection: &PgConnection) {
    println!("SINGLE TABLE QUERY, GET FIRST 10 THE OLDEST ALEX LIKE PLAYERS");
    let result = player_info::table
        .select((
            player_info::firstname,
            player_info::lastname,
            player_info::birthdate,
        ))
        .filter(player_info::firstname.ilike("%alex%"))
        .order_by(player_info::birthdate)
        .limit(10)
        .load::<(String, String, chrono::NaiveDate)>(connection)
        .unwrap();
    for p in result {
        println!("{} {} ({})", p.0, p.1, p.2);
    }
}

fn multi_table_query(connection: &PgConnection) {
    println!("\nGOALS OF ALEX OVECHKIN IN FIRST 10 GAMES");
    let result = game_skaters_stats::table
        .inner_join(player_info::table)
        .inner_join(game::table)
        .filter(player_info::lastname.like("Ovechkin"))
        .select((
            player_info::firstname,
            player_info::lastname,
            game_skaters_stats::goals,
            game::date_time,
        ))
        .order_by(game::date_time)
        .limit(10)
        .load::<(String, String, i32, NaiveDate)>(connection)
        .unwrap();
    for r in result {
        println!("{} {}: {} goals on {:?}", r.0, r.1, r.2, r.3);
    }
}

fn cud_operations(connection: &PgConnection) {
    println!("\nCUD OPERATIONS (WITHOUT READ, READ WAS ON PREVIOUS STEP)");
    let new_teams = [
        Team {
            team_id: 666,
            franshizeid: 666,
            shortname: "Spartak",
            teamname: "Moscow",
            abbreviation: "SPA",
        },
        Team {
            team_id: 888,
            franshizeid: 888,
            shortname: "Dynamo",
            teamname: "Moscow",
            abbreviation: "DNM",
        },
    ];
    match diesel::insert_into(team_info::table)
        .values(&new_teams[..])
        .get_results::<QTeam>(connection)
    {
        Err(e) => println!("Can't insert: {}", e.to_string()),
        Ok(res) => println!("After insert:\n{:#?}", res),
    };
    match diesel::update(team_info::table.filter(team_info::team_id.ge(666)))
        .set(team_info::franshizeid.eq_all(10000))
        .get_results::<QTeam>(connection)
    {
        Err(_) => println!("Can't update!"),
        Ok(res) => println!("After update:\n{:#?}", res),
    };
    match diesel::delete(team_info::table.filter(team_info::franshizeid.ge(666)))
        .execute(connection)
    {
        Err(_) => println!("Can't delete!"),
        Ok(res) => println!("Delete: {:?}", res),
    }
}

fn check_warnings(connection: &PgConnection) {
    let my_warnings = warning_connections::table
        .filter(warning_connections::id.eq(MY_ID))
        .get_result::<(i32, i32)>(connection);
    match my_warnings {
        Ok(res) => println!("My warnings: {:?}", res),
        Err(e) => println!("Something went wrong: {:?}", e),
    };

}

fn data_access_with_stored_proc(connection: &PgConnection) {
    println!("\nCALL OF STORED PROCEDURE AND DATA CHECK!");
    check_warnings(connection);
    let res = diesel::sql_query("CALL warn_db($1)")
        .bind::<diesel::sql_types::Int4, _>(MY_ID)
        .execute(connection);
    match res {
        Ok(res) => println!("Procedure returned: {:?}", res),
        Err(e) => println!("Something went wrong: {}", e.to_string()),
    };
    check_warnings(connection);
}

pub fn run_all() {
    let connection = connect();
    single_table_query(&connection);
    multi_table_query(&connection);
    cud_operations(&connection);
    data_access_with_stored_proc(&connection);
}

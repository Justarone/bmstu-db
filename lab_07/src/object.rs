use std::error::Error;
use chrono::NaiveDate;
use serde_derive::Deserialize;

use super::constants;

mod utils;

type Career = Vec<CareerPart>;

#[derive(Debug, Clone, Deserialize)]
struct CareerPart {
    pub team_id: i32,
    pub interval: Interval,
}

#[derive(Debug, Clone, Deserialize)]
struct Interval {
    pub from: String,
    pub to: String,
}

#[derive(Debug, Clone)]
struct PlayerInfo {
    pub player_id: i32,
    pub first_name: String,
    pub last_name: String,
    pub nationality: String,
    pub birth_city: String,
    pub primary_position: String, 
    pub birth_date: NaiveDate,
    pub career: Career,
}

pub fn run_all(client: &mut postgres::Client) -> Result<(), Box<dyn Error>> {
    let players = utils::get_all_players(client)?;
    for rquery in utils::RUNNABLE_OBJECT_QUERIES.iter() {
        rquery(&players);
    }
    Ok(())
}

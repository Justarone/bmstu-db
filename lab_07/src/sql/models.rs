use diesel::{Queryable, Insertable};
use chrono::NaiveDate;
use super::schema::team_info;

#[derive(Queryable, Debug)]
pub struct Player {
    pub player_id: i32,
    pub first_name: String,
    pub last_name: String,
    pub nationality: String,
    pub birth_city: String,
    pub primary_position: String, 
    pub birth_date: NaiveDate,
    pub career: serde_json::Value,
}

#[derive(Insertable)]
#[table_name="team_info"]
pub struct Team<'a> {
    pub team_id: i32,
    pub franshizeid: i32,
    pub shortname: &'a str,
    pub teamname: &'a str,
    pub abbreviation: &'a str,
}

#[derive(Queryable, Debug)]
pub struct QTeam {
    pub team_id: i32,
    pub franshizeid: i32,
    pub shortname: String,
    pub teamname: String,
    pub abbreviation: String,
}

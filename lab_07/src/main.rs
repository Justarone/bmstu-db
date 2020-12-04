use std::error::Error;
use postgres::{ Client, NoTls };

mod object;
mod json;
mod sql;
mod constants;

fn main() -> Result<(), Box<dyn Error>> {
    let mut client = Client::connect(constants::CONNECTION_URL, NoTls).expect("Can't connect to db");
    object::run_all(&mut client)?;
    json::run_all()?;
    sql::run_all()
}

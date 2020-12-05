#[macro_use]
extern crate diesel;

use std::error::Error;
use postgres::{ Client, NoTls };

mod object;
mod json;
mod sql;
mod constants;

fn main() -> Result<(), Box<dyn Error>> {
    {
        let mut client = Client::connect(constants::CONNECTION_URL, NoTls)?;
        object::run_all(&mut client)?;
        json::run_all(&mut client)?;
    }
    sql::run_all();
    Ok(())
}

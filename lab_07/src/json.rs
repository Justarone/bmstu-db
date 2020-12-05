use serde_derive::{ Deserialize, Serialize };
use std::error::Error;

pub(super) type Career = Vec<CareerPart>;

const MAIN_QUERY: &str = "SELECT career FROM player_info WHERE lastName = 'Jagr'";

#[derive(Debug, Clone, Serialize, Deserialize)]
pub(super) struct CareerPart {
    pub team_id: i32,
    pub interval: Interval,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub(super) struct Interval {
    pub from: String,
    pub to: String,
}

fn read_career(
    client: &mut postgres::Client,
) -> Result<Career, Box<dyn Error>> {
    let qres = client.query(MAIN_QUERY, &[])?;
    if qres.len() > 1 {
        println!("That's weird, but there is more than just one row in query...");
    }
    let career_value = qres[0].get(0);
    let career = serde_json::from_value(career_value)?;
    Ok(career)
}

// Пусть до первой игры за новую команду считается, что игрок принадлжит предыдущей команде
fn update_career(c: &mut Career) {
    for i in 0..(c.len() - 1) {
        c[i].interval.to = c[i + 1].interval.from.clone();
    }
}

fn write_career(c: &mut Career) {
    let from = c[c.len() - 1].interval.to.clone();
    c.push(CareerPart {
        team_id: 1,
        interval: Interval {
            from, 
            to: String::from("2021-01-01"),
        }
    });
}

pub fn run_all(client: &mut postgres::Client) -> Result<(), Box<dyn Error>> {
    let mut career = read_career(client)?;
    println!("\n\nFIRST GAME FOR JAROMIR JAGR WAS ON {}\n", career[0].interval.from);
    println!("READ CAREER OF JAROMIR JAGR:\n{}\n", serde_json::to_string_pretty(&career)?);
    update_career(&mut career);
    println!("CAREER WAS UPDATED:\n{}\n", serde_json::to_string_pretty(&career)?);
    write_career(&mut career);
    println!("WROTE NEW TEAM IN CAREER:\n{}\n", serde_json::to_string_pretty(&career)?);
    Ok(())
}

use super::*;
use itertools::Itertools;
use std::collections::HashMap;

const MAIN_QUERY: &str = "SELECT * FROM player_info";
pub(super) const NQUERIES: usize = 5;
pub(super) const RUNNABLE_OBJECT_QUERIES: [fn(&[PlayerInfo]); NQUERIES] = [
    show_young_russians,
    show_young_russians,
    show_young_russians,
    show_young_russians,
    nationalities_and_cities,
];

pub(super) fn get_all_players(
    client: &mut postgres::Client,
) -> Result<Vec<PlayerInfo>, Box<dyn Error>> {
    let mut objects = Vec::new();
    for row in client.query(MAIN_QUERY, &[])? {
        let career_value = row.get(7);
        objects.push(PlayerInfo {
            player_id: row.get(0),
            first_name: row.get(1),
            last_name: row.get(2),
            nationality: row.get(3),
            birth_city: row.get(4),
            primary_position: row.get(5),
            birth_date: row.get(6),
            career: serde_json::from_value(career_value)?,
        });
    }

    Ok(objects)
}

// SELECT
// FROM
// WHERE
fn show_young_russians(players: &[PlayerInfo]) {
    println!("SHOW YOUNG RUSSIAN PLAYERS");
    for player in players.iter().filter_map(|p| {
        if p.nationality == "RUS" && p.birth_date > NaiveDate::from_ymd(1995, 1, 1) {
            Some(format!(
                "{:<20} {:<20} {:<10}",
                p.first_name,
                p.last_name,
                p.birth_date.to_string()
            ))
        } else {
            None
        }
    }) {
        println!(" {}", player);
    }
}

// SELECT
// FROM
// ORDER BY
fn nationalities_and_cities(players: &[PlayerInfo]) {
    println!("AGGREGATION BY NATIONALITY AND BEST CITY FOR EVERY NATION");
    let mut nationality_cities = HashMap::new();
    for (nationality, group) in &players
        .iter()
        .map(|p| (&p.nationality, &p.birth_city))
        .group_by(|p| p.0.clone())
    {
        let cities = nationality_cities
            .entry(nationality)
            .or_insert(HashMap::new());
        for (_, city) in group {
            let count = cities.entry(city).or_insert(0);
            *count += 1;
        }
    }

    for (nationality, cities) in nationality_cities.iter() {
        let (best_city, count) = cities.iter().fold((String::from(""), 0), |acc, (city, count)| {
            if acc.1 < *count {
                (city.to_string(), *count)
            } else {
                acc
            }
        });
        println!("{:<4} - {} ({})", nationality, best_city, count);
    }
}

// HAVING
// ORDER BY

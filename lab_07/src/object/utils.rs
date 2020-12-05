use super::*;
use itertools::Itertools;
use std::collections::HashMap;

const MAIN_QUERY: &str = "SELECT * FROM player_info";
pub(super) const NQUERIES: usize = 5;
pub(super) const RUNNABLE_OBJECT_QUERIES: [fn(&[PlayerInfo]); NQUERIES] = [
    show_young_russians,
    nationalities_and_cities,
    hockey_nations,
    oldest_player,
    players_from_moscow,
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
    println!("\nSHOW YOUNG RUSSIAN PLAYERS");
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
    println!("\nAGGREGATION BY NATIONALITY AND BEST CITY FOR EVERY NATION");
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
        let (best_city, count) = cities
            .iter()
            .fold((String::from(""), 0), |acc, (city, count)| {
                if acc.1 < *count {
                    (city.to_string(), *count)
                } else {
                    acc
                }
            });
        println!("{:<4} - {} ({})", nationality, best_city, count);
    }
}

// SELECT
// FROM
// GROUP BY
// HAVING
// ORDER BY
fn hockey_nations(players: &[PlayerInfo]) {
    println!("\nHOCKEY NATIONS (MORE THAN 10 PLAYERS IN NHL)");
    for (nationality, count) in players
        .iter()
        .map(|p| p.nationality.clone())
        .sorted()
        .group_by(|n| n.clone())
        .into_iter()
        .filter_map(|(n, g)| {
            let count = g.count();
            if count > 10 {
                Some((n, count))
            } else {
                None
            }
        })
    {
        println!("{:<5}({:^4})", nationality, count);
    }
}

fn oldest_player(players: &[PlayerInfo]) {
    println!("\nOLDEST PLAYER IN THIS DATABASE");
    let oldest_player = players.iter().min_by_key(|p| p.birth_date).unwrap();
    println!(
        "Oldest player is {} {} ({:?})",
        oldest_player.first_name, oldest_player.last_name, oldest_player.birth_date
    );
}

fn players_from_moscow(players: &[PlayerInfo]) {
    println!("\nPLAYERS FROM MOSCOW");
    for p in players.iter().filter(|p| p.birth_city == "Moscow") {
        println!("{:<20} {:<20} {:?}", p.first_name, p.last_name, p.birth_date);
    }
}

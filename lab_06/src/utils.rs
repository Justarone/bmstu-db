use super::queries::DESCRIPTIONS;
use postgres::SimpleQueryRow;

pub fn print_menu() {
    for (i, desc) in DESCRIPTIONS.iter().enumerate() {
        println!("{}. {};", i + 1, desc);
    }
    println!("{}. Выход.", DESCRIPTIONS.len() + 1);
}

pub fn read_input() -> usize {
    let mut res = String::new();
    std::io::stdin().read_line(&mut res).expect("read input");
    res.trim().parse::<usize>().expect("parse to usize") - 1
}

pub fn print_row(row: &SimpleQueryRow) {
    for i in 0..row.len() {
        print!("█ {:^20} █ ", row.get(i).unwrap());
    }
    println!("");
}

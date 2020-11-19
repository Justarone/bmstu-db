use postgres::{Client, NoTls, SimpleQueryMessage};
mod constants;
mod queries;
mod utils;
use utils::{print_menu, print_row, read_input};

fn main() {
    let mut client = Client::connect(constants::CONNECTION_URL, NoTls).expect("connect to db");
    loop {
        print_menu();

        let n = match read_input() {
            val if val < queries::QUERIES.len() => val,
            val if val == queries::QUERIES.len() => break,
            _ => {
                println!("Wrong number, try again!");
                continue;
            }
        };

        for row in client.simple_query(queries::QUERIES[n]).unwrap().iter() {
            match row {
                SimpleQueryMessage::Row(row) => print_row(row),
                SimpleQueryMessage::CommandComplete(val) => println!("numeric value: {}", val),
                _ => println!("What?"),
            }
        }
    }

    println!("End of program, bye!")
}

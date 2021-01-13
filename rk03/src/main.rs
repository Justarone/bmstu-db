// var 1
use chrono::{NaiveDate, NaiveTime};
use itertools::Itertools;
use postgres::{Client, NoTls};
use std::error::Error;
use std::io::prelude::*;

mod queries {
    pub const Q1: &str = r#"
        select department
        from empls_list
        group by department
        having count(*) > 10;
    "#;
    pub const Q2: &str = r#"
        with bad_ids as (
            select distinct id
            from empls_actions
            where inout = 2
            group by id, dt
            having count(*) > 1
        )
        select fio
        from empls_list
        where id not in (
            select id
            from bad_ids
        );
    "#;
    pub const Q3: &str = r#"
        with bad_ids as (
            select id
            from empls_actions
            where inout = 1 AND dt = $1
            group by id
            having min(t) > '9:30'
        )
        select distinct department
        from empls_list
        where id in (
            select id
            from bad_ids
        );
    "#;
}

struct Action<'a> {
    id: i32,
    date: NaiveDate,
    weekday: &'a str,
    time: NaiveTime,
    inout: i32,
}

struct Employee<'a> {
    id: i32,
    fio: &'a str,
    birthdate: NaiveDate,
    department: &'a str,
}

const CONNECTION_STRING: &str = "dbname=rk03 host=localhost user=justarone password=password";

fn main() -> Result<(), Box<dyn Error>> {
    let mut client = Client::connect(CONNECTION_STRING, NoTls)?;

    // SQL
    println!("Q1");
    for row in client.query(queries::Q1, &[])? {
        let dp: &str = row.get(0);
        println!("{}", dp);
    }

    println!("Q2");
    for row in client.query(queries::Q2, &[])? {
        let fio: &str = row.get(0);
        println!("{}", fio);
    }

    let mut date = String::new();
    print!("Enter year: ");
    std::io::stdout().flush().unwrap();
    std::io::stdin().read_line(&mut date).unwrap();
    let year = date.trim().parse().unwrap();
    date.clear();
    print!("Enter month: ");
    std::io::stdout().flush().unwrap();
    std::io::stdin().read_line(&mut date).unwrap();
    let month = date.trim().parse().unwrap();
    date.clear();
    print!("Enter day: ");
    std::io::stdout().flush().unwrap();
    std::io::stdin().read_line(&mut date).unwrap();
    let day = date.trim().parse().unwrap();

    let date = NaiveDate::from_ymd(year, month, day);

    println!("Q3");
    for row in client.query(queries::Q3, &[&date])? {
        let dp: &str = row.get(0);
        println!("{}", dp);
    }

    // Rust
    let employees = client.query("SELECT * FROM empls_list", &[])?;
    let employees: Vec<Employee> = employees
        .iter()
        .map(|row| Employee {
            id: row.get(0),
            fio: row.get(1),
            birthdate: row.get(2),
            department: row.get(3),
        })
        .collect();
    let actions = client.query("SELECT * FROM empls_actions", &[])?;
    let actions: Vec<Action> = actions
        .iter()
        .map(|row| Action {
            id: row.get(0),
            date: row.get(1),
            weekday: row.get(2),
            time: row.get(3),
            inout: row.get(4),
        })
        .collect();

    println!("Q1 on Rust");
    for (k, g) in &employees
        .iter()
        .map(|e| e.department)
        .sorted()
        .group_by(|&d| d)
    {
        if g.count() > 10 {
            println!("{}", k);
        }
    }

    Ok(())
}

CREATE TABLE IF NOT EXISTS empls_list (
    id int primary key,
    fio varchar,
    birthdate date,
    department varchar
);

CREATE TABLE IF NOT EXISTS empls_actions (
    id int,
    dt date,
    weekday varchar,
    t time,
    inout int,
    foreign key (id) references empls_list (id)
);

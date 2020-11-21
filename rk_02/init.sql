-- 3

CREATE TABLE IF NOT EXISTS menu (
    id int primary key,
    name varchar(30),
    mtype varchar(20),
    description varchar(256)
);

CREATE TABLE IF NOT EXISTS dishes (
    id int primary key,
    name varchar(30),
    description varchar(256),
    rating int
);

CREATE TABLE IF NOT EXISTS products (
    id int primary key,
    name varchar(30),
    man_date date,
    available_until date,
    man_name varchar(30)
);

CREATE TABLE IF NOT EXISTS PD (
    pid int,
    did int,
    primary key (pid, did),
    foreign key (pid) references products(id),
    foreign key (did) references dishes(id)
);

CREATE TABLE IF NOT EXISTS MD (
    mid int, 
    did int,
    primary key (did, mid),
    foreign key (did) references dishes(id),
    foreign key (mid) references menu(id)
);

pub const QUERIES_COUNT: usize = 10;

pub const QUERIES: [&str; QUERIES_COUNT] = [
    // 1 (выводит кол-во голов в первой игре Остона Мэтьюса)
    "
        SELECT goals
        FROM game_skaters_stats gss
        JOIN game g
        ON gss.game_id = g.game_id
        JOIN player_info pi
        ON gss.player_id = pi.player_id
        WHERE lastName = 'Matthews'
        ORDER BY date_time_GMT
        LIMIT 1;
    ",
    // 2 (выводит таблицу всех игроков и кол-во их голов в их первой игре)
    "
        WITH pd (pid, date) AS (
            SELECT player_id as pid, min(date_time_GMT)
            FROM game_skaters_stats gss
            JOIN game g
            ON gss.game_id = g.game_id
            GROUP BY player_id
        )
        SELECT firstName, lastName, goals
        FROM game_skaters_stats gss
        JOIN game g
        ON gss.game_id = g.game_id
        JOIN pd
        ON pd.pid = gss.player_id AND pd.date = g.date_time_GMT
        JOIN player_info pi
        ON pi.player_id = pd.pid
        ORDER BY goals ASC;
    ",
    // 3 (выводит максимальное кол-во голов игрока в одном матче И сравнение со средним из всех его тесок)
    "
        WITH pid_mg (player_id, goals)
        AS (
            SELECT player_id, MAX(goals)
            FROM game_skaters_stats
            GROUP BY player_id
        )
        SELECT firstName, lastName, goals AS MaxGoals,
        AVG(goals) OVER (PARTITION BY firstName) AS AvgGoals
        FROM player_info pi
        JOIN pid_mg
        ON pi.player_id = pid_mg.player_id;
    ",
    // 4 (выводит таблицы, содержащие 'game' в названии)
    "
        SELECT table_name
        FROM information_schema.tables
        WHERE table_name LIKE '%game%'
    ",
    // 5 (выызвает функцию, которая выводит средний возраст "экспертов")
    "
        SELECT expert_avg_age(500);
    ",
    // 6 (выводит список экспертов, используя табличную функцию list_of_experts)
    "
        SELECT firstName, lastName, birthDate, game_cnt 
        FROM list_of_experts(500) loe
        JOIN player_info pi
        ON pi.player_id = loe.player_id
        ORDER BY game_cnt DESC;
    ",
    // 7 (вызов процедуры, которая создает новую таблицу "игроки-голы")
    "
    CALL players_goals();
    ",
    // 8 (вызов системных функций: время на системе, текущая база и пользователь)
    "
    SELECT pg_postmaster_start_time(), current_database(), current_user;
    ",
    // 9 (создание таблицы лучших болельщиков и их клубов)
    "
    CREATE TABLE IF NOT EXISTS mvp_fans (
        id SERIAL PRIMARY KEY,
        firstName VARCHAR(30),
        lastName VARCHAR(30),
        team_id INT,
        FOREIGN KEY (team_id) REFERENCES team_info(team_id)
    );
    ",
    // 10 (вставка значений в таблицу лучших болельщиков)
    "
    INSERT INTO mvp_fans (firstName, lastName, team_id)
    VALUES 
    ('Ivan', 'Ivanov', 3),
    ('Ivan', 'Petrov', 4);
    ",
];

pub const DESCRIPTIONS: [&str; QUERIES_COUNT] = [
    "Выполнить скалярный запрос",
    "Выполнить запрос с несколькими соединениями (JOIN)",
    "Выполнить запрос с ОТВ (CTE) и оконными функциями",
    "Выполнить запрос к метаданным",
    "Вызвать скалярную функцию (написанную в третьей лабораторной работе)",
    "Вызывать многооператорную или табличную функцию (написанную в третьей лабораторной работе)",
    "Вызывать хранимую процедуру (написанную в третьей лабораторной работе)",
    "Вызывать системную функцию или процедуру",
    "Создать таблицу в базе данных, соответствующую тематике БД",
    "Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY",
];

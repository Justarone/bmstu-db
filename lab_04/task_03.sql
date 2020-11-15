-- Определяемая пользователем табличная функция CLR

CREATE OR REPLACE FUNCTION big_events()
RETURNS TABLE (
    person VARCHAR,
    time_date DATE,
    place VARCHAR,
    event VARCHAR
)
AS $$
    def get_event_type(ngoals, nassists):
        event_type = ''
        if ngoals > MIN_GOALS:
            if ngoals + nassists > MIN_POINTS:
                event_type = f"scored {ngoals} goals and got {ngoals + nassists} points"
            else:
                event_type = f"scored {ngoals} goals"
        else:
            event_type = f"got {ngoals + nassists} points"
        return event_type

    MIN_GOALS = 3;
    MIN_POINTS = 5;

    res = plpy.execute(f" \
        SELECT firstName || ' ' || lastName as fi, goals, assists, date_time, venue \
        FROM game_skaters_stats gss \
        JOIN game \
        ON gss.game_id = game.game_id \
        JOIN player_info pi \
        ON pi.player_id = gss.player_id \
        WHERE goals > {MIN_GOALS} OR goals + assists > {MIN_POINTS} \
    ")
    for event in res:
            yield (event["fi"], event['date_time'], event['venue'],
                get_event_type(event['goals'], event['assists']))

$$ LANGUAGE PLPYTHON3U;

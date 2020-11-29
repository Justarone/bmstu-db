DROP TABLE IF EXISTS team_info_raw;
CREATE TEMP TABLE team_info_raw (
    data json
);

\copy team_info_raw from 'lab_05/tmp/team_info.json'

DROP TABLE IF EXISTS team_info_json;
CREATE TABLE team_info_json (
    team_id INT PRIMARY KEY,
    franshizeId INT NOT NULL,
    shortName VARCHAR(20) NOT NULL,
    teamName VARCHAR(20) NOT NULL,
    abbreviation VARCHAR(3) NOT NULL
);

INSERT INTO team_info_json (team_id, franshizeId, shortName, teamName, abbreviation)
SELECT (data->>'team_id')::INT, (data->>'franshizeid')::INT, data->>'shortname', data->>'teamname', data->>'abbreviation'
FROM team_info_raw;

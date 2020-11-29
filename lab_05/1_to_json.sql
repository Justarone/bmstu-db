\t on
\o lab_05/tmp/team_info.json
\pset format unaligned
SELECT row_to_json(ti) FROM team_info ti;
\o
\t off
\pset format aligned

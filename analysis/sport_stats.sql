--======= CREATING THE DATA STRUCTURE FROM A MESSY CSV TO POSTGRESQL DATABASE =======---

-- psql -U postgres
-- CREATE DATABASE sport_stats;
-- psql -U postgres -d sport_stats;

--== 1. Create raw table of all the data about athletes and regions:
CREATE TABLE staging_olympics (
    id INT,
    name TEXT,
    sex TEXT,
    age NUMERIC,
    height NUMERIC,
    weight NUMERIC,
    team TEXT,
    noc TEXT,
    games TEXT,
    year INT,
    season TEXT,
    city TEXT,
    sport TEXT,
    event TEXT,
    medal TEXT
);

-- populate:
COPY staging_olympics 
FROM '/Users/dariaskibo/Documents/2026/2026_coursera_ucdavis_sql/ucdavis_c4_projects/sport_stats/data_sport/clean_athlete_events.csv' 
WITH (FORMAT csv, HEADER true, NULL '');

--== 2. Create the region table (from the second file):
--DROP TABLE IF EXISTS region CASCADE;
--DROP TABLE IF EXISTS region_raw CASCADE;

CREATE TABLE region_raw (
    noc TEXT,
    region TEXT,
    notes TEXT
);

COPY region_raw 
FROM '/Users/dariaskibo/Documents/2026/2026_coursera_ucdavis_sql/ucdavis_c4_projects/sport_stats/data_sport/noc_regions.csv' 
WITH (FORMAT csv, HEADER true, NULL '');

CREATE TABLE region (
    noc_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    noc TEXT,
    region TEXT,
    notes TEXT
);

INSERT INTO region (noc, region, notes)
SELECT DISTINCT noc, region, notes
FROM region_raw;

--== 3. now we create our additional tables:
-- 3.1. TEAM
DROP TABLE IF EXISTS team CASCADE;
CREATE TABLE team (
    team_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    team_name TEXT,
    noc_id INT REFERENCES region(noc_id)
);

--- populate TEAM table with unique values from staging
INSERT INTO team (team_name, noc_id)
SELECT DISTINCT s.team, r.noc_id
FROM staging_olympics AS s
JOIN region as r ON s.noc = r.noc
WHERE team IS NOT NULL;

-- 3.2. ATHLETE
--DROP TABLE IF EXISTS athlete CASCADE;
CREATE TABLE athlete (
    athlete_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT,
    sex TEXT
);

--- populate it:
INSERT INTO athlete (name, sex)
SELECT DISTINCT 
    name, 
    sex
FROM staging_olympics
WHERE name IS NOT NULL;

-- 3.3. GAME
--DROP TABLE IF EXISTS game CASCADE;
CREATE TABLE game (
    game_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    year INT,
    season TEXT,
    city TEXT,
    game TEXT
);

--- populate GAME:
INSERT INTO game (year, season, city, game)
SELECT DISTINCT 
    year, 
    season,
    city,
    games
FROM staging_olympics
WHERE games IS NOT NULL;

-- 3.4. Create EVENT table:
--DROP TABLE IF EXISTS event CASCADE;
CREATE TABLE event (
    event_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sport TEXT,
    event_name TEXT
);

--- populate EVENT
INSERT INTO event (sport, event_name)
SELECT DISTINCT 
    sport, 
    event
FROM staging_olympics
WHERE sport IS NOT NULL AND event IS NOT NULL;

-- 3.5. Create table ATHLETE_GAMES
DROP TABLE IF EXISTS athlete_games CASCADE;
CREATE TABLE athlete_games (
    participation_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    athlete_id INT REFERENCES athlete(athlete_id),
    game_id INT REFERENCES game(game_id),
    team_id INT REFERENCES team(team_id),
    event_id INT REFERENCES event(event_id),
    age NUMERIC,
    height NUMERIC,
    weight NUMERIC
);

--- populate it:
INSERT INTO athlete_games (athlete_id, game_id, event_id, team_id, age, height, weight)
SELECT 
    a.athlete_id,
    g.game_id,
    e.event_id, 
    t.team_id,
    s.age,
    s.height,
    s.weight
FROM staging_olympics s
JOIN athlete a ON s.name = a.name AND s.sex = a.sex
JOIN team t ON s.team = t.team_name
JOIN game g ON s.games = g.game
JOIN event e ON s.event = e.event_name;

-- 3.6. RESULT_AWARD
DROP TABLE IF EXISTS result_award CASCADE;
CREATE TABLE result_award(
    result_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    participation_id INT REFERENCES athlete_games(participation_id),
    event_id INT REFERENCES event(event_id),
    medal_type TEXT
);

--- populate it:
INSERT INTO result_award (participation_id, event_ID, medal_type)
SELECT 
    ag.participation_id,
    e.event_id,
    s.medal
FROM staging_olympics s
JOIN athlete a ON s.name = a.name AND s.sex = a.sex
JOIN game g ON s.games = g.game
JOIN team t ON s.team = t.team_name
JOIN athlete_games ag ON ag.athlete_id = a.athlete_id 
                     AND ag.game_id = g.game_id 
                     AND ag.team_id = t.team_id
JOIN event e ON s.sport = e.sport AND s.event = e.event_name
WHERE s.medal IS NOT NULL;

--== 4. Remove the tables we don't need anymore:
DROP TABLE region_raw;
DROP TABLE staging_olympics;
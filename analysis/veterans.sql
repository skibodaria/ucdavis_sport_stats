/* Repetative Participation Stats */

-- how many people ever participated in OGs:
SELECT
	COUNT(DISTINCT athlete_id)
FROM athlete_games;
-- >>> 134 621

-- How many appearances and how many participations those people have?
SELECT
	ag.athlete_id,
	a.name,
	region.region AS country,
	COUNT(ag.athlete_id) AS appearances,
	COUNT(DISTINCT ag.game_id) AS participations,
	CASE
		WHEN COUNT(ag.athlete_id) OVER() > 1 THEN 'veteran'
		ELSE 'one-time'
	END AS athlete_returned
FROM athlete_games AS ag
JOIN team USING(team_id) JOIN region USING(noc_id)
JOIN athlete AS a USING(athlete_id)
GROUP BY ag.athlete_id, a.name, region.region
HAVING COUNT(DISTINCT ag.game_id) > 3                   --- with the focus on those who returned more than 3 times
ORDER BY COUNT(DISTINCT ag.game_id) DESC;

-- How many of them in total?
WITH all_veterans AS (
SELECT
	ag.athlete_id,
	a.name,
	region.region AS country,
	COUNT(ag.athlete_id) AS appearances,
	COUNT(DISTINCT ag.game_id) AS participations,
	CASE
		WHEN COUNT(ag.athlete_id) OVER() > 1 THEN 'veteran'
		ELSE 'one-time'
	END AS athlete_returned
FROM athlete_games AS ag
JOIN team USING(team_id) JOIN region USING(noc_id)
JOIN athlete AS a USING(athlete_id)
GROUP BY ag.athlete_id, a.name, region.region
HAVING COUNT(DISTINCT ag.game_id) > 3
ORDER BY COUNT(DISTINCT ag.game_id) DESC)
SELECT
	COUNT (*)
FROM all_veterans;
-->>>3 286

-- What's the proportion of those among all the participants of all the games?
WITH athlete_summary AS (
    SELECT
        ag.athlete_id,
        COUNT(DISTINCT ag.game_id) AS total_games
    FROM athlete_games AS ag
    GROUP BY ag.athlete_id
),
metrics AS (
    SELECT
        COUNT(athlete_id) AS total_participants,
        COUNT(CASE WHEN total_games > 1 THEN 1 END) AS total_veterans,
        COUNT(CASE WHEN total_games = 1 THEN 1 END) AS total_one_time
    FROM athlete_summary
)
SELECT
    total_participants,
    total_veterans,
    ROUND(100.0 * total_veterans / total_participants, 2) AS veteran_percentage
FROM metrics;
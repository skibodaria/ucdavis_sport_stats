-- EDA with SQL

---- total athletes (unique)
SELECT DISTINCT COUNT(athlete_id)
FROM public.athlete;
---- 134 787

---- total athletes by gender:
SELECT DISTINCT sex, COUNT(athlete_id)
FROM public.athlete
GROUP BY sex;

---- total athletes by year:
SELECT g.YEAR, COUNT(ag.athlete_id)
FROM athlete_games AS ag
JOIN game AS g ON ag.game_id = g.game_id
GROUP BY g.YEAR
ORDER BY g.YEAR;

---- total athletes by year and gender:
SELECT g.YEAR, a.sex, COUNT(ag.athlete_id)
FROM athlete_games AS ag
JOIN athlete AS a ON ag.athlete_id = a.athlete_id
JOIN game AS g ON ag.game_id = g.game_id
GROUP BY g.YEAR, a.sex
ORDER BY g.YEAR, a.sex;

---- total unique athletes per sport discipline and per sex:
SELECT 
	g.season,
	e.sport,
	a.sex,
	COUNT(DISTINCT a.athlete_id)
FROM athlete AS a
JOIN athlete_games AS ag ON a.athlete_id = ag.athlete_id
JOIN EVENT AS e ON ag.event_id = e.event_id
JOIN game AS g ON ag.game_id = g.game_id
GROUP BY g.season, e.sport, a.sex
ORDER BY COUNT(DISTINCT a.athlete_id) DESC;

-- total unique athletes per games:
SELECT 
	g.season,
	g.game,
	g.YEAR,
	--a.sex,
	COUNT(DISTINCT a.athlete_id)
FROM athlete AS a
JOIN athlete_games AS ag ON a.athlete_id = ag.athlete_id
JOIN EVENT AS e ON ag.event_id = e.event_id
JOIN game AS g ON ag.game_id = g.game_id
GROUP BY g.YEAR, g.season, g.game--, a.sex
ORDER BY g.year;

-- total unique athletes per games and with sex:
SELECT 
	g.season,
	g.game,
	g.YEAR,
	a.sex,
	COUNT(DISTINCT a.athlete_id)
FROM athlete AS a
JOIN athlete_games AS ag ON a.athlete_id = ag.athlete_id
JOIN EVENT AS e ON ag.event_id = e.event_id
JOIN game AS g ON ag.game_id = g.game_id
GROUP BY g.YEAR, g.season, g.game, a.sex
ORDER BY g.year;

---- total teams(countries) per game:
SELECT g.YEAR, COUNT(DISTINCT t.team_id) AS number_of_teams
FROM team AS t
JOIN athlete_games AS ag ON t.team_id=ag.team_id
JOIN game AS g ON ag.game_id=g.game_id
GROUP BY g.YEAR
ORDER BY g.YEAR;
/* Here is a draft of differening approaches to work with "elite" countries definition
 * Performed for the Assignmnet 2a
 */

-- Approach 1: Above average countries (gives ~90% vs ~10% shares for elite/not-elite):
WITH medals_over_years AS (
    SELECT
        r.region AS country,
        g.YEAR AS YEAR,
        e.sport,
        COUNT(ra.medal_type) AS medals_count
    FROM region AS r
    JOIN team AS t ON r.noc_id = t.noc_id
    JOIN athlete_games AS ag ON t.team_id = ag.team_id
    JOIN result_award AS ra ON ag.participation_id = ra.participation_id
    JOIN game AS g ON ag.game_id = g.game_id
    JOIN EVENT AS e ON ag.event_id = e.event_id
    GROUP BY g.YEAR, r.region, e.sport
),

country_totals AS (
    SELECT 
        country,
        SUM(medals_count) AS total_medals_per_country
    FROM medals_over_years
    GROUP BY country
),

elite_status AS (
    SELECT 
        country,
        total_medals_per_country,
        CASE
            WHEN total_medals_per_country > AVG(total_medals_per_country) OVER() THEN 'elite'
            ELSE 'not_elite' 
        END AS elite_status
    FROM country_totals
)

/* check which countries are elite + how many medals they have
SELECT *
FROM elite_status
WHERE elite_status = 'elite'
ORDER BY total_medals_per_country DESC;
*/ 

/* check which countries are NOT elite + how many medals they have
SELECT *
FROM elite_status
WHERE elite_status = 'not_elite'
ORDER BY total_medals_per_country ASC;
*/ 

/* check the medals share:*/
SELECT
	SUM(total_medals_per_country) AS total_medals,
    SUM(total_medals_per_country) FILTER (WHERE elite_status = 'elite') AS total_elite_medals,
    SUM(total_medals_per_country) FILTER (WHERE elite_status = 'not_elite') AS total_not_elite_medals,
    
    ROUND(100.0* SUM(total_medals_per_country) FILTER (WHERE elite_status = 'elite') / SUM(total_medals_per_country), 2) AS elite_share,
    ROUND(100.0* SUM(total_medals_per_country) FILTER (WHERE elite_status = 'not_elite') / SUM(total_medals_per_country), 2) AS not_elite_share
FROM elite_status;

-- ANOTHER APPROACH: Based on Pareto principle (when the cummulatuve percent reaches 80, we stop collecting "elite countries" in the list)
WITH medals_over_years AS (
    SELECT
        r.region AS country,
        g.YEAR AS YEAR,
        e.sport,
        COUNT(ra.medal_type) AS medals_count
    FROM region AS r
    JOIN team AS t ON r.noc_id = t.noc_id
    JOIN athlete_games AS ag ON t.team_id = ag.team_id
    JOIN result_award AS ra ON ag.participation_id = ra.participation_id
    JOIN game AS g ON ag.game_id = g.game_id
    JOIN EVENT AS e ON ag.event_id = e.event_id
    GROUP BY g.YEAR, r.region, e.sport
),

country_totals AS (
    SELECT 
        country,
        SUM(medals_count) AS total_medals
    FROM medals_over_years
    GROUP BY country
),
running_totals AS (
    SELECT 
        country,
        total_medals,
        SUM(total_medals) OVER (ORDER BY total_medals DESC) AS running_medals,
        SUM(total_medals) OVER () AS grand_total_medals
    FROM country_totals
)
SELECT 
    country,
    total_medals,
    ROUND(100.0 * running_medals / grand_total_medals, 2) AS cumulative_pct,
    CASE 
        WHEN (running_medals - total_medals) / grand_total_medals < 0.80 THEN 'elite (top 80% share)'
        ELSE 'not_elite'
    END AS elite_status
FROM running_totals
ORDER BY ROUND(100.0 * running_medals / grand_total_medals, 2);


-- ANOTHER APPROACH: Ranking by percentiles (the one I used in the end)
WITH medals_over_years AS (
    SELECT
        r.region AS country,
        g.YEAR AS YEAR,
        e.sport,
        COUNT(ra.medal_type) AS medals_count
    FROM region AS r
    JOIN team AS t ON r.noc_id = t.noc_id
    JOIN athlete_games AS ag ON t.team_id = ag.team_id
    JOIN result_award AS ra ON ag.participation_id = ra.participation_id
    JOIN game AS g ON ag.game_id = g.game_id
    JOIN EVENT AS e ON ag.event_id = e.event_id
    GROUP BY g.YEAR, r.region, e.sport
),
country_totals AS (
    SELECT 
        country,
        SUM(medals_count) AS total_medals
    FROM medals_over_years
    GROUP BY country
),
ranked_countries AS (
    SELECT 
        country,
        total_medals,
        PERCENT_RANK() OVER (ORDER BY total_medals DESC) AS pct_rank
    FROM country_totals
),
tiers AS 
(SELECT 
    country,
    total_medals,
    CASE 
        WHEN pct_rank <= 0.10 THEN 'Elite (Top 10%)'
        WHEN pct_rank <= 0.25 THEN 'High Performing (Top 25%)'
        ELSE 'Standard'
    END AS tier
FROM ranked_countries
)

SELECT
	SUM(total_medals) AS total_medals,
    SUM(total_medals) FILTER (WHERE tier = 'Elite (Top 10%)') AS total_elite_medals,
    SUM(total_medals) FILTER (WHERE tier != 'Elite (Top 10%)') AS total_not_elite_medals,
    
    ROUND(100.0* SUM(total_medals) FILTER (WHERE tier = 'Elite (Top 10%)') / SUM(total_medals), 2) AS elite_share,
    ROUND(100.0* SUM(total_medals) FILTER (WHERE tier != 'Elite (Top 10%)') / SUM(total_medals), 2) AS not_elite_share
FROM tiers;
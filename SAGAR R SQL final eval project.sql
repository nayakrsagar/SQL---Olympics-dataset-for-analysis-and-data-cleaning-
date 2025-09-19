-- creating athlete table
CREATE TABLE athlete_events (
  ID_ int, Name_ varchar, Sex char(1), Age int,
  Height float, Weight float, Team varchar, NOC varchar, Games varchar,
  Year_ int, Season varchar, City varchar, Sport varchar,
  Events varchar, Medal varchar);


--linking csv with database
COPY athlete_events FROM 'D:/athlete_events.csv' DELIMITER ',' CSV HEADER NULL 'NA';


--creating noc table
CREATE TABLE noc_regions (
  NOC varchar,
  Region varchar,
  Notes varchar);


--linking noc csv with database
COPY noc_regions FROM 'D:/noc_regions.csv' DELIMITER ',' CSV HEADER NULL 'NA';


--converting age to numbers
ALTER TABLE athlete_events
ALTER COLUMN Age TYPE int
USING NULLIF (TRIM(Age::varchar),'')::int;


--converting height to numbers
ALTER TABLE athlete_events
ALTER COLUMN Height TYPE float
USING NULLIF (TRIM(Height::varchar),'')::float;


--converting weight to numbers
ALTER TABLE athlete_events
ALTER COLUMN Weight TYPE float
USING NULLIF (TRIM(Weight::varchar),'')::float;


--counting missing age,heights,weights
SELECT
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN Height IS NULL THEN 1 ELSE 0 END) AS missing_height,
    SUM(CASE WHEN Weight IS NULL THEN 1 ELSE 0 END) AS missing_weight
FROM
    athlete_events;


--standardizing the values
UPDATE athlete_events
SET Medal = INITCAP(Medal)
WHERE Medal IS NOT NULL;


--10 countries with the highest number of total medals won
SELECT
    b.region AS country,
    COUNT(a.Medal) AS total_medals
FROM
    athlete_events AS a
JOIN
    noc_regions AS b ON a.NOC = b.NOC
WHERE
    a.Medal IS NOT NULL
GROUP BY
    b.region
ORDER BY
    total_medals DESC
LIMIT 10;


--medals won by the top 10 countries in the Summer Games versus Winter Games.
WITH TopCountries AS (
    SELECT
        b.region
    FROM
        athlete_events AS a
    JOIN
        noc_regions AS b ON a.NOC = b.NOC
    WHERE
        a.Medal IS NOT NULL
    GROUP BY
        b.region
    ORDER BY
        COUNT(a.Medal) DESC
    LIMIT 10
)
SELECT
    b.region AS country,
    SUM(CASE WHEN a.Season = 'Summer' THEN 1 ELSE 0 END) AS summer_medals,
    SUM(CASE WHEN a.Season = 'Winter' THEN 1 ELSE 0 END) AS winter_medals
FROM
    athlete_events AS a
JOIN
    noc_regions AS b ON a.NOC = b.NOC
WHERE
    a.Medal IS NOT NULL AND b.region IN (SELECT region FROM TopCountries)
GROUP BY
    b.region
ORDER BY
    summer_medals DESC;


--5 athletes with the highest number of Olympic medals
SELECT
    Name_ AS athlete,
    COUNT(Medal) AS total_medals
FROM
    athlete_events
WHERE
    Medal IS NOT NULL
GROUP BY
    Name_
ORDER BY
    total_medals DESC
LIMIT 5;


--highest percentage of Gold medals
SELECT
    b.region AS country,
    SUM(CASE WHEN a.Medal = 'Gold' THEN 1 ELSE 0 END) AS gold_medals,
    COUNT(a.Medal) AS total_medals,
    (SUM(CASE WHEN a.Medal = 'Gold' THEN 1 ELSE 0 END) * 100.0 / COUNT(a.Medal)) AS gold_medal_ratio
FROM
    athlete_events AS a
JOIN
    noc_regions AS b ON a.NOC = b.NOC
WHERE
    a.Medal IS NOT NULL
GROUP BY
    b.region
ORDER BY
    gold_medal_ratio DESC
LIMIT 1;


--medals won by a selected country
SELECT
    Medal,
    COUNT(*) AS medal_count
FROM
    athlete_events AS a
JOIN
    noc_regions AS b ON a.NOC = b.NOC
WHERE
    b.region = 'USA' AND a.Medal IS NOT NULL
GROUP BY
    Medal
ORDER BY
    CASE Medal
        WHEN 'Gold' THEN 1
        WHEN 'Silver' THEN 2
        WHEN 'Bronze' THEN 3
    END;


-- athletes who participated in more than one sport
SELECT
    Name_ AS athlete,
    COUNT(DISTINCT Sport) AS number_of_sports
FROM
    athlete_events
GROUP BY
    Name_
HAVING
    COUNT(DISTINCT Sport) > 1
ORDER BY
    number_of_sports DESC;


--most successful athlete from each country
WITH AthleteMedalCounts AS (
    SELECT
        a.Name_ AS athlete,
        b.region AS country,
        COUNT(a.Medal) AS total_medals,
        RANK() OVER(PARTITION BY b.region ORDER BY COUNT(a.Medal) DESC) as rank_num
    FROM
        athlete_events AS a
    JOIN
        noc_regions AS b ON a.NOC = b.NOC
    WHERE
        a.Medal IS NOT NULL
    GROUP BY
        b.region, a.Name_
)
SELECT
    country,
    athlete,
    total_medals
FROM
    AthleteMedalCounts
WHERE
    rank_num = 1
ORDER BY
    country;


-- top 5 most popular events
SELECT
    Events,
    COUNT(DISTINCT Name_) AS number_of_athletes
FROM
    athlete_events
GROUP BY
    Events
ORDER BY
    number_of_athletes DESC
LIMIT 5;


--medals won by each noc
SELECT
    b.region,
    b.NOC,
    COUNT(a.Medal) AS total_medals
FROM
    athlete_events AS a
JOIN
    noc_regions AS b ON a.NOC = b.NOC
WHERE
    a.Medal IS NOT NULL
GROUP BY
    b.region, b.NOC
ORDER BY
    total_medals DESC;


--participated but no medal
SELECT DISTINCT
    b.region
FROM
    noc_regions  as b
JOIN
    athlete_events as a ON b.NOC = a.NOC
WHERE
    b.region NOT IN (
        SELECT DISTINCT b.region
        FROM athlete_events a
        JOIN noc_regions b ON a.NOC = b.NOC
        WHERE a.Medal IS NOT NULL
    )
ORDER BY
    b.region;













































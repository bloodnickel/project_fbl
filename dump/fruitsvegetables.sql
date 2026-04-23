USE projectSQL;

 -- # VISUAL CHECK
SELECT * FROM fruitsvegs;

 -- # Create table to show average value of fruits and vegs with countries as columns and years as rows.
CREATE TABLE produce_pricesbycountry AS
SELECT
    year,
    MAX(CASE WHEN country_name = 'Germany'  THEN avg_value_fruits_vegs END) AS Germany,
    MAX(CASE WHEN country_name = 'Greece'  THEN avg_value_fruits_vegs END) AS Greece,
    MAX(CASE WHEN country_name = 'Hungary'   THEN avg_value_fruits_vegs END) AS Hungary,
    MAX(CASE WHEN country_name = 'Spain'    THEN avg_value_fruits_vegs END) AS Spain,
    MAX(CASE WHEN country_name = 'Netherlands'    THEN avg_value_fruits_vegs END) AS Netherlands,
    MAX(CASE WHEN country_name = 'Romania' THEN avg_value_fruits_vegs END) AS Romania
FROM fruitsvegs
WHERE country_name IN ('Germany', 'Greece', 'Hungary', 'Spain', 'Netherlands', 'Romania')
GROUP BY year
ORDER BY year;


-- Check which countries has the highest and the lowest inflation of each year.
WITH prices AS (
    SELECT
        year,
        Germany, Greece, Hungary, Spain, Netherlands, Romania,
        GREATEST(Germany, Greece, Hungary, Spain, Netherlands, Romania) AS highest_index,
        LEAST(Germany, Greece, Hungary, Spain, Netherlands, Romania)    AS lowest_index
    FROM produce_pricesbycountry
)
SELECT
    year,
    Germany, Greece, Hungary, Spain, Netherlands, Romania,
    highest_index,
    CASE
        WHEN Germany     = highest_index THEN 'Germany'
        WHEN Greece      = highest_index THEN 'Greece'
        WHEN Hungary     = highest_index THEN 'Hungary'
        WHEN Spain       = highest_index THEN 'Spain'
        WHEN Netherlands = highest_index THEN 'Netherlands'
        WHEN Romania     = highest_index THEN 'Romania'
    END AS highest_inflation_country,
    lowest_index,
    CASE
        WHEN Germany     = lowest_index THEN 'Germany'
        WHEN Greece      = lowest_index THEN 'Greece'
        WHEN Hungary     = lowest_index THEN 'Hungary'
        WHEN Spain       = lowest_index THEN 'Spain'
        WHEN Netherlands = lowest_index THEN 'Netherlands'
        WHEN Romania     = lowest_index THEN 'Romania'
    END AS lowest_inflation_country
FROM prices
ORDER BY year;

 -- Cumulative Inflation per country (2015-2025)
SELECT
    ROUND(last.Germany     - first.Germany,     1) AS Germany_cumulative_pct,
    ROUND(last.Greece      - first.Greece,      1) AS Greece_cumulative_pct,
    ROUND(last.Hungary     - first.Hungary,     1) AS Hungary_cumulative_pct,
    ROUND(last.Spain       - first.Spain,       1) AS Spain_cumulative_pct,
    ROUND(last.Netherlands - first.Netherlands, 1) AS Netherlands_cumulative_pct,
    ROUND(last.Romania     - first.Romania,     1) AS Romania_cumulative_pct
FROM
    (SELECT * FROM produce_pricesbycountry WHERE year = 2015) AS first,
    (SELECT * FROM produce_pricesbycountry WHERE year = (SELECT MAX(year) FROM produce_pricesbycountry)) AS last;
    

 -- Year-over-year change per country
 SELECT
    curr.year,
    ROUND(curr.Germany     - prev.Germany,     1) AS Germany_yoy,
    ROUND(curr.Greece      - prev.Greece,      1) AS Greece_yoy,
    ROUND(curr.Hungary     - prev.Hungary,     1) AS Hungary_yoy,
    ROUND(curr.Spain       - prev.Spain,       1) AS Spain_yoy,
    ROUND(curr.Netherlands - prev.Netherlands, 1) AS Netherlands_yoy,
    ROUND(curr.Romania     - prev.Romania,     1) AS Romania_yoy
FROM produce_pricesbycountry curr
JOIN produce_pricesbycountry prev ON curr.year = prev.year + 1
ORDER BY curr.year;


 -- # Whats the fruits and vegetables inflation relation with quality of life index?
SELECT
    'Germany' AS country,
    ROUND(p_last.Germany - p_first.Germany, 1) AS food_inflation_since_2015,
    ROUND(q_last.Germany - q_first.Germany, 1) AS qol_change_since_2015
FROM
    (SELECT * FROM produce_pricesbycountry WHERE year = 2015) p_first,
    (SELECT * FROM produce_pricesbycountry WHERE year = (SELECT MAX(year) FROM produce_pricesbycountry)) p_last,
    (SELECT * FROM quality_of_life_indexf WHERE year = 2015) q_first,
    (SELECT * FROM quality_of_life_indexf WHERE year = (SELECT MAX(year) FROM quality_of_life_indexf)) q_last

UNION ALL

SELECT 'Greece',
    ROUND(p_last.Greece - p_first.Greece, 1),
    ROUND(q_last.Greece - q_first.Greece, 1)
FROM
    (SELECT * FROM produce_pricesbycountry WHERE year = 2015) p_first,
    (SELECT * FROM produce_pricesbycountry WHERE year = (SELECT MAX(year) FROM produce_pricesbycountry)) p_last,
    (SELECT * FROM quality_of_life_indexf WHERE year = 2015) q_first,
    (SELECT * FROM quality_of_life_indexf WHERE year = (SELECT MAX(year) FROM quality_of_life_indexf)) q_last

UNION ALL

SELECT 'Hungary',
    ROUND(p_last.Hungary - p_first.Hungary, 1),
    ROUND(q_last.Hungary - q_first.Hungary, 1)
FROM
    (SELECT * FROM produce_pricesbycountry WHERE year = 2015) p_first,
    (SELECT * FROM produce_pricesbycountry WHERE year = (SELECT MAX(year) FROM produce_pricesbycountry)) p_last,
    (SELECT * FROM quality_of_life_indexf WHERE year = 2015) q_first,
    (SELECT * FROM quality_of_life_indexf WHERE year = (SELECT MAX(year) FROM quality_of_life_indexf)) q_last

UNION ALL

SELECT 'Spain',
    ROUND(p_last.Spain - p_first.Spain, 1),
    ROUND(q_last.Spain - q_first.Spain, 1)
FROM
    (SELECT * FROM produce_pricesbycountry WHERE year = 2015) p_first,
    (SELECT * FROM produce_pricesbycountry WHERE year = (SELECT MAX(year) FROM produce_pricesbycountry)) p_last,
    (SELECT * FROM quality_of_life_indexf WHERE year = 2015) q_first,
    (SELECT * FROM quality_of_life_indexf WHERE year = (SELECT MAX(year) FROM quality_of_life_indexf)) q_last

UNION ALL

SELECT 'Netherlands',
    ROUND(p_last.Netherlands - p_first.Netherlands, 1),
    ROUND(q_last.Netherlands - q_first.Netherlands, 1)
FROM
    (SELECT * FROM produce_pricesbycountry WHERE year = 2015) p_first,
    (SELECT * FROM produce_pricesbycountry WHERE year = (SELECT MAX(year) FROM produce_pricesbycountry)) p_last,
    (SELECT * FROM quality_of_life_indexf WHERE year = 2015) q_first,
    (SELECT * FROM quality_of_life_indexf WHERE year = (SELECT MAX(year) FROM quality_of_life_indexf)) q_last

UNION ALL

SELECT 'Romania',
    ROUND(p_last.Romania - p_first.Romania, 1),
    ROUND(q_last.Romania - q_first.Romania, 1)
FROM
    (SELECT * FROM produce_pricesbycountry WHERE year = 2015) p_first,
    (SELECT * FROM produce_pricesbycountry WHERE year = (SELECT MAX(year) FROM produce_pricesbycountry)) p_last,
    (SELECT * FROM quality_of_life_indexf WHERE year = 2015) q_first,
    (SELECT * FROM quality_of_life_indexf WHERE year = (SELECT MAX(year) FROM quality_of_life_indexf)) q_last

ORDER BY food_inflation_since_2015 DESC;
    
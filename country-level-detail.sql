/*
Success stories: Which 2 countries saw the largest amount increase
in forest area from 1990 to 2016?
*/
WITH table1 AS
   (SELECT country_name,
    SUM(forest_area_sqkm) AS forest_area_1
    FROM forestation
    WHERE year = 1990
    GROUP BY country_name, forest_area_sqkm),
 table2 AS
   (SELECT country_name,
    SUM(forest_area_sqkm) AS forest_area_2
    FROM forestation
    WHERE year = 2016
    GROUP BY country_name, forest_area_sqkm)
SELECT t1.country_name,
              (t1.forest_area_1 - t2.forest_area_2) AS forest_change
FROM table1AS t1
JOIN table2 AS t2
ON t1.country_name = t2.country_name
ORDER BY forest_change
LIMIT 2;

/*
Success stories: Which country saw the largest percent change increase
in forest area from 1990 to 2016?
*/
WITH table1 AS
   (SELECT country_name,
                  (SUM(forest_area_sqkm)/SUM(total_area_sq_mi*2.59))*100 AS
                  percent_forestation_1
    FROM forestation
    WHERE year = 1990
    GROUP BY country_name, forest_area_sqkm),
 table2 AS
   (SELECT country_name,
                  (SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100 AS
                  percent_forestation_2
    FROM forestation
    WHERE year = 2016
    GROUP BY country_name, forest_area_sqkm)
SELECT t1.country_name,
              Round((((t1.percent_forestation_1 -
              t2.percent_forestation_2)/(t1.percent_forestation_1))*100)::Numeric, 2) AS
              perc_change
FROM table1 AS t1
JOIN table2 AS t2
ON t1.country_name = t2.country_name
ORDER BY perc_change
LIMIT 1;

/*
Which 5 countries saw the largest amount decrease in forest area
from 1990 to 2016? What was the difference in forest area for each?
*/
WITH table1 AS
   (SELECT country_name,
	      region,
                  SUM(forest_area_sqkm) AS forest_area_1
    FROM forestation
    WHERE year = 1990
    GROUP BY country_name, forest_area_sqkm, region),
 table2 AS
   (SELECT country_name,
                  region,
                   SUM(forest_area_sqkm) AS forest_area_2
    FROM forestation
    WHERE year = 2016
    GROUP BY country_name, forest_area_sqkm, region)
SELECT t1.country_name,
             t1.region,
             (t1.forest_area_1 - t2.forest_area_2) AS forest_change
FROM table1 AS t1
JOIN table2 AS t2
ON t1.country_name = t2.country_name
WHERE t1.forest_area_1 IS NOT NULL
AND t2.forest_area_2 IS NOT NULL
AND t1.country_name != 'World'
ORDER BY forest_change DESC
LIMIT 5;

/*
Which 5 countries saw the largest percent decrease in forest area
from 1990 to 2016? What was the percent change to 2 decimal places for each?
*/
WITH table1 AS
   (SELECT country_name,
	       region,
                  (SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100 AS
                  percent_forestation_1
    FROM forestation
    WHERE year = 1990
    GROUP BY country_name, forest_area_sqkm, region),
 table2 AS
   (SELECT country_name,
                  region,
                  (SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100 AS
                  percent_forestation_2
    FROM forestation
    WHERE year = 2016
    GROUP BY country_name, forest_area_sqkm, region)
SELECT t1.country_name,
              t1.region,
              Round((((t1.percent_forestation_1-
              t2.percent_forestation_2)/(t1.percent_forestation_1))*100)::Numeric, 2) AS
              perc_change
FROM table1 AS t1
JOIN table2 AS t2
ON t1.country_name = t2.country_name
WHERE t1.percent_forestation_1 IS NOT NULL
AND t2.percent_forestation_2 IS NOT NULL
AND t1.country_name != 'World'
ORDER BY perc_change DESC
LIMIT 5;

/*
If countries were grouped by percent forestation in quartiles, which
group had the most countries in it in 2016?
*/
WITH table1 AS
  (SELECT country_name,
                  year,
                  (SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100 AS
                  percent_forestation
 FROM forestation
 WHERE year = 2016
 GROUP BY country_name, year, forest_area_sqkm)
SELECT DISTINCT(quartiles),
              COUNT(country_name) OVER(PARTITION BY quartiles)
FROM
 (SELECT country_name,
 CASE
 WHEN percent_forestation<25 THEN '0-25 (Q1)'
 WHEN percent_forestation>=25 AND percent_forestation<50 THEN '25-50 (Q2)'
 WHEN percent_forestation>=50 AND percent_forestation<75 THEN '50-75 (Q3)'
 ELSE '75-100 (Q4)'
 END AS quartiles
 FROM table1
 WHERE percent_forestation IS NOT NULL
 AND year = 2016) sub

/*
List all of the countries that were in the 4th quartile
(percent forest > 75%) in 2016.
*/
WITH table2 AS
   (WITH table1 AS
     (SELECT country_name,
                    year,
                    region,
                    (SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100 AS
                    perc_forestation
      FROM forestation
      WHERE year = 2016
      GROUP BY country_name, year, forest_area_sqkm, region)
   SELECT DISTINCT(quartiles),
                 COUNT(country_name)OVER(PARTITION BY quartiles),
                 country_name,
                 region,
                perc_forestation
 FROM
     (SELECT country_name,
                     region,
                     perc_forestation,
      CASE
      WHEN perc_forestation<=25 THEN '0-25 (Q1)'
      WHEN perc_forestation>25 AND perc_forestation<=50 THEN '25-50 (Q2)'
      WHEN perc_forestation>50 AND perc_forestation<=75 THEN '50-75 (Q3)'
      ELSE '75-100 (Q4)'
      END AS quartiles
      FROM table1
      WHERE perc_forestation IS NOT NULL
      AND year = 2016) sub)
SELECT country_name,
              region,
              Round(perc_forestation::Numeric, 2) AS perc_forestation
FROM table2
WHERE quartiles = '75-100 (Q4)'
ORDER BY perc_forestation DESC;

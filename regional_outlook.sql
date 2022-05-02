/*
What was the percent forest of the entire world in 2016?
*/
SELECT country_name,
              ((Sum(forest_area_sqkm) / Sum(total_area_sq_mi*2.59))*100) AS
              perc_forest
FROM forestation
WHERE country_name = 'World'
AND year = 2016
GROUP BY country_name;

/*
Which region had the HIGHEST percent forest in 2016, and which had
the LOWEST, to 2 decimal places?
*/
SELECT region,
              Round(((Sum(forest_area_sqkm) /
              Sum(total_area_sq_mi*2.59))*100)::Numeric, 2) AS perc_forest
FROM forestation
WHERE year = 2016
GROUP BY region
ORDER BY perc_forest DESC
LIMIT 1;

SELECT region,
              Round(((Sum(forest_area_sqkm) /
              Sum(total_area_sq_mi*2.59))*100)::Numeric, 2) AS perc_forest
FROM forestation
WHERE year = 2016
GROUP BY region
ORDER BY perc_forest
LIMIT 1;

/*
What was the percent forest of the entire world in 1990?
*/
SELECT country_name,
              ((Sum(forest_area_sqkm) / Sum(total_area_sq_mi*2.59))*100) AS
              perc_forest
FROM forestation
WHERE country_name = 'World'
AND year = 1990
GROUP BY country_name;

/*
Which region had the HIGHEST percent forest in 1990, and which had
the LOWEST, to 2 decimal places?
*/
SELECT region,
              Round(((Sum(forest_area_sqkm) /
              Sum(total_area_sq_mi*2.59))*100)::Numeric, 2) AS perc_forest
FROM forestation
WHERE year = 1990
GROUP BY region
ORDER BY perc_forest DESC
LIMIT 1;

SELECT region,
              Round(((Sum(forest_area_sqkm) /
              Sum(total_area_sq_mi*2.59))*100)::Numeric, 2) AS perc_forest
FROM forestation
WHERE year = 1990
GROUP BY region
ORDER BY perc_forest
LIMIT 1;

/*
Based on the table you created, which regions of the world DECREASED
in forest area from 1990 to 2016?
*/
SELECT region,
              Round(((Sum(forest_area_sqkm) /
              Sum(total_area_sq_mi*2.59))*100)::Numeric, 2) AS perc_forest
FROM forestation
WHERE year = 1990
GROUP BY region
ORDER BY region;

SELECT region,
              Round(((Sum(forest_area_sqkm) /
              Sum(total_area_sq_mi*2.59))*100)::Numeric, 2) AS perc_forest
FROM forestation
WHERE year = 2016
GROUP BY region
ORDER BY region;

/*
What was the total forest area (in sq km) of the world in 1990?
Please keep in mind that you can use the country record denoted as
“World" in the region table.
*/

SELECT country_name, year, forest_area_sqkm
FROM forestation
WHERE country_name = 'World' AND year = 1990;

/*
What was the total forest area (in sq km) of the world in 2016?
Please keep in mind that you can use the country record in the table is
denoted as “World.”
*/

SELECT country_name, year, forest_area_sqkm
FROM forestation
WHERE country_name = 'World' AND year = 2016;

/*
What was the change (in sq km) in the forest area of the world from 1990 to 2016?
*/

SELECT (
    (SELECT forest_area_sqkm
     FROM forestation
     WHERE country_name = 'World'
     AND year = 1990) -
   (SELECT forest_area_sqkm
    FROM forestation
    WHERE country_name = 'World'
    AND year = 2016)) AS diff
FROM forestation;

/*
What was the percent change in forest area of the world between 1990 and 2016?
*/

SELECT (((
    (SELECT forest_area_sqkm
      FROM forestation
      WHERE country_name = 'World'
      AND year=1990) -
    (SELECT forest_area_sqkm
      FROM forestation
      WHERE country_name = 'World'
      AND year=2016)) / (
    (SELECT forest_area_sqkm
      FROM forestation
      WHERE country_name = 'World'
      AND year=1990))) *100) AS perc_dicrease
FROM forestation;

/*
If you compare the amount of forest area lost between 1990 and 2016,
to which country's total area in 2016 is it closest to?
*/

SELECT country_name,
	   year,
              total_area_sqkm
FROM forestation
WHERE year = 2016
AND total_area_sqkm <= 1324449
ORDER BY total_area_sqkm DESC
LIMIT 1;

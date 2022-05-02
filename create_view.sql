CREATE VIEW forestation
AS
SELECT fa.*,
       la.total_area_sq_mi * 2.59 AS total_area_sqkm,
       reg.region,
       reg.income_group,
       (fa.forest_area_sqkm / (la.total_area_sq_mi * 2.59)) AS perc_forested_area_sqkm
FROM forest_area AS fa
JOIN land_area AS la
ON fa.country_code=la.country_code AND fa.year=la.year
JOIN regions AS reg
ON la.country_code=reg.country_code;

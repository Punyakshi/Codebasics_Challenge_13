-- Q1.  Identify the top 3 and bottom 3 cities by total trips over the entire analysis period.

(SELECT "Top Performing City" AS Performance ,city_name,COUNT(trip_id) AS Total_Trips 
FROM fact_trips ft 
JOIN dim_city dc ON ft.city_id = dc.city_id
GROUP BY city_name
ORDER BY Total_Trips DESC
LIMIT 3)
UNION
(SELECT "Bottom Performing City" AS Performance ,city_name,COUNT(trip_id) AS Total_Trips 
FROM fact_trips ft 
JOIN dim_city dc ON ft.city_id = dc.city_id
GROUP BY city_name
ORDER BY Total_Trips ASC
LIMIT 3);
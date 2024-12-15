-- Q2. Calculate the average fare per trip for each city and compare it with the city's average trip distance. Identify the cities with the highest and lowest average fare per trip to assess pricing efficiency across locations.

SELECT city_name,ROUND(SUM(fare_amount)/COUNT(trip_id),0) AS Avg_Fare , ROUND(SUM(distance_travelled_km)/COUNT(trip_id),0) AS Avg_Trip_Distance
FROM fact_trips ft
JOIN dim_city dc ON ft.city_id = dc.city_id
GROUP BY city_name
ORDER BY Avg_Fare DESC;

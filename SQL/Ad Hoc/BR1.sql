-- BR 1. City Level Fare and Trip Summary Report. 

SELECT city_name, COUNT(trip_id) AS Total_Trips ,
ROUND(SUM(fare_amount)/ SUM(distance_travelled_km),0) AS Avg_Fare_Per_Km,
ROUND(SUM(fare_amount)/ COUNT(trip_id),0) AS Avg_Fare_Per_Trip,
CONCAT(ROUND(COUNT(trip_id)/(SELECT COUNT(trip_id) AS Total_Trips FROM fact_trips) *100,2),'%') AS Contribution_To_Total_Trips
FROM fact_trips ft
JOIN dim_city dc ON ft.city_id = dc.city_id
GROUP BY city_name
ORDER BY COUNT(trip_id) DESC; 

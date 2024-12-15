-- Q6. Analyze the frequency of trips taken by repeat passengers in each city (eg % of repeat passengers taking 2-trips, 3-trips, etc.).

WITH Repeat_Pass AS (
SELECT city_name,trip_count,SUM(repeat_passenger_count) AS Repeat_Passenger
FROM dim_repeat_trip_distribution drtd
JOIN dim_city dc ON drtd.city_id = dc.city_id
JOIN fact_passenger_summary fps ON (drtd.city_id=fps.city_id AND drtd.month = fps.month)
GROUP BY city_name ,trip_count),
Total_Pass AS (
SELECT city_name,SUM(repeat_passengers) AS Total_Repeat_Passenger
FROM dim_city dc
JOIN fact_passenger_summary fps ON dc.city_id=fps.city_id
GROUP BY city_name)
SELECT rp.city_name,rp.trip_count,rp.Repeat_Passenger,Total_Repeat_Passenger,
CONCAT(ROUND(Repeat_Passenger/Total_Repeat_Passenger *100,2),'%') AS RPR
-- RANK() OVER(PARTITION BY rp.trip_count ORDER BY Repeat_Passenger/Total_Repeat_Passenger *100 DESC) AS Rankings
FROM Repeat_Pass rp 
JOIN Total_Pass tp 
ON rp.city_name = tp.city_name
ORDER BY rp.trip_count 


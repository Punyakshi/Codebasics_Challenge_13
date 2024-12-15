
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

SELECT rp.city_name,
MAX(CASE WHEN rp.trip_count = '2-Trips' THEN CONCAT(ROUND(Repeat_Passenger/Total_Repeat_Passenger *100,2),'%') END) AS 2_Trips,
MAX(CASE WHEN rp.trip_count = '3-Trips' THEN CONCAT(ROUND(Repeat_Passenger/Total_Repeat_Passenger *100,2),'%') END) AS 3_Trips,
MAX(CASE WHEN rp.trip_count = '4-Trips' THEN CONCAT(ROUND(Repeat_Passenger/Total_Repeat_Passenger *100,2),'%') END) AS 4_Trips,
MAX(CASE WHEN rp.trip_count = '5-Trips' THEN CONCAT(ROUND(Repeat_Passenger/Total_Repeat_Passenger *100,2),'%') END) AS 5_Trips,
MAX(CASE WHEN rp.trip_count = '6-Trips' THEN CONCAT(ROUND(Repeat_Passenger/Total_Repeat_Passenger *100,2),'%') END) AS 6_Trips,
MAX(CASE WHEN rp.trip_count = '7-Trips' THEN CONCAT(ROUND(Repeat_Passenger/Total_Repeat_Passenger *100,2),'%') END) AS 7_Trips,
MAX(CASE WHEN rp.trip_count = '8-Trips' THEN CONCAT(ROUND(Repeat_Passenger/Total_Repeat_Passenger *100,2),'%') END) AS 8_Trips,
MAX(CASE WHEN rp.trip_count = '9-Trips' THEN CONCAT(ROUND(Repeat_Passenger/Total_Repeat_Passenger *100,2),'%') END) AS 9_Trips,
MAX(CASE WHEN rp.trip_count = '10-Trips' THEN CONCAT(ROUND(Repeat_Passenger/Total_Repeat_Passenger *100,2),'%') END) AS 10_Trips
FROM Repeat_Pass rp 
JOIN Total_Pass tp ON rp.city_name = tp.city_name
GROUP BY rp.city_name;



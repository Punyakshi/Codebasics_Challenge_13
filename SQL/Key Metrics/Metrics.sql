SELECT DISTINCT(COUNT(trip_id)) AS Total_Trips FROM fact_trips; -- Total Trips
SELECT SUM(fare_amount) AS Total_Fare FROM fact_trips; -- Total Fare
SELECT CONCAT(SUM(distance_travelled_km)," km") AS Total_Distance_Travelled FROM fact_trips; -- Total Distance Travelled
SELECT AVG(passenger_rating) AS Avg_Pass_Rating,AVG(driver_rating) AS Avg_Driver_Rating FROM fact_trips; -- Average Rating
SELECT SUM(fare_amount)/ COUNT(trip_id) AS Avg_Trip_Cost FROM fact_trips; -- Avg Cost Per Trip
SELECT SUM(fare_amount)/ SUM(distance_travelled_km) AS Avg_Fare_Per_Km FROM fact_trips; -- Avg Fare Per km
SELECT CONCAT(SUM(distance_travelled_km)/COUNT(trip_id)," km") AS Avg_Trip_Dis FROM fact_trips; -- Avg Trip Distance
SELECT MAX(distance_travelled_km),MIN(distance_travelled_km) FROM fact_trips; -- Trip Distance (Max,Min)
SELECT passenger_type,COUNT(trip_id) FROM fact_trips GROUP BY passenger_type; -- New & Repeated Trips
SELECT SUM(total_passengers) FROM fact_passenger_summary;
SELECT SUM(new_passengers) FROM fact_passenger_summary;
SELECT SUM(repeat_passengers) FROM fact_passenger_summary;
SELECT COUNT(CASE WHEN passenger_type="new" THEN trip_id END)/COUNT(CASE WHEN passenger_type="repeated" THEN trip_id END) AS New_Vs_Repeated_Pas_Trip_Ratio FROM fact_trips; -- New_Vs_Repeated_Passenger_Trip_Ratio
SELECT CONCAT(SUM(repeat_passengers)/SUM(total_passengers)*100,"%") AS Repeat_Passenger_Rate FROM fact_passenger_summary; -- Repeat_Passenger_Rate

-- Monthly Revenue Growth Rate
SELECT YEAR(start_of_month),MONTH(start_of_month),
	CONCAT(ROUND((SUM(fare_amount)-LAG(SUM(fare_amount)) OVER( ORDER BY YEAR(start_of_month),MONTH(start_of_month)))/
	LAG(SUM(fare_amount)) OVER( ORDER BY YEAR(start_of_month),MONTH(start_of_month) ) *100,2),"%") AS Monthly_Revenue_Growth_Rate
FROM fact_trips ft JOIN dim_date dd ON ft.date=dd.date group by YEAR(start_of_month),MONTH(start_of_month);

-- Trips Target Achieved
WITH tot_target AS 
(SELECT mtt.city_id,SUM(mtt.total_target_trips) AS total_target
FROM targets_db.monthly_target_trips mtt 
GROUP BY mtt.city_id)

SELECT ft.city_id, CONCAT(ROUND(COUNT(ft.trip_id)/total_target* 100,2),'%') AS Trip_Target_Achieved
FROM fact_trips ft 
JOIN tot_target ON ft.city_id = tot_target.city_id
GROUP BY ft.city_id;

-- New Passenger Target Achieved
WITH tot_target_1 AS 
(SELECT mtnp.city_id,SUM(mtnp.target_new_passengers) AS total_target
FROM targets_db.monthly_target_new_passengers mtnp 
GROUP BY mtnp.city_id)

SELECT ft.city_id, CONCAT(ROUND(COUNT(CASE WHEN ft.passenger_type = "new" THEN ft.trip_id END)/total_target* 100,2),'%') AS New_Pass_Target_Achieved
FROM fact_trips ft 
JOIN tot_target_1 ON ft.city_id = tot_target_1.city_id
GROUP BY ft.city_id;

-- Avg Passenger Rating Target Achieved
SELECT ft.city_id, CONCAT(ROUND(AVG(ft.passenger_rating)/ctpr.target_avg_passenger_rating * 100,2),'%') AS Avg_Pass_Rating_Target_Achieved
FROM fact_trips ft 
JOIN targets_db.city_target_passenger_rating ctpr ON ft.city_id = ctpr.city_id
GROUP BY ft.city_id;




-- Q8. Analyze Reapeat passenger rate (RPR%) for each city across six month period.Identify top 2 and bottom 2 cities based on their RPR% to determine which locations have the strongest and weakest rates.
-- Similarly, analyze the RPR% by month across all cities and identify the months with the highest and lowest repeat passenger rates.

WITH Repeat_Pass AS (
SELECT city_name,SUM(repeat_passengers) AS Total_Repeat_Passenger
-- FROM dim_repeat_trip_distribution drtd
FROM dim_city dc -- ON drtd.city_id = dc.city_id
JOIN fact_passenger_summary fps ON dc.city_id = fps.city_id-- ON (drtd.city_id=fps.city_id AND drtd.month = fps.month)
GROUP BY city_name),
Total_Pass AS (
SELECT city_name,SUM(total_passengers) AS Total_Passenger
FROM dim_city dc
JOIN fact_passenger_summary fps ON dc.city_id=fps.city_id
GROUP BY city_name)

(SELECT "Highest" AS Repeat_Passenger_Rate, rp.city_name,
CONCAT(ROUND(Total_Repeat_Passenger/Total_Passenger *100,2),'%') AS RPR
FROM Repeat_Pass rp 
JOIN Total_Pass tp 
ON rp.city_name = tp.city_name
ORDER BY ROUND(Total_Repeat_Passenger/Total_Passenger *100,2) DESC
LIMIT 2)

UNION

(SELECT "Lowest" AS Repeat_Passenger_Rate, rp.city_name,
CONCAT(ROUND(Total_Repeat_Passenger/Total_Passenger *100,2),'%') AS RPR
FROM Repeat_Pass rp 
JOIN Total_Pass tp 
ON rp.city_name = tp.city_name
ORDER BY ROUND(Total_Repeat_Passenger/Total_Passenger *100,2) ASC
LIMIT 2);





WITH RP_Rate AS (
SELECT MONTH(Month) AS Month_No,MONTHNAME(month)AS Month,city_name,
ROUND(SUM(repeat_passengers)/SUM(total_passengers)*100,2) AS RPR1,
RANK() OVER(PARTITION BY city_name ORDER BY ROUND(SUM(repeat_passengers)/SUM(total_passengers)*100,2)) AS Rankings
FROM dim_city dc
JOIN fact_passenger_summary fps ON dc.city_id=fps.city_id
GROUP BY city_name,MONTH(Month),MONTHNAME(month)
ORDER BY RPR1)

(SELECT rp.city_name,rp.Month, CONCAT(rp.RPR1,'%') AS RPR,"Lowest" AS Repeat_Passenger_Rate
FROM RP_Rate rp 
WHERE Rankings='1')

UNION

(SELECT rp.city_name, rp.Month, CONCAT(rp.RPR1,'%') AS RPR,"Highest" AS Repeat_Passenger_Rate
FROM RP_Rate rp 
WHERE Rankings='6')
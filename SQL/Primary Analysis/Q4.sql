-- Q4. Identify the months with highest total trips (peak demand) and the month with lowest total tripss (low demand)for each city.

WITH Demand_Months AS 
(SELECT city_name,month_name, COUNT(trip_id) AS Total_Trips ,
RANK() OVER(PARTITION BY city_name ORDER BY COUNT(trip_id) DESC) AS Rankings
FROM fact_trips ft
JOIN dim_city dc ON ft.city_id = dc.city_id
JOIN dim_date dd ON ft.date = dd.date
GROUP BY city_name,month_name
ORDER BY Total_Trips DESC)

SELECT city_name,month_name,Total_Trips,'Peak Demand' AS SEASON FROM Demand_Months
WHERE Rankings = (SELECT MIN(Rankings) FROM Demand_Months)

UNION 

SELECT city_name,month_name,Total_Trips,'Low Demand' AS SEASON FROM Demand_Months
WHERE Rankings = (SELECT MAX(Rankings) FROM Demand_Months);

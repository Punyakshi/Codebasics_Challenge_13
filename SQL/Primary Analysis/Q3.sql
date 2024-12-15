-- Q3. Calculate average passenger and driver ratings, segmented by passenger type (new vs. repeat). Identify the cities with highest and lowest average ratings.

WITH Ratings AS 
(SELECT passenger_type,city_name,AVG(passenger_rating) AS Avg_Pass_Rating,AVG(driver_rating) AS Avg_Driver_Rating FROM fact_trips ft 
JOIN dim_city dc ON ft.city_id = dc.city_id
GROUP BY city_name,passenger_type
ORDER BY Avg_Pass_Rating DESC ,Avg_Driver_Rating DESC)

(SELECT 'New' AS passenger_type,'Highest Rated City' AS Rating,city_name,Avg_Pass_Rating,Avg_Driver_Rating FROM Ratings
WHERE passenger_type='new'
ORDER BY Avg_Pass_Rating DESC ,Avg_Driver_Rating DESC
LIMIT 1)
UNION
(SELECT 'New' AS passenger_type,'Lowest Rated City' AS Rating,city_name,Avg_Pass_Rating,Avg_Driver_Rating FROM Ratings
WHERE passenger_type='new'
ORDER BY Avg_Pass_Rating ASC ,Avg_Driver_Rating ASC
LIMIT 1)
UNION 
(SELECT 'Repeat' AS passenger_type,'Highest Rated City' AS Rating,city_name,Avg_Pass_Rating,Avg_Driver_Rating FROM Ratings
WHERE passenger_type='repeated'
ORDER BY Avg_Pass_Rating DESC ,Avg_Driver_Rating DESC
LIMIT 1)
UNION
(SELECT 'Repeat' AS passenger_type,'Lowest Rated City' AS Rating,city_name,Avg_Pass_Rating,Avg_Driver_Rating FROM Ratings
WHERE passenger_type='repeated'
ORDER BY Avg_Pass_Rating ASC ,Avg_Driver_Rating ASC
LIMIT 1)


WITH New_Pass AS 
(SELECT city_name,SUM(new_passengers) AS total_new_passengers,
RANK() OVER(ORDER BY SUM(new_passengers) DESC) AS Ranking
FROM fact_passenger_summary fps
JOIN dim_city dc ON fps.city_id = dc.city_id
GROUP BY city_name)

SELECT city_name,total_new_passengers,
CASE WHEN Ranking<=3 THEN 'Top 3' 
	WHEN Ranking>=8 THEN 'Bottom 3'
END AS City_Category 
FROM New_Pass
GROUP BY city_name
HAVING City_Category IS NOT NULL;



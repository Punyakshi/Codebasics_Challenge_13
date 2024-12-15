-- Q5. Compare total trips taken on weekdays versus weekends for each city over the six months period.

SELECT city_name,
COUNT(CASE WHEN day_type='Weekday' THEN trip_id END) AS Total_Trips_Weekday,
COUNT(CASE WHEN day_type='Weekend' THEN trip_id END) AS Total_Trips_Weekend
FROM fact_trips ft
JOIN dim_city dc ON ft.city_id = dc.city_id
JOIN dim_date dd ON ft.date = dd.date
GROUP BY city_name
ORDER BY Total_Trips_Weekend DESC,Total_Trips_Weekday DESC;

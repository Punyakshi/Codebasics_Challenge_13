WITH Total_Revenue AS 
(SELECT city_name,SUM(fare_amount) AS Revenue
FROM fact_trips ft JOIN dim_city dc ON ft.city_id=dc.city_id 
GROUP BY city_name),

Revenue_Summary AS 
(SELECT tr.city_name,MONTHNAME(start_of_month) AS Month,
	SUM(fare_amount) AS Monthly_Revenue,
    RANK() OVER(PARTITION BY city_name ORDER BY SUM(fare_amount) DESC) AS Ranking,
    ROUND(SUM(fare_amount)/Revenue*100,2) AS percent_contribution
FROM fact_trips ft 
JOIN dim_date dd ON ft.date=dd.date 
JOIN dim_city dc ON ft.city_id=dc.city_id
JOIN Total_Revenue tr ON tr.city_name = dc.city_name
GROUP BY city_name,MONTHNAME(start_of_month))

SELECT city_name,Month AS Highest_Revenue_Month ,Monthly_Revenue,CONCAT(percent_contribution,'%')
FROM Revenue_Summary rs
WHERE Ranking = 1 ;

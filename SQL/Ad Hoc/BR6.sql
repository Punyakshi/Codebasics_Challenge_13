WITH City_RP_R AS (
SELECT fps.city_id,city_name,SUM(total_passengers) AS Total_Pass,SUM(repeat_passengers) AS Repeat_Pass,
CONCAT(ROUND(SUM(repeat_passengers)/SUM(total_passengers)*100,2),'%') AS City_RPR
FROM dim_city dc
JOIN fact_passenger_summary fps ON dc.city_id=fps.city_id
GROUP BY fps.city_id,city_name)

SELECT cpr.city_name,MONTHNAME(month)AS Month,SUM(fps.total_passengers) AS Total_Passengers,SUM(fps.repeat_passengers) AS Repeat_Passengers,
CONCAT(ROUND(SUM(repeat_passengers)/SUM(total_passengers)*100,2),'%') AS Monthly_RPR,
CONCAT(ROUND(SUM(Repeat_Pass)/SUM(Total_Pass)*100,2),'%') AS City_RPR
FROM dim_city dc
JOIN fact_passenger_summary fps ON dc.city_id=fps.city_id
JOIN City_RP_R cpr ON cpr.city_id = fps.city_id
GROUP BY city_name,MONTHNAME(month);
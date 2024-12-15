WITH tot_target AS 
(SELECT mtt.city_id,city_name,MONTH(mtt.month) AS Month_No,MONTHNAME(mtt.month) AS Month_Name,SUM(mtt.total_target_trips) AS total_target
FROM targets_db.monthly_target_trips mtt 
JOIN dim_city dc ON mtt.city_id = dc.city_id
GROUP BY mtt.city_id,city_name,MONTH(mtt.month),MONTHNAME(mtt.month)),
target_achieved AS 
(SELECT ft.city_id, MONTH(ft.date) AS Month_No, MONTHNAME(ft.date) AS Month_Name,COUNT(ft.trip_id) AS Trip_Target_Achieved
FROM fact_trips ft 
GROUP BY ft.city_id,MONTH(ft.date),MONTHNAME(ft.date))

SELECT tt.city_name,tt.Month_Name,Trip_Target_Achieved AS Actual_Trips, total_target AS Target_Trips,
-- CONCAT(ROUND(Trip_Target_Achieved/total_target*100,2),'%') AS Achieved_Target,
CASE WHEN ROUND(Trip_Target_Achieved/total_target*100,2)>'100' THEN 'Above Target'
	WHEN ROUND(Trip_Target_Achieved/total_target*100,2)<='100' THEN 'Below Target'
END AS Performance_Status,
CASE WHEN ROUND(Trip_Target_Achieved/total_target*100,2)<='100' THEN CONCAT(ROUND((total_target-Trip_Target_Achieved)/total_target*100,2),'%')
	 WHEN ROUND(Trip_Target_Achieved/total_target*100,2)>'100' THEN 'Target_Achieved'
END AS Performance_gap
FROM tot_target tt
JOIN target_achieved ta ON (tt.city_id=ta.city_id AND tt.Month_No=ta.Month_No)
ORDER BY tt.city_name,tt.Month_No;


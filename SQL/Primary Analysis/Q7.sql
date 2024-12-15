-- Q7. For each city, evaluate monthly performance against targets for total trips,new passengers and average passenger ratings. Determine if each metric met, exceeded or missed the target, and calculate the percentage differnece.

-- Trip Target Achieved
WITH tot_target AS 
(SELECT mtt.city_id,MONTH(mtt.month) AS Month_No,SUM(mtt.total_target_trips) AS total_target
FROM targets_db.monthly_target_trips mtt 
GROUP BY mtt.city_id,MONTH(mtt.month)),
target_achieved AS 
(SELECT ft.city_id, MONTH(ft.date) AS Month_No, COUNT(ft.trip_id) AS Trip_Target_Achieved
FROM fact_trips ft 
GROUP BY ft.city_id,MONTH(ft.date))

SELECT tt.city_id,tt.Month_No, CONCAT(ROUND(Trip_Target_Achieved/total_target*100,2),'%') AS Achieved_Target,
CASE WHEN ROUND(Trip_Target_Achieved/total_target*100,2)>'100' THEN 'Target_Exceeded'
	WHEN ROUND(Trip_Target_Achieved/total_target*100,2)<'100' THEN 'Target_Missed'
    ELSE'Target_Met'
END AS Target_Status
FROM tot_target tt
JOIN target_achieved ta ON (tt.city_id=ta.city_id AND tt.Month_No=ta.Month_No)
ORDER BY tt.city_id,tt.Month_No;

-- New Passenger Target Achieved
WITH tot_target AS 
	(SELECT mtnp.city_id,MONTH(mtnp.month) AS Month_No,SUM(mtnp.target_new_passengers) AS total_target
	FROM targets_db.monthly_target_new_passengers mtnp 
	GROUP BY mtnp.city_id,MONTH(mtnp.month)),
target_achieved AS
	(SELECT ft.city_id, MONTH(ft.date) AS Month_No, 
	COUNT(CASE WHEN ft.passenger_type = "new" THEN ft.trip_id END) AS New_Pass_Target_Achieved
	FROM fact_trips ft 
	GROUP BY ft.city_id,MONTH(ft.date))
    
SELECT tt.city_id,tt.Month_No,New_Pass_Target_Achieved,total_target,CONCAT(ROUND(New_Pass_Target_Achieved/total_target*100,2),'%') AS Achieved_Target,
CASE WHEN ROUND(New_Pass_Target_Achieved/total_target*100,2)>'100' THEN 'Target_Exceeded'
	WHEN ROUND(New_Pass_Target_Achieved/total_target*100,2)<'100' THEN 'Target_Missed'
    ELSE'Target_Met'
END AS Target_Status
FROM tot_target tt JOIN target_achieved ta ON (tt.city_id = ta.city_id AND tt.Month_No = ta.Month_No)
ORDER BY tt.city_id,tt.Month_No;


-- Avg Passenger Rating Target Achieved

SELECT ft.city_id, MONTH(ft.date) AS Month_No, CONCAT(ROUND(AVG(ft.passenger_rating)/ctpr.target_avg_passenger_rating * 100,2),'%') AS Avg_Pass_Rating_Achieved,
CASE WHEN ROUND(AVG(ft.passenger_rating)/ctpr.target_avg_passenger_rating*100,2)>'100' THEN 'Target_Exceeded'
	WHEN ROUND(AVG(ft.passenger_rating)/ctpr.target_avg_passenger_rating*100,2)<'100' THEN 'Target_Missed'
    ELSE'Target_Met'
END AS Target_Status
FROM fact_trips ft 
JOIN targets_db.city_target_passenger_rating ctpr ON ft.city_id = ctpr.city_id
GROUP BY ft.city_id, MONTH(ft.date);



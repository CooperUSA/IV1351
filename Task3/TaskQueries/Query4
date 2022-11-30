--Lists all ensembles held during the next week, sorted by music genre and weekday. 

SELECT 
    nextweek.booking_date, 
    genre, 
    CASE WHEN poses.available_positions = 0 THEN 'FULL' 
        WHEN poses.available_positions = 1 OR poses.available_positions = 2 THEN '1-2 Positions remain'
        ELSE '2 or more positoins remain'
        END AS slots
FROM ensemble
LEFT JOIN 
    (SELECT booking_id, available_positions FROM group_lesson) 
    AS poses ON poses.booking_id = group_lesson_id
LEFT JOIN  
    (SELECT id, booking_date, EXTRACT(isodow FROM booking_date) as weekday_num FROM booking) 
    AS nextweek ON nextweek.id = group_lesson_id
WHERE (EXTRACT(week FROM CURRENT_DATE) + 1) = EXTRACT(week FROM nextweek.booking_date)
ORDER BY genre, nextweek.weekday_num ASC;

-- Shows the number of lessons given per month during a specified year (This case 2022).

SELECT 
    EXTRACT(MONTH FROM booking.booking_date) AS month, 
    COUNT(*) AS all_lessons, 
    SUM(CASE WHEN group_lesson_id IS NULL AND booking_id IS NULL THEN 1 ELSE 0 END) AS singlelessons, 
    SUM(CASE WHEN group_lesson_id IS NULL AND booking_id IS NOT NULL THEN 1 ELSE 0 END) AS grouplessons, 
    SUM(CASE WHEN group_lesson_id IS NOT NULL AND booking_id IS NOT NULL THEN 1 ELSE 0 END) AS ensembles
FROM booking
    LEFT JOIN group_lesson ON booking.id = group_lesson.booking_id
    LEFT JOIN ensemble ON booking.id = ensemble.group_lesson_id
WHERE EXTRACT(YEAR FROM booking.booking_date) = '2022'      --Change year here
GROUP BY month;

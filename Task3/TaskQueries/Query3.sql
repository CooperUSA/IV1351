-- Lists all instructors who has given more than a specific number of lessons during the current month (This case, it's 1 or more).

SELECT DISTINCT 
    EXTRACT(month FROM CURRENT_DATE) AS "month", 
    CONCAT(p.first_name, ' ', p.last_name) as "name", 
    inst.given_lessons
FROM instructor
JOIN 
    (SELECT id, first_name, last_name FROM person) AS p ON p.id = person_id 
JOIN 
    (SELECT DISTINCT instructor_id, COUNT(*) AS given_lessons 
        FROM booking
        WHERE EXTRACT(month FROM booking.booking_date) = EXTRACT(month FROM CURRENT_DATE)
        GROUP BY instructor_id) 
        AS inst
    ON inst.instructor_id = person_id
JOIN 
    (SELECT instructor_id, booking_date 
        FROM booking
        WHERE EXTRACT(month FROM booking_date) = EXTRACT(month FROM CURRENT_DATE)) 
    AS "date"
    ON "date".instructor_id = person_id
WHERE inst.given_lessons >= 1 -- <--X
ORDER BY inst.given_lessons ASC;

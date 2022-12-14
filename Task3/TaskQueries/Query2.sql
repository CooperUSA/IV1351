-- Counts number of students with 0, 1 and 2 siblings.

SELECT 
    (SELECT COUNT(*) FROM (SELECT COUNT(*) FROM student GROUP BY family_id HAVING COUNT(*) = 1) AS foo) AS students_with_0_siblings,
    (SELECT COUNT(*)*2 FROM (SELECT COUNT(*) FROM student GROUP BY family_id HAVING COUNT(*) = 2) AS foo) AS students_with_1_sibling,
    (SELECT COUNT(*)*3 FROM (SELECT COUNT(*) FROM student GROUP BY family_id HAVING COUNT(*) = 3) AS foo) AS students_with_2_siblings;

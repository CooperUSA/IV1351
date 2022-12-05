CREATE TABLE available_instruments (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 instrument_type VARCHAR(50) NOT NULL,
 instrument_brand VARCHAR(50) NOT NULL,
 fee INT NOT NULL,
 available BIT(1) NOT NULL
);

ALTER TABLE available_instruments ADD CONSTRAINT PK_available_instruments PRIMARY KEY (id);


CREATE TABLE contact_person (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 contact_person_phone VARCHAR(13) NOT NULL,
 contact_person_email VARCHAR(100) NOT NULL
);

ALTER TABLE contact_person ADD CONSTRAINT PK_contact_person PRIMARY KEY (id);


CREATE TABLE payment (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 lesson_price INT NOT NULL,
 instructor_salary INT NOT NULL,
 siblingDiscount DECIMAL(2,2) NOT NULL
);

ALTER TABLE payment ADD CONSTRAINT PK_payment PRIMARY KEY (id);


CREATE TABLE person (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 first_name VARCHAR(100) NOT NULL,
 last_name VARCHAR(100) NOT NULL,
 phone_number  VARCHAR(13) NOT NULL,
 email VARCHAR(100) NOT NULL,
 person_number VARCHAR(13) NOT NULL UNIQUE,
 street VARCHAR(100) NOT NULL,
 zip VARCHAR(5) NOT NULL,
 city VARCHAR(100) NOT NULL
);

ALTER TABLE person ADD CONSTRAINT PK_person PRIMARY KEY (id);


CREATE TABLE student (
 person_id INT NOT NULL,
 family_id SERIAL NOT NULL,
 contact_person_id INT
);

ALTER TABLE student ADD CONSTRAINT PK_student PRIMARY KEY (person_id);


CREATE TABLE instructor (
 person_id INT NOT NULL,
 knows_ensamble BIT(1) NOT NULL
);

ALTER TABLE instructor ADD CONSTRAINT PK_instructor PRIMARY KEY (person_id);


CREATE TABLE instructor_available (
 instructor_id INT NOT NULL,
 available_date DATE NOT NULL,
 start_time TIME(0) NOT NULL,
 end_time TIME(0) NOT NULL
);

ALTER TABLE instructor_available ADD CONSTRAINT PK_instructor_available PRIMARY KEY (instructor_id, available_date, start_time, end_time);


CREATE TABLE instructor_known_instrument (
 instructor_id INT NOT NULL,
 instrument VARCHAR(50) NOT NULL
);

ALTER TABLE instructor_known_instrument ADD CONSTRAINT PK_instructor_known_instrument PRIMARY KEY (instructor_id, instrument);


CREATE TABLE renting_instruments (
 student_id INT NOT NULL,
 available_instrument_id INT NOT NULL,
 started_renting DATE NOT NULL
);

ALTER TABLE renting_instruments ADD CONSTRAINT PK_renting_instruments PRIMARY KEY (student_id, available_instrument_id);

CREATE TYPE GRADE AS ENUM ('Beginner', 'Intermediate', 'Advanced');
CREATE TABLE booking (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 instructor_id INT NOT NULL,
 payment_id INT NOT NULL,
 locale VARCHAR(100) NOT NULL,
 booking_date DATE NOT NULL,
 start_time TIME(0) NOT NULL,
 end_time TIME(0) NOT NULL,
 difficulty GRADE NOT NULL,
 instrument VARCHAR(50)
);

ALTER TABLE booking ADD CONSTRAINT PK_booking PRIMARY KEY (id);


CREATE TABLE group_lesson (
 booking_id INT NOT NULL,
 available_positions INT NOT NULL,
 min_students INT NOT NULL
);

ALTER TABLE group_lesson ADD CONSTRAINT PK_group_lesson PRIMARY KEY (booking_id);


CREATE TABLE student_lessons (
 booking_id INT NOT NULL,
 student_id INT NOT NULL,
 ensemble_instrument VARCHAR(50)
);

ALTER TABLE student_lessons ADD CONSTRAINT PK_student_lessons PRIMARY KEY (booking_id, student_id);


CREATE TABLE ensemble (
 group_lesson_id INT NOT NULL,
 genre VARCHAR(50) NOT NULL
);

ALTER TABLE ensemble ADD CONSTRAINT PK_ensemble PRIMARY KEY (group_lesson_id);


ALTER TABLE student ADD CONSTRAINT FK_student_0 FOREIGN KEY (person_id) REFERENCES person (id) ON DELETE CASCADE;
ALTER TABLE student ADD CONSTRAINT FK_student_1 FOREIGN KEY (contact_person_id) REFERENCES contact_person (id) ON DELETE SET NULL;


ALTER TABLE instructor ADD CONSTRAINT FK_instructor_0 FOREIGN KEY (person_id) REFERENCES person (id) ON DELETE CASCADE;


ALTER TABLE instructor_available ADD CONSTRAINT FK_instructor_available_0 FOREIGN KEY (instructor_id) REFERENCES instructor (person_id) ON DELETE CASCADE;


ALTER TABLE instructor_known_instrument ADD CONSTRAINT FK_instructor_known_instrument_0 FOREIGN KEY (instructor_id) REFERENCES instructor (person_id) ON DELETE CASCADE;


ALTER TABLE renting_instruments ADD CONSTRAINT FK_renting_instruments_0 FOREIGN KEY (student_id) REFERENCES student (person_id);
ALTER TABLE renting_instruments ADD CONSTRAINT FK_renting_instruments_1 FOREIGN KEY (available_instrument_id) REFERENCES available_instruments (id);


ALTER TABLE booking ADD CONSTRAINT FK_booking_0 FOREIGN KEY (instructor_id) REFERENCES instructor (person_id) ON DELETE CASCADE;
ALTER TABLE booking ADD CONSTRAINT FK_booking_1 FOREIGN KEY (payment_id) REFERENCES payment (id);


ALTER TABLE group_lesson ADD CONSTRAINT FK_group_lesson_0 FOREIGN KEY (booking_id) REFERENCES booking (id) ON DELETE CASCADE;


ALTER TABLE student_lessons ADD CONSTRAINT FK_student_lessons_0 FOREIGN KEY (booking_id) REFERENCES booking (id) ON DELETE CASCADE;
ALTER TABLE student_lessons ADD CONSTRAINT FK_student_lessons_1 FOREIGN KEY (student_id) REFERENCES student (person_id) ON DELETE CASCADE;


ALTER TABLE ensemble ADD CONSTRAINT FK_ensemble_0 FOREIGN KEY (group_lesson_id) REFERENCES group_lesson (booking_id) ON DELETE CASCADE;



CREATE VIEW num_of_siblings AS
SELECT 
    (SELECT COUNT(*) FROM (SELECT COUNT(*) FROM student GROUP BY family_id HAVING COUNT(*) = 1) AS foo) AS students_with_0_siblings, 
    (SELECT COUNT(*)*2 FROM (SELECT COUNT(*) FROM student GROUP BY family_id HAVING COUNT(*) = 2) AS foo) AS students_with_1_sibling,  
    (SELECT COUNT(*)*3 FROM (SELECT COUNT(*) FROM student GROUP BY family_id HAVING COUNT(*) = 3) AS foo) AS students_with_2_siblings;


CREATE MATERIALIZED VIEW num_of_lessons_2022 AS
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


CREATE MATERIALIZED VIEW instructors_lesson_curr_month AS
SELECT DISTINCT 
    EXTRACT(month FROM CURRENT_DATE) AS "month", 
    CONCAT(p.first_name, ' ', p.last_name) as "name", inst.given_lessons
FROM instructor
JOIN 
    (SELECT id, first_name, last_name FROM person) AS p ON p.id = person_id 
JOIN 
    (SELECT DISTINCT instructor_id, COUNT(*) 
        AS given_lessons 
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


CREATE VIEW ensembles_next_week AS
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

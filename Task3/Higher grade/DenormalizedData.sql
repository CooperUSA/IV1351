INSERT INTO student (id, first_name, last_name, phone_number, email, person_number, street, zip, city)
SELECT id, first_name, last_name, phone_number, email, person_number, street, zip, city
FROM dblink('dbname=soundgood user=postgres password=password', 
'SELECT 
    id, 
    first_name, 
    last_name, 
    phone_number, 
    email, 
    person_number, 
    street, 
    zip, 
    city
FROM 
    student LEFT JOIN person ON person.id = student.person_id;')
    AS student(id INT, first_name VARCHAR(100), last_name VARCHAR(100), phone_number VARCHAR(13),
    email VARCHAR(100), person_number VARCHAR(13), street VARCHAR(100) , zip VARCHAR(5), city VARCHAR(100));


INSERT INTO booking (id, locale, booking_date, start_time, end_time, difficulty, instrument, available_positions, min_students, genre, lesson_price, siblingDiscount)
SELECT id, locale, booking_date, start_time, end_time, difficulty, instrument, available_positions, min_students, genre, lesson_price, siblingDiscount
FROM dblink('dbname=soundgood user=postgres password=password', 
'SELECT
    all_lessons.id AS id,
    locale, 
    booking_date, 
    start_time, 
    end_time, 
    difficulty, 
    instrument, 
    available_positions, 
    min_students, 
    genre, 
    lesson_price, 
    siblingDiscount
FROM 
    all_lessons LEFT JOIN payment ON payment.id = all_lessons.payment_id;')
    AS booking(id INT, locale VARCHAR(100), booking_date DATE, start_time TIME(0), end_time TIME(0), difficulty GRADE,
    instrument VARCHAR(50), available_positions INT, min_students INT, genre VARCHAR(50), lesson_price INT, siblingDiscount DECIMAL(2,2));


INSERT INTO student_lessons(booking_id, student_id, ensemble_instrument)
SELECT booking_id, student_id, ensemble_instrument
FROM dblink('dbname=soundgood user=postgres password=password',
'SELECT
    booking_id,
    student_id,
    ensemble_instrument
FROM
    student_lessons;')
    AS student_lessons(booking_id INT, student_id INT, ensemble_instrument VARCHAR(50));

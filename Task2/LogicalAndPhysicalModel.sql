CREATE TABLE available (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 available_date DATE NOT NULL,
 start_time TIME(0) NOT NULL,
 end_time TIME(0) NOT NULL
);

ALTER TABLE available ADD CONSTRAINT PK_available PRIMARY KEY (id);


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


CREATE TABLE known_instrument (
 id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
 instrument VARCHAR(50) NOT NULL
);

ALTER TABLE known_instrument ADD CONSTRAINT PK_known_instrument PRIMARY KEY (id);


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
 available_id INT NOT NULL
);

ALTER TABLE instructor_available ADD CONSTRAINT PK_instructor_available PRIMARY KEY (instructor_id,available_id);


CREATE TABLE instructor_known_instrument (
 instructor_id INT NOT NULL,
 known_instrument_id INT NOT NULL
);

ALTER TABLE instructor_known_instrument ADD CONSTRAINT PK_instructor_known_instrument PRIMARY KEY (instructor_id,known_instrument_id);


CREATE TABLE renting_instruments (
 student_id INT NOT NULL,
 available_instrument_id INT NOT NULL,
 started_renting DATE NOT NULL
);

ALTER TABLE renting_instruments ADD CONSTRAINT PK_renting_instruments PRIMARY KEY (student_id,available_instrument_id);

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

ALTER TABLE student_lessons ADD CONSTRAINT PK_student_lessons PRIMARY KEY (booking_id,student_id);


CREATE TABLE ensemble (
 group_lesson_id INT NOT NULL,
 genre VARCHAR(50) NOT NULL
);

ALTER TABLE ensemble ADD CONSTRAINT PK_ensemble PRIMARY KEY (group_lesson_id);


ALTER TABLE student ADD CONSTRAINT FK_student_0 FOREIGN KEY (person_id) REFERENCES person (id) ON DELETE CASCADE;
ALTER TABLE student ADD CONSTRAINT FK_student_1 FOREIGN KEY (contact_person_id) REFERENCES contact_person (id) ON DELETE SET NULL;


ALTER TABLE instructor ADD CONSTRAINT FK_instructor_0 FOREIGN KEY (person_id) REFERENCES person (id) ON DELETE CASCADE;


ALTER TABLE instructor_available ADD CONSTRAINT FK_instructor_available_0 FOREIGN KEY (instructor_id) REFERENCES instructor (person_id) ON DELETE CASCADE;
ALTER TABLE instructor_available ADD CONSTRAINT FK_instructor_available_1 FOREIGN KEY (available_id) REFERENCES available (id) ON DELETE CASCADE;


ALTER TABLE instructor_known_instrument ADD CONSTRAINT FK_instructor_known_instrument_0 FOREIGN KEY (instructor_id) REFERENCES instructor (person_id) ON DELETE CASCADE;
ALTER TABLE instructor_known_instrument ADD CONSTRAINT FK_instructor_known_instrument_1 FOREIGN KEY (known_instrument_id) REFERENCES known_instrument (id) ON DELETE CASCADE;


ALTER TABLE renting_instruments ADD CONSTRAINT FK_renting_instruments_0 FOREIGN KEY (student_id) REFERENCES student (person_id);
ALTER TABLE renting_instruments ADD CONSTRAINT FK_renting_instruments_1 FOREIGN KEY (available_instrument_id) REFERENCES available_instruments (id);


ALTER TABLE booking ADD CONSTRAINT FK_booking_0 FOREIGN KEY (instructor_id) REFERENCES instructor (person_id) ON DELETE CASCADE;
ALTER TABLE booking ADD CONSTRAINT FK_booking_1 FOREIGN KEY (payment_id) REFERENCES payment (id);


ALTER TABLE group_lesson ADD CONSTRAINT FK_group_lesson_0 FOREIGN KEY (booking_id) REFERENCES booking (id) ON DELETE CASCADE;


ALTER TABLE student_lessons ADD CONSTRAINT FK_student_lessons_0 FOREIGN KEY (booking_id) REFERENCES booking (id) ON DELETE CASCADE;
ALTER TABLE student_lessons ADD CONSTRAINT FK_student_lessons_1 FOREIGN KEY (student_id) REFERENCES student (person_id) ON DELETE CASCADE;


ALTER TABLE ensemble ADD CONSTRAINT FK_ensemble_0 FOREIGN KEY (group_lesson_id) REFERENCES group_lesson (booking_id) ON DELETE CASCADE;

CREATE VIEW allStudents AS
SELECT id,first_name,last_name 
FROM person 
INNER JOIN student ON person.id = student.person_id;

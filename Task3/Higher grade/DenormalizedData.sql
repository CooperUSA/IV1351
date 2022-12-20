INSERT INTO student (first_name, last_name, phone_number, email, person_number, street, zip, city)
VALUES

    ('Rowan','Pitts','065-931-63-41','sed.dui.fusce@icloud.net','24755462-8728','Ap #508-7024 Varius Rd.','56228','Linköping'),
    ('Emmanuel','Steele','064-189-85-22','sagittis.nullam.vitae@google.net','64248978-2835','872-5810 Curabitur Street','26249','Linköping'),
('Lance','Wiley','045-063-74-19','vitae@outlook.org','69243574-5454','622-6017 In Street','68806','Tranås'),
    ('Raja','Nixon','021-211-17-72','aliquam@aol.couk','56794575-4514','409-5769 Posuere Rd.','67607','Mjölby'),
    ('Megan','Swanson','068-443-11-61','mauris.sapien@yahoo.couk','48447145-5465','4658 Nec Av.','10889','Avesta'),
    ('Page','Pitts','015-697-89-14','nec.mauris@outlook.com','42663572-5422','Ap #541-892 Nisl Ave','66317','Nässjö'),
('Davis','Wright','003-355-46-25','eget.tincidunt@yahoo.couk','67355854-8498','Ap #764-3395 Tincidunt St.','22504','Norrköping'),
('Xaviera','Newton','096-308-22-15','praesent.interdum@yahoo.com','22243398-1855','Ap #259-8124 Nec, Road','21333','Skövde'),
    ('Cameron','Pace','035-361-32-17','tortor@yahoo.com','25692672-6553','6387 Donec Ave','54554','Mora'),
    ('Dustin','Cain','051-531-35-13','ornare.fusce@aol.couk','86837149-7235','410-1298 Proin St.','03764','Vänersborg'), 
('Demetrius','Freeman','069-630-11-30','eu@outlook.couk','77662392-6623','Ap #400-6059 Tellus. St.','77336','Vetlanda'),
    ('Alec','Patterson','046-583-33-25','sapien.gravida@outlook.couk','55347948-4324','Ap #699-2352 Massa Rd.','78840','Motala'),
    ('Ivan','Mayo','044-418-18-36','donec.nibh@aol.edu','64232138-2665','438-447 Tempor Rd.','14180','Lidköping'),
    ('Carol','Parrish','082-183-15-85','vel.mauris.integer@google.org','23713668-5557','467 Augue Av.','51505','Lerum'),
('Rylee','Finch','040-126-96-28','felis.eget@icloud.org','31396236-9774','Ap #358-3593 Integer Avenue','47766','Ockelbo'),
    ('Hayley','Swanson','036-488-26-53','ultricies.ornare@yahoo.edu','24744668-8777','758-7211 Arcu Street','10121','Falun'),
    ('Herrod','Swanson','082-348-37-23','nulla.eu@google.net','22771373-5976','9725 Ullamcorper Road','17651','Upplands Väsby'),
    ('Stephen','Cain','023-215-23-84','porttitor@icloud.edu','28369667-2181','Ap #152-9531 Semper St.','26686','Linköping');
    
    
    INSERT INTO booking(locale, booking_date, start_time, end_time, difficulty, instrument, available_positions, min_students, genre, lesson_price, siblingDiscount)
VALUES

('Classroom33','2022-12-06','15:00','17:00','Beginner','Guitar', 4, 2, Null, 100, 0.25),
('Classroom33','2022-11-30','13:00','15:00','Intermediate','Piano', 7, 3, Null, 150, 0.25),
('Classroom31B','2022-11-25','14:30','16:30','Intermediate','Guitar', 5, 2, Null, 150, 0.25),
('Classroom24B','2022-11-26','14:30','16:00','Advanced', Null, 0, 3, 'Rock', 200, 0.25),
('Classroom31A','2022-12-02','13:00','14:00','Intermediate','Flute', Null, Null, Null, 1000, 0.25),
('Classroom24B','2022-11-20','15:00','16:30','Advanced',Null, 1, 3, 'Rock', 200, 0.25),
('Classroom31B','2022-12-07','14:30','16:30','Intermediate', 'Piano', 7, 2, Null, 150, 0.25),
('Classroom33','2022-12-01','15:00','17:00','Intermediate','Guitar', 6, 2, Null, 150, 0.25),
('Classroom24B','2022-12-14','14:30','16:00','Advanced', Null, 4, 2, 'Pop', 200, 0.25),
('Classroom33','2022-12-21','14:00','16:00','Beginner',Null, 6, 3, 'Country', 100, 0.25);


INSERT INTO student_lessons(booking_id, student_id, ensemble_instrument)
VALUES

((SELECT id FROM booking WHERE id = 1),
    (SELECT id FROM student WHERE id = 1),
    NULL),
((SELECT id FROM booking WHERE id = 2),
    (SELECT id FROM student WHERE id = 1),
    NULL),

((SELECT id FROM booking WHERE id = 3),
    (SELECT id FROM student WHERE id = 2),
    NULL),
((SELECT id FROM booking WHERE id = 8),
    (SELECT id FROM student WHERE id = 2),
    NULL),

((SELECT id FROM booking WHERE id = 2),
    (SELECT id FROM student WHERE id = 4),
    NULL),
((SELECT id FROM booking WHERE id = 7),
    (SELECT id FROM student WHERE id = 4),
    NULL),

((SELECT id FROM booking WHERE id = 2),
    (SELECT id FROM student WHERE id = 5),
    NULL),

((SELECT id FROM booking WHERE id = 1),
    (SELECT id FROM student WHERE id = 6),
    NULL),
((SELECT id FROM booking WHERE id = 2),
    (SELECT id FROM student WHERE id = 6),
    NULL),

((SELECT id FROM booking WHERE id = 4),
    (SELECT id FROM student WHERE id = 9),
    'Guitar'),

((SELECT id FROM booking WHERE id = 4),
    (SELECT id FROM student WHERE id = 10),
    'Drums'),
((SELECT id FROM booking WHERE id = 6),
    (SELECT id FROM student WHERE id = 10),
    'Drums'),

((SELECT id FROM booking WHERE id = 4),
    (SELECT id FROM student WHERE id = 12),
    'Piano'),
((SELECT id FROM booking WHERE id = 6),
    (SELECT id FROM student WHERE id = 12),
    'Piano'),

((SELECT id FROM booking WHERE id = 4),
    (SELECT id FROM student WHERE id = 13),
    'Guitar'),
((SELECT id FROM booking WHERE id = 6),
    (SELECT id FROM student WHERE id = 14),
    'Guitar'),

((SELECT id FROM booking WHERE id = 5),
    (SELECT id FROM student WHERE id = 14),
    NULL),

((SELECT id FROM booking WHERE id = 9),
    (SELECT id FROM student WHERE id = 16),
    'Piano'),

((SELECT id FROM booking WHERE id = 9),
    (SELECT id FROM student WHERE id = 17),
    'Guitar'),

((SELECT id FROM booking WHERE id = 9),
    (SELECT id FROM student WHERE id = 18),
    'Harp');

/*  
    Author: William Asp

    How to insert data into tables:

    INSERT INTO table_name(column1, column2, …)
    VALUES (value1, value2, …); 

*/

BEGIN;


/* Insert 6 people */
INSERT INTO person (person_number, 
                    first_name, 
                    last_name, 
                    phone, 
                    email, 
                    street_name, 
                    street_number, 
                    postal_code, 
                    city)
            VALUES (
                '199903045555',
                'William',
                'Asp',
                '0761461400',
                'wille@mail.com',
                'Brommavägen',
                '95',
                '16835',
                'Bromma'
            ), (
                '200107213475',
                'Moa',
                'Malmström',
                '0702346613',
                'moa@mail.com',
                'Nilegårdsvägen',
                '5b',
                '66890',
                'Blattnicksele'
            ), (
                '200005167821',
                'Johannes',
                'Valck',
                '0709383159',
                'joppev@hotmail.nu',
                'Beämexvägen',
                '69',
                '42069',
                'Backflipköping'
            ), (
                '198911088619',
                'Fredrik',
                'Blindström',
                '0705597812',
                'fredrikb@gmail.com',
                'Halvvägen',
                '18',
                '62870',
                'Trestegsköping'
            ), (
                '175601274567',
                'Amadeus',
                'Mozart',
                '0709998869',
                'mozart@brevduva.au',
                'Getreidegasse',
                '9',
                '10044',
                'Salzburg'
            ), (
                '177012171234',
                'Ludwig',
                'Beethoven',
                '0701823455',
                'beethoven@brevduva.au',
                'Ärtgatan',
                '4',
                '34567',
                'Wien'
            ), (
                '191901018888',
                'Thomas',
                'Ravelli',
                '0708862312',
                'ravelli@mail.com',
                'Fotbollsgatan',
                '1',
                '12387',
                'Madrid'
            ), (
                '2001-12-18',
                'Billie',
                'Eilish',
                '0731217459',
                'avocado@where.com',
                'BeverlyHillsStreet',
                '69',
                '66679',
                'Los Angeles'
            ), (
                '198903237777',
                'Felix',
                'Kjellberg',
                '0724562382',
                'pewdiepie@gmail.com',
                'Barrelstreet',
                '420',
                '33497',
                'Brighton'
            );


/* Insert 3 students */
INSERT INTO student (person_id)
            VALUES  (1),
                    (2),
                    (3),
                    (7),
                    (8),
                    (9);

/* Insert 3 instructors */
INSERT INTO instructor (person_id, teaches_ensembles)
            VALUES  (4, true),
                    (5, false),
                    (6, true);


/* Insert 9 rental instruments */

INSERT INTO rental_instrument(name, type, brand, monthly_cost)
/* 1 */      VALUES ('guitar', 'string', 'Epiphone', 399.99),
/* 2 */             ('guitar', 'string', 'Gibson', 399.99),
/* 3 */             ('guitar', 'string', 'Yamaha', 399.99),
/* 4 */             ('violin', 'string', 'Stentor', 299.99),
/* 5 */             ('violin', 'string', 'Knilling', 299.99),
/* 6 */             ('violin', 'string', 'Cremona', 299.99),
/* 7 */             ('trumpet', 'wind', 'Yamaha', 349.99),
/* 8 */             ('trumpet', 'wind', 'Getzen', 349.99),
/* 9 */             ('trumpet', 'wind', 'Mendini', 349.99);



/* Insert rentals */
INSERT INTO rental (start_date, end_date, student_id, ri_id)
            VALUES  ('2020-01-01', '2020-02-01', 1, 1),
                    ('2020-01-01', '2020-02-01', 1, 2),
                    ('2020-02-01', '2020-03-01', 1, 3),
                    ('2020-02-01', '2020-03-01', 2, 4),
                    ('2020-03-01', '2020-04-01', 2, 5),
                    ('2020-03-01', '2020-04-01', 2, 6),
                    ('2020-04-01', '2020-05-01', 3, 7),
                    ('2020-04-01', '2020-05-01', 3, 8),
                    ('2020-05-01', '2020-06-01', 3, 9),
                    ('2020-05-01', '2020-06-01', 3, 9);


/* Insert 3 instruments */
INSERT INTO instrument (name, type)
            VALUES ('guitar', 'string'), /* 1 */
                    ('piano', 'keys'), /* 2 */
                    ('saxophone', 'wind'); /* 3 */           


/* Insert 9 lessons */
INSERT INTO individual_lesson (instrument_id, level, instructor_id, student_id, start_time, end_time, date, price, pay)
            VALUES  (1, 'beginner', 1, 1, '10:00', '11:00', '2020-12-10', 150, 120),
                    (2, 'intermediate', 2, 2, '11:00', '12:00', '2020-04-13', 150, 120),
                    (2, 'intermediate', 2, 2, '17:00', '18:00', '2020-04-15', 150, 120),
                    (3, 'advanced', 3, 3, '09:00', '11:00', '2020-12-15', 180, 150);

INSERT INTO group_lesson (instrument_id, level, instructor_id, max_students, min_students, start_time, end_time, date, price, pay)
            VALUES  (1, 'beginner', 1, 15, 5, '14:00', '15:30', '2020-02-13', 100, 120),
                    (2, 'intermediate', 2, 20, 8, '15:00', '17:00', '2020-11-20', 100, 120),
                    (3, 'advanced', 3, 8, 3, '13:00', '15:30', '2020-11-10', 120, 150);

INSERT INTO ensemble(genre, max_students, min_students, level, instructor_id, start_time, end_time, date, price, pay)
            VALUES  ('afrobeat',        5,  2, 'beginner',     1, '09:00', '12:00', '2020-12-21', 120, 150),
                    ('post-dubstep',    5,  2, 'intermediate', 1, '10:00', '12:00', '2020-12-22', 120, 150),
                    ('metalcore',       5,  2, 'advanced',     3, '14:00', '16:00', '2020-12-23', 150, 200),
                    ('afrobeat',        5,  2, 'beginner',     1, '09:00', '12:00', '2020-12-24', 120, 150),
                    ('post-dubstep',    5,  2, 'intermediate', 2, '10:00', '12:00', '2020-12-25', 120, 150),
                    ('metalcore',       5,  2, 'advanced',     3, '14:00', '16:00', '2020-12-26', 150, 200);


/* Insert students into ensembles */
INSERT INTO ensemble_lesson_student(student_id, ensemble_id)
            VALUES  (1, 1), -- 3 students to ensemble 1
                    (2, 1),
                    (3, 1),
                    (1, 2), -- 5 students to ensemble 2
                    (2, 2),
                    (3, 2),
                    (4, 2),
                    (5, 2),
                    (6, 3), -- 4 students to ensemble 3
                    (5, 3),
                    (4, 3),
                    (3, 3),
                    (6, 4), -- 2 students to ensemble 4
                    (5, 4),
                    (6, 5); -- 1 student to ensemble 5
                    -- 0 students to ensemble 6

COMMIT;
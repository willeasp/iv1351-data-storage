

/* 
1. FINISHED
Show the number of instruments rented per month during a specified year. 
It shall be possible to retrieve the total number of rented instruments 
(just one number) and rented instruments of each kind (one number per kind, 
guitar, trumpet, etc). The latter list shall be sorted BY number of rentals. 
This query is expected to be performed a few times per week. 
*/

CREATE OR REPLACE VIEW RentalsPerMonth AS 
SELECT  
    COALESCE("month", 'ALL') AS month, 
    COALESCE("instrument", 'TOTAL') AS instrument,
    rentals 
FROM    
(
    SELECT  
        TO_CHAR(r.start_date, 'Month') AS month, 
        ri.name AS instrument, 
        COUNT(ri.name) AS rentals
    FROM 
        rental AS r
    JOIN 
        rental_instrument AS ri
    ON 
        r.ri_id = ri.ri_id
    WHERE 
        EXTRACT(YEAR FROM r.start_date) = 2020
    GROUP BY 
        ROLLUP(month), ROLLUP(instrument)
) AS query
ORDER BY 
    rentals DESC;

/* 
   Month   | Instrument | Rentals
-----------+------------+---------
 ALL       | TOTAL      |       9
 ALL       | guitar     |       3
 ALL       | violin     |       3
 ALL       | trumpet    |       3
 April     | TOTAL      |       2
 March     | TOTAL      |       2
 February  | TOTAL      |       2
 January   | TOTAL      |       2
 January   | guitar     |       2
 March     | violin     |       2
 April     | trumpet    |       2
 February  | violin     |       1
 May       | trumpet    |       1
 May       | TOTAL      |       1
 February  | guitar     |       1
 */
/********************************************************************************************************************/

/* 
2. FINISHED
The same as above, but retrieve the average number of rentals per month 
during the entire year, instead of the total for each month. 
*/

CREATE OR REPLACE VIEW RentalsMonthlyAverage AS 
SELECT 
    COALESCE("instrument", 'ALL') AS instrument,
    CAST(COUNT(*) /12.0 AS DECIMAL(10,2)) AS avg_rentals
FROM (
    SELECT 
        TO_CHAR(r.start_date, 'Month') AS month,
        ri.name AS instrument
    FROM    
        rental_instrument AS ri
    INNER JOIN  
        rental AS r
    ON 
        r.ri_id = ri.ri_id
    WHERE
        EXTRACT(YEAR FROM r.start_date) >= 2020
) AS rentals
GROUP BY 
    ROLLUP(instrument)
ORDER BY
    avg_rentals;


/********************************************************************************************************************/

/* 
3. FINISHED
Show the number of lessons given per month during a specified year. It shall 
be possible to retrieve the total number of lessons (just one number) and 
the specific number of individual lessons, group lessons and ensembles. This 
query is expected to be performed a few times per week. 
*/

CREATE OR REPLACE VIEW LessonsPerMonth AS
SELECT  
    COALESCE("month", 'ALL') AS month,
    SUM(i) i_lessons, 
    SUM(g) g_lessons, 
    SUM(e) ensembles, 
    SUM(t) total
FROM 
(
    SELECT 
        EXTRACT(YEAR FROM date) AS year,
        TO_CHAR(date, 'Month') AS month,
        i, g, e, t
    FROM (
        SELECT 
            date, 1 i, 0 g, 0 e, 1 t
        FROM 
            individual_lesson
        UNION (
            SELECT 
                date m, 0 i, 1 g, 0 e, 1 t
            FROM 
                group_lesson 
        )
        UNION (
            SELECT 
                date m, 0 i, 0 g, 1 e, 1 t
            FROM 
                ensemble 
        )
    ) a1
) a2
WHERE 
    year = 2020 

GROUP BY ROLLUP(month)
ORDER BY total DESC;

/* 
   month   | i_lessons | g_lessons | ensembles | total
-----------+-----------+-----------+-----------+-------
 December  |         3 |         0 |         0 |     3
 November  |         0 |         3 |         0 |     3
 October   |         0 |         0 |         3 |     3 */


/********************************************************************************************************************/

/* 
4. FINISHED
The same as above, but retrieve the average number of lessons per month
during the entire year, instead of the total for each month. */

CREATE OR REPLACE VIEW LessonsMonthlyAverage AS 
SELECT  EXTRACT(YEAR FROM date) AS year, 
        CAST(SUM(i) /12.0 AS DECIMAL(10,2)) AS i_lessons, 
        CAST(SUM(g) /12.0 AS DECIMAL(10,2)) AS g_lessons, 
        CAST(SUM(e) /12.0 AS DECIMAL(10,2)) AS ensembles, 
        CAST(SUM(t) /12.0 AS DECIMAL(10,2)) AS total
    FROM (
        SELECT 
            date, i, g, e, t
            FROM (
                SELECT 
                    date, 1 i, 0 g, 0 e, 1 t
                FROM 
                    individual_lesson
                ) a1
                UNION (
                SELECT 
                    date m, 0 i, 1 g, 0 e, 1 t
                FROM 
                    group_lesson 
                )
                UNION (
                SELECT 
                    date m, 0 i, 0 g, 1 e, 1 t
                FROM 
                    ensemble 
                ) 
        ) a2
    WHERE 
        EXTRACT(YEAR FROM date) = 2020
    GROUP BY year
    ORDER BY year;


/********************************************************************************************************************/

/* 
5. YÄÄ it's probably FINISHED
List all instructors who has given more than a specific number of lessons
during the current month. SUM all lessons, independent of type. Also list the 
three instructors having given most lessons (independent of lesson type) during 
the last month, sorted BY number of given lessons. This query will be used to 
find instructors risking to work too much, and will be executed daily. */

CREATE OR REPLACE VIEW InstructorOverworkingStatus AS
-- Get the 3 instructors with the most amount of lessons
(SELECT
    instructor_id AS instructor,
    COUNT(instructor_id) AS given_lessons
FROM (
    SELECT 
        date, 
        instructor_id 
    FROM 
        individual_lesson
    UNION
    SELECT 
        date, 
        instructor_id 
    FROM 
        group_lesson
    UNION
    SELECT 
        date, 
        instructor_id 
    FROM 
        ensemble
) AS lessons
WHERE
    date >= DATE_TRUNC('month', CURRENT_DATE)
GROUP BY 
    instructor
ORDER BY 
    given_lessons DESC
LIMIT 3)
-- together with
UNION
-- Get the isntructors that have done at least 2 lessons
SELECT 
    instructor_id AS instructor,
    COUNT(instructor_id) AS given_lessons
FROM (
    SELECT 
        date, 
        instructor_id 
    FROM 
        individual_lesson
    UNION
    SELECT 
        date, 
        instructor_id 
    FROM 
        group_lesson
    UNION
    SELECT 
        date, 
        instructor_id 
    FROM 
        ensemble
) AS lessons
WHERE
    date >= DATE_TRUNC('month', CURRENT_DATE)
GROUP BY
    instructor
HAVING
    COUNT(instructor_id) >= 2
ORDER BY given_lessons DESC;


/* ************************************************************************************ */
/* ************************************************************************************ */
/* ************************************************************************************ */

/* 
The following queries will be performed programmatically, and the results will be 
displayed on Soundgood's web page. You only have to create the queries, not the web page. */

/* 
6.  FINISHED
List all ensembles held during the next week, sorted by music genre and weekday. For each 
ensemble tell whether it's full booked, has 1-2 seats left or has more seats left.*/

CREATE OR REPLACE VIEW EnsemblesNextWeek AS 
SELECT 
    genre, 
    TO_CHAR(date, 'Day') AS weekday,
    CASE 
        WHEN COUNT(student_id) = max_students
            THEN 'Full booked'
        WHEN COUNT(student_id) = max_students -2
            THEN '2 seats left'
        WHEN COUNT(student_id) = max_students -1
            THEN '1 seat left'
        ELSE
            'Many seats left'
    END AS places_left
FROM (
    SELECT 
        genre, 
        date,
        student_id,
        max_students
    FROM
        ensemble AS en
    LEFT OUTER JOIN
        ensemble_lesson_student AS els
    ON 
        en.ensemble_id = els.ensemble_id
    GROUP BY
        genre,
        date,
        student_id,
        max_students
) AS ensembles
WHERE 
    date >= DATE_TRUNC('week', CURRENT_DATE)
GROUP BY
    genre,
    date,
    max_students
ORDER BY
    genre,
    date;


/* 
7. FINISHED
List the three instruments with the lowest monthly rental fee. For each instrument tell 
whether it is rented or available to rent. Also tell when the next group lesson for each
listed instrument is scheduled. */

CREATE OR REPLACE VIEW AvailableInstruments AS
SELECT 
    i.name AS instrument,
    ri.monthly_cost,
    ri.ri_id AS ri_id,
    CASE
        WHEN r.student_id IS NULL 
            THEN 'available'
        ELSE 
            'rented'
    END AS status,
    g.date AS next_group_lesson
FROM 
    rental_instrument AS ri
NATURAL LEFT OUTER JOIN -- join by ri_id, where the rental is active
(
    SELECT *
    FROM
        rental AS r
    WHERE
        CURRENT_DATE >= r.start_date
        AND
        CURRENT_DATE < r.end_date

) AS r
NATURAL LEFT OUTER JOIN -- join by instrument name, to get group lesson with that instrument
    instrument AS i 
NATURAL LEFT OUTER JOIN -- join by instrument_id
(
    SELECT      -- get soonest lesson for every instrument
        instrument_id,
        MIN(date) AS date
    FROM 
        group_lesson
    WHERE
        date >= DATE_TRUNC('day', CURRENT_DATE)
    GROUP BY
        instrument_id
) AS g
ORDER BY
    monthly_cost
LIMIT 3;

/* 
 instrument | monthly_cost | ri_id | status | next_group_lesson
------------+--------------+-------+--------+-------------------
 trumpet    |       249.99 |     7 | rented |
 guitar     |       289.99 |     1 | rented |
 violin     |       299.99 |     4 | rented |
  */


/* 
1. FINISHED
Show the number of instruments rented per month during a specified year. 
It shall be possible to retrieve the total number of rented instruments 
(just one number) and rented instruments of each kind (one number per kind, 
guitar, trumpet, etc). The latter list shall be sorted BY number of rentals. 
This query is expected to be performed a few times per week. 
*/

SELECT  COALESCE("month", 'ALL') AS month, 
        COALESCE("instrument", 'TOTAL') AS instrument,
        rentals 
FROM    (
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
 February  | violin     |       1
 May       | trumpet    |       1
 May       | TOTAL      |       1
 February  | guitar     |       1
 April     | TOTAL      |       2
 March     | TOTAL      |       2
 February  | TOTAL      |       2
 January   | TOTAL      |       2
 January   | guitar     |       2
 March     | violin     |       2
 April     | trumpet    |       2
 ALL       | guitar     |       3
 ALL       | violin     |       3
 ALL       | trumpet    |       3
 ALL       | TOTAL      |       9*/
/********************************************************************************************************************/

/* 
2. FINISHED
The same as above, but retrieve the average number of rentals per month 
during the entire year, instead of the total for each month. 
*/

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
    ON r.ri_id = ri.ri_id
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


SELECT  COALESCE("month", 'ALL') AS month,
        SUM(i) i_lessons, 
        SUM(g) g_lessons, 
        SUM(e) ensembles, 
        SUM(t) total
FROM (
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


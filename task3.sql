

/* 
1. NOT FINISHED
Show the number of instruments rented per month during a specified year. 
It shall be possible to retrieve the total number of rented instruments 
(just one number) and rented instruments of each kind (one number per kind, 
guitar, trumpet, etc). The latter list shall be sorted by number of rentals. 
This query is expected to be performed a few times per week. 
*/
/* 
SELECT  COALESCE("Month", 'ALL') AS "Month", 
        COALESCE("Instrument", 'TOTAL') AS "Instrument",
        "Rentals" 
FROM    (
    SELECT  
        TO_CHAR(r.start_date, 'Month') AS "Month", 
        ri.name AS "Instrument", 
        COUNT(ri.name) AS "Rentals" 
    FROM 
        rental AS r
    JOIN 
        rental_instrument AS ri
    ON 
        r.ri_id = ri.ri_id
    WHERE 
        EXTRACT(YEAR FROM r.start_date) = 2020
    GROUP BY 
        ROLLUP("Month"), ROLLUP("Instrument")
) AS query
ORDER BY 
    "Month"; */

/* 
   Month   | Instrument | Rentals
-----------+------------+---------
 ALL       | TOTAL      |       9
 ALL       | violin     |       3
 ALL       | trumpet    |       3
 ALL       | guitar     |       3
 April     | TOTAL      |       2
 April     | trumpet    |       2
 February  | TOTAL      |       2
 February  | guitar     |       1
 February  | violin     |       1
 January   | TOTAL      |       2
 January   | guitar     |       2
 March     | violin     |       2
 March     | TOTAL      |       2
 May       | TOTAL      |       1
 May       | trumpet    |       1 */
/********************************************************************************************************************/

/* 
2. PROBABLY FINISHED
The same as above, but retrieve the average number of rentals per month 
during the entire year, instead of the total for each month. 
*/
/* 
-- Average rentals of each instrument per month
SELECT 
    "Instrument",
    CAST(AVG("Rentals") AS DECIMAL(10, 2)) AS "Average"
FROM (
    SELECT 
        TO_CHAR(r.start_date,'Mon') AS "Month",
        ri.name AS "Instrument",
        COUNT(*) AS "Rentals"
    FROM 
        rental AS r
    JOIN 
        rental_instrument AS ri
    ON 
        r.ri_id = ri.ri_id
    WHERE
        EXTRACT(YEAR FROM start_date) = 2020
    GROUP BY 
        "Month", "Instrument"
) AS rentals
GROUP BY    
    "Instrument"

UNION ALL
-- Get average of all instruments across all months
SELECT
    'ALL' AS "Instrument",
    CAST(AVG("Rented") AS DECIMAL(10, 2)) AS "Average" 
FROM (
    SELECT 
        TO_CHAR(start_date,'Mon') AS "Month",
        COUNT(*) AS "Rented"
    FROM 
        rental
    WHERE
        EXTRACT(YEAR FROM start_date) = 2020
    GROUP BY
        "Month" 
) AS rentals; */

/* ACTUAL OUTPUT
 Instrument | Average
------------+---------
 guitar     |    1.50
 trumpet    |    1.50
 violin     |    1.50
 ALL        |    1.80
  */


/********************************************************************************************************************/

/* 
3. NOT FINISHED
Show the number of lessons given per month during a specified year. It shall 
be possible to retrieve the total number of lessons (just one number) and 
the specific number of individual lessons, group lessons and ensembles. This 
query is expected to be performed a few times per week. 
*/

/* select  TO_CHAR(date, 'Month') AS month, 
        sum(i) i_lessons, 
        sum(g) g_lessons, 
        sum(e) ensembles, 
        sum(t) total
    from (
        select date, i, g, e, t
            from (select date, 1 i, 0 g, 0 e, 1 t
                from individual_lesson) a1
                union 
                (select date m, 0 i, 1 g, 0 e, 1 t
                from group_lesson )
                union 
                (select date m, 0 i, 0 g, 1 e, 1 t
                from ensemble ) ) a2
    where 
        EXTRACT(YEAR FROM date) = 2020
    group by month 
    order by month; */

/* 
   month   | i_lessons | g_lessons | ensembles | total
-----------+-----------+-----------+-----------+-------
 December  |         3 |         0 |         0 |     3
 November  |         0 |         3 |         0 |     3
 October   |         0 |         0 |         3 |     3 */


/********************************************************************************************************************/

/* 
4. NOT FINISHED
The same as above, but retrieve the average number of lessons per month
during the entire year, instead of the total for each month. */




/********************************************************************************************************************/

/* 
5. NOT FINISHED
List all instructors who has given more than a specific number of lessons
during the current month. Sum all lessons, independent of type. Also list the 
three instructors having given most lessons (independent of lesson type) during 
the last month, sorted by number of given lessons. This query will be used to 
find instructors risking to work too much, and will be executed daily. */
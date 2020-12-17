

/* 
1. NOT FINISHED
Show the number of instruments rented per month during a specified year. 
It shall be possible to retrieve the total number of rented instruments 
(just one number) and rented instruments of each kind (one number per kind, 
guitar, trumpet, etc). The latter list shall be sorted by number of rentals. 
This query is expected to be performed a few times per week. 
*/

/* SELECT * FROM (
    SELECT TO_CHAR(start_date,'Mon') AS "Month",
        EXTRACT(YEAR FROM start_date) AS "Year",
        COUNT(*) AS "Rented"
    FROM rental
    GROUP BY 1,2
) AS rentals
;

SELECT name, COUNT(*) FROM rental_instrument 
NATURAL JOIN rental
GROUP BY name
; */


/* 
2. PROBABLY FINISHED
The same as above, but retrieve the average number of rentals per month 
during the entire year, instead of the total for each month. 
*/

/* SELECT "Year", CAST(AVG("Rented") AS DECIMAL(10, 2)) AS "Average" FROM (
    SELECT TO_CHAR(start_date,'Mon') AS "Month",
        EXTRACT(YEAR FROM start_date) AS "Year",
        COUNT(*) AS "Rented"
    FROM rental
    GROUP BY 1,2
) AS rentals
GROUP BY "Year"; */


/* 
3. NOT FINISHED
Show the number of lessons given per month during a specified year. It shall 
be possible to retrieve the total number of lessons (just one number) and 
the specific number of individual lessons, group lessons and ensembles. This 
query is expected to be performed a few times per week. 
*/

SELECT * FROM individual_lesson;
SELECT * FROM group_lesson;
SELECT * FROM ensemble;

SELECT  COALESCE("Month", 'Total') AS "Month", 
        SUM("count") FROM (
    SELECT TO_CHAR("date", 'Mon') AS "Month", 
        COUNT(*) FROM individual_lesson 
        GROUP BY "Month"
    UNION ALL
        SELECT TO_CHAR("date", 'Mon') AS "Month", COUNT(*) FROM group_lesson GROUP BY "Month"
    UNION ALL
        SELECT TO_CHAR("date", 'Mon') AS "Month", COUNT(*) FROM ensemble GROUP BY "Month"
) AS lessons
GROUP BY ROLLUP("Month")

;



/* 
4. NOT FINISHED
The same as above, but retrieve the average number of lessons per month
during the entire year, instead of the total for each month. */


/* 
5. NOT FINISHED
List all instructors who has given more than a specific number of lessons
during the current month. Sum all lessons, independent of type. Also list the 
three instructors having given most lessons (independent of lesson type) during 
the last month, sorted by number of given lessons. This query will be used to 
find instructors risking to work too much, and will be executed daily. */
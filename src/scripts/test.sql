/* SELECT DISTINCT name, brand, monthly_cost, ri_id AS id, start_date, end_date
            FROM rental_instrument 
            NATURAL LEFT OUTER JOIN 
            (SELECT MAX(start_date) as start_date, MAX(end_date) as end_date, ri_id
            FROM rental
            WHERE CURRENT_DATE > end_date
            GROUP BY ri_id
            ) as r
            NATURAL LEFT OUTER JOIN
            rental
            WHERE (terminated IS NOT NULL AND CURRENT_DATE >= terminated)
                OR start_date IS NULL
            ORDER BY monthly_cost; */

SELECT *
FROM rental_instrument AS ri
WHERE NOT EXISTS
(SELECT 1 FROM rental AS r
WHERE ri.ri_id = r.ri_id 
    AND CURRENT_DATE < end_date
    AND terminated IS NULL)
/* 
SELECT name, brand, monthly_cost, start_date, end_date, ri_id AS id
            FROM rental
            NATURAL JOIN rental_instrument
            WHERE CURRENT_DATE < end_date 
                AND
                student_id = %s
                AND
                (CURRENT_DATE < terminated
                OR
                terminated IS NULL);
 */
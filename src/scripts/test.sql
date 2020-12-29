SELECT *
FROM rental AS r
WHERE CURRENT_DATE BETWEEN r.start_date AND r.end_date AND
    r.student_id = 1;

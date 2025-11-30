SELECT COUNT(*) AS customer_count
FROM (
    SELECT r.customer_id,
           COUNT(r.rental_id) AS not_returned
    FROM rental r
    WHERE r.return_date IS NULL
    GROUP BY r.customer_id
    HAVING COUNT(r.rental_id) > 1
) AS sub;

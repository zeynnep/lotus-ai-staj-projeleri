WITH cust_rental AS (
    SELECT r.customer_id, COUNT(r.rental_id) AS rental_count
    FROM rental r
    GROUP BY r.customer_id
    ORDER BY rental_count DESC
    LIMIT 5
)
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       s.store_id
FROM cust_rental cr
JOIN customer c ON c.customer_id = cr.customer_id
JOIN store s    ON c.store_id = s.store_id
ORDER BY cr.rental_count DESC;

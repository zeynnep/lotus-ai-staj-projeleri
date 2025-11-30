SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       COUNT(r.rental_id) AS total_rentals
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_rentals DESC
LIMIT 1;


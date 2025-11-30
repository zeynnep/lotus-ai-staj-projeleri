SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       SUM(julianday(r.return_date) - julianday(r.rental_date)) AS total_days
FROM rental r
JOIN customer c ON c.customer_id = r.customer_id
WHERE r.return_date IS NOT NULL
GROUP BY c.customer_id, customer_name
ORDER BY total_days DESC;

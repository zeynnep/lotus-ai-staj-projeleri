SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_spent DESC
LIMIT 5;

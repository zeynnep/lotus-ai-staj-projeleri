SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       AVG(p.amount) AS avg_payment
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY avg_payment DESC;

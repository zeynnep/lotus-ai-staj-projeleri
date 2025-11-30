WITH cust_rev AS (
  SELECT p.customer_id, SUM(p.amount) AS total_spent
  FROM payment p
  GROUP BY p.customer_id
  ORDER BY total_spent DESC
  LIMIT 5
)
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       ci.city,
       cr.total_spent
FROM cust_rev cr
JOIN customer c ON c.customer_id = cr.customer_id
JOIN address  a ON a.address_id  = c.address_id
JOIN city     ci ON ci.city_id   = a.city_id
ORDER BY cr.total_spent DESC;

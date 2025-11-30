WITH cust_cnt AS (
  SELECT c.customer_id,
         c.first_name || ' ' || c.last_name AS customer_name,
         COUNT(r.rental_id) AS rental_count
  FROM customer c
  JOIN rental r ON r.customer_id = c.customer_id
  GROUP BY c.customer_id, customer_name
)
SELECT customer_id, customer_name, rental_count
FROM cust_cnt
WHERE rental_count = (SELECT MAX(rental_count) FROM cust_cnt)
ORDER BY customer_name;

WITH cust_rev AS (
  SELECT c.customer_id,
         c.first_name || ' ' || c.last_name AS customer_name,
         SUM(p.amount) AS total_revenue
  FROM customer c
  JOIN payment p ON p.customer_id = c.customer_id
  GROUP BY c.customer_id, customer_name
)
SELECT customer_id, customer_name, total_revenue
FROM cust_rev
WHERE total_revenue = (SELECT MAX(total_revenue) FROM cust_rev)
ORDER BY customer_name;

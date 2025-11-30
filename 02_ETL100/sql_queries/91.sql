WITH cust_rev AS (
  SELECT c.customer_id,
         c.first_name || ' ' || c.last_name AS customer_name,
         COALESCE(SUM(p.amount), 0) AS total_revenue
  FROM customer c
  LEFT JOIN payment p ON p.customer_id = c.customer_id
  GROUP BY c.customer_id, customer_name
)
SELECT customer_id, customer_name, total_revenue
FROM cust_rev
WHERE total_revenue = (SELECT MIN(total_revenue) FROM cust_rev)
ORDER BY customer_name;

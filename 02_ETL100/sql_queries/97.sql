WITH cust_dist AS (
  SELECT c.customer_id,
         c.first_name || ' ' || c.last_name AS customer_name,
         COUNT(DISTINCT i.film_id) AS distinct_films
  FROM customer c
  LEFT JOIN rental r    ON r.customer_id  = c.customer_id
  LEFT JOIN inventory i ON i.inventory_id = r.inventory_id
  GROUP BY c.customer_id, customer_name
)
SELECT customer_id, customer_name, distinct_films
FROM cust_dist
WHERE distinct_films = (SELECT MIN(distinct_films) FROM cust_dist)
ORDER BY customer_name;

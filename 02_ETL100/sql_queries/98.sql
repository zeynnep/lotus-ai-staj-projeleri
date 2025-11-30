WITH film_cust AS (
  SELECT f.film_id,
         f.title,
         COUNT(DISTINCT r.customer_id) AS distinct_customers
  FROM film f
  JOIN inventory i ON i.film_id = f.film_id
  JOIN rental   r  ON r.inventory_id = i.inventory_id
  GROUP BY f.film_id, f.title
)
SELECT film_id, title, distinct_customers
FROM film_cust
WHERE distinct_customers = (SELECT MAX(distinct_customers) FROM film_cust)
ORDER BY title;

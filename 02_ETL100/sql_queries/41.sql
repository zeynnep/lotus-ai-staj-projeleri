WITH cust_rev AS (
  SELECT c.customer_id,
         c.first_name || ' ' || c.last_name AS customer_name,
         COALESCE(SUM(p.amount), 0) AS total_spent
  FROM customer c
  LEFT JOIN payment p ON p.customer_id = c.customer_id
  GROUP BY c.customer_id, customer_name
),
mincust AS (
  SELECT customer_id, customer_name, total_spent
  FROM cust_rev
  WHERE total_spent = (SELECT MIN(total_spent) FROM cust_rev)
)
SELECT m.customer_id,
       m.customer_name,
       f.film_id,
       f.title,
       COUNT(r.rental_id)                    AS times_rented,
       COALESCE(SUM(p.amount), 0)            AS film_revenue
FROM mincust m
LEFT JOIN rental   r ON r.customer_id = m.customer_id
LEFT JOIN payment  p ON p.rental_id   = r.rental_id
LEFT JOIN inventory i ON i.inventory_id = r.inventory_id
LEFT JOIN film      f ON f.film_id      = i.film_id
GROUP BY m.customer_id, m.customer_name, f.film_id, f.title
ORDER BY m.customer_id, film_revenue ASC, times_rented ASC, f.title;

WITH cust_rev AS (
  SELECT p.customer_id, SUM(p.amount) AS total_spent
  FROM payment p
  GROUP BY p.customer_id
),
topc AS (
  SELECT customer_id
  FROM cust_rev
  WHERE total_spent = (SELECT MAX(total_spent) FROM cust_rev)
)
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       f.film_id, f.title,
       COUNT(r.rental_id)         AS times_rented,
       SUM(p.amount)              AS film_revenue
FROM topc t
JOIN customer c ON c.customer_id = t.customer_id
JOIN rental   r ON r.customer_id = c.customer_id
JOIN payment  p ON p.rental_id   = r.rental_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film      f ON f.film_id      = i.film_id
GROUP BY c.customer_id, customer_name, f.film_id, f.title
ORDER BY film_revenue DESC, times_rented DESC, f.title;

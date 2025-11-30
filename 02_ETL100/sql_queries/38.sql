WITH cnt AS (
  SELECT r.customer_id, COUNT(*) AS total_rentals
  FROM rental r
  GROUP BY r.customer_id
),
topc AS (
  SELECT customer_id
  FROM cnt
  WHERE total_rentals = (SELECT MAX(total_rentals) FROM cnt)
)
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       f.film_id,
       f.title,
       COUNT(r.rental_id) AS times_rented
FROM topc tc
JOIN customer c ON c.customer_id = tc.customer_id
JOIN rental   r ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film      f ON f.film_id = i.film_id
GROUP BY c.customer_id, customer_name, f.film_id, f.title
ORDER BY c.customer_id, times_rented DESC, f.title;

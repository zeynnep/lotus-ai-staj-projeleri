WITH film_cnt AS (
  SELECT f.film_id,
         f.title,
         COUNT(r.rental_id) AS rental_count
  FROM film f
  JOIN inventory i ON i.film_id = f.film_id
  LEFT JOIN rental r ON r.inventory_id = i.inventory_id
  GROUP BY f.film_id, f.title
)
SELECT film_id, title, rental_count
FROM film_cnt
WHERE rental_count = (SELECT MIN(rental_count) FROM film_cnt)
ORDER BY title;

WITH cat_rentals AS (
  SELECT c.category_id,
         c.name AS category_name,
         COUNT(r.rental_id) AS rental_count
  FROM category c
  JOIN film_category fc ON fc.category_id = c.category_id
  JOIN film f           ON f.film_id     = fc.film_id
  JOIN inventory i      ON i.film_id     = f.film_id
  JOIN rental r         ON r.inventory_id = i.inventory_id
  GROUP BY c.category_id, c.name
)
SELECT category_id, category_name, rental_count
FROM cat_rentals
WHERE rental_count = (SELECT MAX(rental_count) FROM cat_rentals)
ORDER BY category_name;

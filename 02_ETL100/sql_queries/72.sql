WITH actor_rentals AS (
  SELECT a.actor_id,
         a.first_name || ' ' || a.last_name AS actor_name,
         COUNT(r.rental_id) AS rental_count
  FROM actor a
  JOIN film_actor fa ON fa.actor_id = a.actor_id
  JOIN inventory i   ON i.film_id   = fa.film_id
  JOIN rental r      ON r.inventory_id = i.inventory_id
  GROUP BY a.actor_id, actor_name
)
SELECT actor_id, actor_name, rental_count
FROM actor_rentals
WHERE rental_count = (SELECT MAX(rental_count) FROM actor_rentals)
ORDER BY actor_name;

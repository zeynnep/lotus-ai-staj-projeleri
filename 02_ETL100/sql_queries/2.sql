SELECT f.film_id,
       f.title,
       GROUP_CONCAT(a.first_name || ' ' || a.last_name, ', ') AS actors
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id, f.title
ORDER BY f.film_id;

SELECT f.film_id,
       f.title,
       COUNT(fa.actor_id) AS actor_count
FROM film AS f
JOIN film_actor AS fa ON fa.film_id = f.film_id
GROUP BY f.film_id, f.title
ORDER BY f.film_id;

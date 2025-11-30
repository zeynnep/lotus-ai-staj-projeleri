WITH actor_cnt AS (
  SELECT a.actor_id,
         a.first_name || ' ' || a.last_name AS actor_name,
         COUNT(fa.film_id) AS film_count
  FROM actor a
  JOIN film_actor fa ON a.actor_id = fa.actor_id
  GROUP BY a.actor_id, actor_name
)
SELECT actor_id, actor_name, film_count
FROM actor_cnt
WHERE film_count = (SELECT MAX(film_count) FROM actor_cnt)
ORDER BY actor_name;

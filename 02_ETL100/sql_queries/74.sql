WITH cat_actor AS (
  SELECT c.category_id,
         c.name AS category_name,
         COUNT(DISTINCT fa.actor_id) AS actor_count
  FROM category c
  JOIN film_category fc ON fc.category_id = c.category_id
  JOIN film f           ON f.film_id = fc.film_id
  JOIN film_actor fa    ON fa.film_id = f.film_id
  GROUP BY c.category_id, c.name
)
SELECT category_id, category_name, actor_count
FROM cat_actor
WHERE actor_count = (SELECT MAX(actor_count) FROM cat_actor)
ORDER BY category_name;

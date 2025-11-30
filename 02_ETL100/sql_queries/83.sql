WITH store_cat AS (
  SELECT s.store_id,
         c.category_id,
         c.name AS category_name,
         COUNT(r.rental_id) AS rental_count
  FROM store s
  JOIN inventory i      ON i.store_id = s.store_id
  JOIN film f           ON f.film_id  = i.film_id
  JOIN film_category fc ON fc.film_id = f.film_id
  JOIN category c       ON c.category_id = fc.category_id
  LEFT JOIN rental r    ON r.inventory_id = i.inventory_id   -- 0 kiralamayı da say
  GROUP BY s.store_id, c.category_id, c.name
),
min_sc AS (
  SELECT store_id, MIN(rental_count) AS mn
  FROM store_cat
  GROUP BY store_id
)
SELECT sc.store_id, sc.category_id, sc.category_name, sc.rental_count
FROM store_cat sc
JOIN min_sc m ON m.store_id = sc.store_id AND sc.rental_count = m.mn
ORDER BY sc.store_id, sc.category_name;

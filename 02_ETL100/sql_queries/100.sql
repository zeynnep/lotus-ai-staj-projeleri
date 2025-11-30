WITH store_cat_rev AS (
  SELECT s.store_id,
         c.category_id,
         c.name AS category_name,
         SUM(p.amount) AS total_revenue
  FROM store s
  JOIN inventory i      ON i.store_id   = s.store_id
  JOIN film f           ON f.film_id    = i.film_id
  JOIN film_category fc ON fc.film_id   = f.film_id
  JOIN category c       ON c.category_id= fc.category_id
  JOIN rental r         ON r.inventory_id = i.inventory_id
  JOIN payment p        ON p.rental_id    = r.rental_id
  GROUP BY s.store_id, c.category_id, c.name
),
best_per_store AS (
  SELECT store_id, MAX(total_revenue) AS mx
  FROM store_cat_rev
  GROUP BY store_id
)
SELECT scr.store_id,
       scr.category_id,
       scr.category_name,
       scr.total_revenue
FROM store_cat_rev scr
JOIN best_per_store b
  ON b.store_id = scr.store_id AND scr.total_revenue = b.mx
ORDER BY scr.store_id, scr.category_name;

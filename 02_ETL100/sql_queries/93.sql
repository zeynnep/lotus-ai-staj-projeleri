WITH film_rev AS (  -- kategori × film bazında gelir (yoksa 0)
  SELECT f.film_id,
         f.title,
         c.category_id,
         c.name AS category_name,
         COALESCE(SUM(p.amount),0) AS total_revenue
  FROM category c
  JOIN film_category fc ON fc.category_id = c.category_id
  JOIN film f           ON f.film_id     = fc.film_id
  LEFT JOIN inventory i ON i.film_id     = f.film_id
  LEFT JOIN rental r    ON r.inventory_id = i.inventory_id
  LEFT JOIN payment p   ON p.rental_id    = r.rental_id
  GROUP BY f.film_id, f.title, c.category_id, c.name
),
min_per_cat AS (
  SELECT category_id, MIN(total_revenue) AS mn
  FROM film_rev
  GROUP BY category_id
)
SELECT fr.film_id, fr.title, fr.category_id, fr.category_name, fr.total_revenue
FROM film_rev fr
JOIN min_per_cat m ON m.category_id = fr.category_id AND fr.total_revenue = m.mn
ORDER BY fr.category_name, fr.title;

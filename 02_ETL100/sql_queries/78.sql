WITH cat_rev AS (
  SELECT c.category_id,
         c.name AS category_name,
         SUM(p.amount) AS total_revenue
  FROM category c
  JOIN film_category fc ON fc.category_id = c.category_id
  JOIN film f           ON f.film_id     = fc.film_id
  JOIN inventory i      ON i.film_id     = f.film_id
  JOIN rental r         ON r.inventory_id = i.inventory_id
  JOIN payment p        ON p.rental_id    = r.rental_id
  GROUP BY c.category_id, c.name
)
SELECT category_id, category_name, total_revenue
FROM cat_rev
WHERE total_revenue = (SELECT MAX(total_revenue) FROM cat_rev)
ORDER BY category_name;

WITH film_rev AS (
  SELECT f.film_id,
         f.title,
         c.category_id,
         c.name AS category_name,
         SUM(p.amount) AS total_revenue
  FROM film f
  JOIN film_category fc ON fc.film_id = f.film_id
  JOIN category c       ON c.category_id = fc.category_id
  JOIN inventory i      ON i.film_id = f.film_id
  JOIN rental r         ON r.inventory_id = i.inventory_id
  JOIN payment p        ON p.rental_id = r.rental_id
  GROUP BY f.film_id, f.title, c.category_id, c.name
),
best_cat AS (
  SELECT category_id, MAX(total_revenue) AS mx
  FROM film_rev
  GROUP BY category_id
)
SELECT fr.film_id, fr.title, fr.category_id, fr.category_name, fr.total_revenue
FROM film_rev fr
JOIN best_cat b ON b.category_id = fr.category_id AND b.mx = fr.total_revenue
ORDER BY fr.category_name, fr.title;

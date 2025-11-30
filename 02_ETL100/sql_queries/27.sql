WITH film_rev AS (
  SELECT c.category_id, c.name AS category_name, f.film_id, f.title,
         SUM(p.amount) AS total_revenue
  FROM category c
  JOIN film_category fc ON c.category_id = fc.category_id
  JOIN film f           ON fc.film_id = f.film_id
  JOIN inventory i      ON f.film_id = i.film_id
  JOIN rental r         ON i.inventory_id = r.inventory_id
  JOIN payment p        ON r.rental_id = p.rental_id
  GROUP BY c.category_id, c.name, f.film_id, f.title
),
best AS (
  SELECT category_id, MAX(total_revenue) AS mx FROM film_rev GROUP BY category_id
)
SELECT fr.category_id, fr.category_name, fr.film_id, fr.title, fr.total_revenue
FROM film_rev fr
JOIN best b USING(category_id)
WHERE fr.total_revenue = b.mx
ORDER BY fr.category_name, fr.title;



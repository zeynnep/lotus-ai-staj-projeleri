WITH film_cnt AS (
  SELECT c.category_id,
         c.name AS category_name,
         f.film_id,
         f.title,
         COUNT(r.rental_id) AS rental_count
  FROM category c
  JOIN film_category fc ON c.category_id = fc.category_id
  JOIN film f           ON fc.film_id = f.film_id
  LEFT JOIN inventory i ON f.film_id = i.film_id
  LEFT JOIN rental r    ON i.inventory_id = r.inventory_id
  GROUP BY c.category_id, c.name, f.film_id, f.title
),
mins AS (
  SELECT category_id, MIN(rental_count) AS mn
  FROM film_cnt
  GROUP BY category_id
)
SELECT fc.category_id, fc.category_name, fc.film_id, fc.title, fc.rental_count
FROM film_cnt fc
JOIN mins m USING(category_id)
WHERE fc.rental_count = m.mn
ORDER BY fc.category_name, fc.title;

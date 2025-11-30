WITH film_rev AS (
  SELECT f.film_id, f.title, SUM(p.amount) AS total_revenue
  FROM film f
  JOIN inventory i ON i.film_id = f.film_id
  JOIN rental   r  ON r.inventory_id = i.inventory_id
  JOIN payment  p  ON p.rental_id    = r.rental_id
  GROUP BY f.film_id, f.title
),
top5 AS (
  SELECT film_id, title, total_revenue
  FROM film_rev
  ORDER BY total_revenue DESC, title
  LIMIT 5
),
film_cities AS (               -- DISTINCT şehir listesi
  SELECT i.film_id, ci.city
  FROM inventory i
  JOIN store   s ON s.store_id   = i.store_id
  JOIN address a ON a.address_id = s.address_id
  JOIN city    ci ON ci.city_id  = a.city_id
  GROUP BY i.film_id, ci.city
)
SELECT t.film_id, t.title, t.total_revenue,
       GROUP_CONCAT(fc.city, ', ') AS cities
FROM top5 t
LEFT JOIN film_cities fc ON fc.film_id = t.film_id
GROUP BY t.film_id, t.title, t.total_revenue
ORDER BY t.total_revenue DESC, t.title;

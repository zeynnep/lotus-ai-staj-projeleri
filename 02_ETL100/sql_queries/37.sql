WITH film_rev AS (
  SELECT f.film_id, f.title,
         COALESCE(SUM(p.amount), 0) AS total_revenue
  FROM film f
  LEFT JOIN inventory i ON i.film_id = f.film_id
  LEFT JOIN rental   r  ON r.inventory_id = i.inventory_id
  LEFT JOIN payment  p  ON p.rental_id    = r.rental_id
  GROUP BY f.film_id, f.title
),
least5 AS (
  SELECT film_id, title, total_revenue
  FROM film_rev
  ORDER BY total_revenue ASC, title
  LIMIT 5
),
film_cities AS (                 -- DISTINCT şehir listesi
  SELECT i.film_id, ci.city
  FROM inventory i
  JOIN store   s ON s.store_id   = i.store_id
  JOIN address a ON a.address_id = s.address_id
  JOIN city    ci ON ci.city_id  = a.city_id
  GROUP BY i.film_id, ci.city
)
SELECT l.film_id, l.title, l.total_revenue,
       GROUP_CONCAT(fc.city, ', ') AS cities
FROM least5 l
LEFT JOIN film_cities fc ON fc.film_id = l.film_id
GROUP BY l.film_id, l.title, l.total_revenue
ORDER BY l.total_revenue ASC, l.title;

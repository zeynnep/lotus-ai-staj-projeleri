WITH film_cnt AS (
  SELECT f.film_id, f.title, COUNT(r.rental_id) AS rental_count
  FROM film f
  LEFT JOIN inventory i ON i.film_id = f.film_id
  LEFT JOIN rental   r  ON r.inventory_id = i.inventory_id
  GROUP BY f.film_id, f.title
),
least5 AS (
  SELECT film_id, title, rental_count
  FROM film_cnt
  ORDER BY rental_count ASC, title
  LIMIT 5
),
film_cities AS (
  SELECT i.film_id, ci.city
  FROM inventory i
  LEFT JOIN store   s ON s.store_id = i.store_id
  LEFT JOIN address a ON a.address_id = s.address_id
  LEFT JOIN city    ci ON ci.city_id = a.city_id
  GROUP BY i.film_id, ci.city        -- DISTINCT etkisi
)
SELECT l.film_id,
       l.title,
       l.rental_count,
       GROUP_CONCAT(fc.city, ', ') AS cities
FROM least5 l
LEFT JOIN film_cities fc ON fc.film_id = l.film_id
GROUP BY l.film_id, l.title, l.rental_count
ORDER BY l.rental_count ASC, l.title;


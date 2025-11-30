WITH film_dur AS (   -- film bazında en uzun süre
  SELECT f.film_id, f.title,
         MAX(julianday(r.return_date) - julianday(r.rental_date)) AS max_days
  FROM film f
  JOIN inventory i ON i.film_id = f.film_id
  JOIN rental   r  ON r.inventory_id = i.inventory_id
  WHERE r.return_date IS NOT NULL
  GROUP BY f.film_id, f.title
),
longest AS (        -- en uzun süreye sahip film(ler)
  SELECT film_id, title, max_days
  FROM film_dur
  WHERE max_days = (SELECT MAX(max_days) FROM film_dur)
)
SELECT l.film_id, l.title, l.max_days,
       s.store_id
FROM longest l
JOIN inventory i ON i.film_id = l.film_id
JOIN rental   r  ON r.inventory_id = i.inventory_id
JOIN store    s  ON s.store_id = i.store_id
ORDER BY s.store_id;

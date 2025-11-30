WITH film_cnt AS (                -- film bazında toplam kiralama
  SELECT f.film_id, f.title, COUNT(r.rental_id) AS film_rentals
  FROM film f
  JOIN inventory i ON i.film_id = f.film_id
  JOIN rental   r  ON r.inventory_id = i.inventory_id
  GROUP BY f.film_id, f.title
),
top_films AS (                    -- en yüksek sayıya sahip film(ler)
  SELECT film_id, title, film_rentals
  FROM film_cnt
  WHERE film_rentals = (SELECT MAX(film_rentals) FROM film_cnt)
)
SELECT tf.film_id,
       tf.title,
       tf.film_rentals,
       AVG(julianday(r.return_date) - julianday(r.rental_date)) AS avg_rental_days
FROM top_films tf
JOIN inventory i ON i.film_id = tf.film_id
JOIN rental   r  ON r.inventory_id = i.inventory_id
WHERE r.return_date IS NOT NULL
GROUP BY tf.film_id, tf.title, tf.film_rentals
ORDER BY tf.title;

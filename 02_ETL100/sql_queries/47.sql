WITH film_cnt AS (                     -- film bazında toplam kiralama
  SELECT f.film_id, f.title, COUNT(r.rental_id) AS film_rentals
  FROM film f
  JOIN inventory i ON i.film_id = f.film_id
  JOIN rental   r  ON r.inventory_id = i.inventory_id
  GROUP BY f.film_id, f.title
),
top_films AS (                          -- en çok kiralanan film(ler)
  SELECT film_id, title, film_rentals
  FROM film_cnt
  WHERE film_rentals = (SELECT MAX(film_rentals) FROM film_cnt)
),
store_cnt AS (                          -- bu film(ler) için mağaza bazında adet
  SELECT tf.film_id, tf.title, tf.film_rentals,
         s.store_id,
         COUNT(r.rental_id) AS rentals_in_store
  FROM top_films tf
  JOIN inventory i ON i.film_id = tf.film_id
  JOIN rental   r  ON r.inventory_id = i.inventory_id
  JOIN store    s  ON s.store_id     = i.store_id
  GROUP BY tf.film_id, tf.title, tf.film_rentals, s.store_id
),
best_store AS (                         -- her film için en yüksek mağaza adedi
  SELECT film_id, MAX(rentals_in_store) AS mx
  FROM store_cnt
  GROUP BY film_id
)
SELECT sc.film_id, sc.title, sc.film_rentals,
       sc.store_id, sc.rentals_in_store
FROM store_cnt sc
JOIN best_store bs USING(film_id)
WHERE sc.rentals_in_store = bs.mx
ORDER BY sc.title, sc.store_id;

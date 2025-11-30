WITH film_rev AS (  -- film bazında toplam gelir
  SELECT f.film_id, f.title, SUM(p.amount) AS total_revenue
  FROM film f
  JOIN inventory i ON i.film_id = f.film_id
  JOIN rental   r  ON r.inventory_id = i.inventory_id
  JOIN payment  p  ON p.rental_id    = r.rental_id
  GROUP BY f.film_id, f.title
),
top_film AS (       -- en yüksek gelirli film(ler)
  SELECT film_id, title, total_revenue
  FROM film_rev
  WHERE total_revenue = (SELECT MAX(total_revenue) FROM film_rev)
),
store_rev AS (      -- bu film(ler) için mağaza bazında gelir ve adet
  SELECT tf.film_id, tf.title, tf.total_revenue,
         s.store_id,
         SUM(p.amount)      AS revenue_in_store,
         COUNT(r.rental_id) AS rentals_in_store
  FROM top_film tf
  JOIN inventory i ON i.film_id = tf.film_id
  JOIN rental   r  ON r.inventory_id = i.inventory_id
  JOIN payment  p  ON p.rental_id    = r.rental_id
  JOIN store    s  ON s.store_id     = i.store_id
  GROUP BY tf.film_id, tf.title, tf.total_revenue, s.store_id
),
best_store AS (     -- film başına en yüksek mağaza geliri
  SELECT film_id, MAX(revenue_in_store) AS mx
  FROM store_rev
  GROUP BY film_id
)
SELECT sr.film_id, sr.title, sr.total_revenue,
       sr.store_id, sr.revenue_in_store, sr.rentals_in_store
FROM store_rev sr
JOIN best_store b USING(film_id)
WHERE sr.revenue_in_store = b.mx
ORDER BY sr.title, sr.store_id;

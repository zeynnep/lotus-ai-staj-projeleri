WITH film_rev AS (  -- film bazında toplam gelir (yoksa 0)
  SELECT f.film_id, f.title,
         COALESCE(SUM(p.amount),0) AS total_revenue
  FROM film f
  LEFT JOIN inventory i ON i.film_id = f.film_id
  LEFT JOIN rental   r  ON r.inventory_id = i.inventory_id
  LEFT JOIN payment  p  ON p.rental_id    = r.rental_id
  GROUP BY f.film_id, f.title
),
min_film AS (       -- en düşük gelirli film(ler)
  SELECT film_id, title, total_revenue
  FROM film_rev
  WHERE total_revenue = (SELECT MIN(total_revenue) FROM film_rev)
),
store_rev AS (      -- mağaza bazında gelir ve adet (yoksa 0)
  SELECT mf.film_id, mf.title, mf.total_revenue,
         s.store_id,
         COALESCE(SUM(p.amount),0)      AS revenue_in_store,
         COUNT(r.rental_id)             AS rentals_in_store
  FROM min_film mf
  LEFT JOIN inventory i ON i.film_id = mf.film_id
  LEFT JOIN store    s  ON s.store_id = i.store_id
  LEFT JOIN rental   r  ON r.inventory_id = i.inventory_id
  LEFT JOIN payment  p  ON p.rental_id    = r.rental_id
  GROUP BY mf.film_id, mf.title, mf.total_revenue, s.store_id
),
best_store AS (     -- film başına en yüksek mağaza geliri (beraberlikler dahil)
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
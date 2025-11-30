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
staff_stats AS (    -- bu film(ler)i hangi çalışan kaç kez ve ne kadar gelirle kiralamış
  SELECT tf.film_id, tf.title, tf.total_revenue,
         s.staff_id,
         s.first_name || ' ' || s.last_name AS staff_name,
         COUNT(r.rental_id)                  AS rentals_by_staff,
         SUM(p.amount)                       AS revenue_by_staff
  FROM top_film tf
  JOIN inventory i ON i.film_id = tf.film_id
  JOIN rental   r  ON r.inventory_id = i.inventory_id
  JOIN payment  p  ON p.rental_id    = r.rental_id
  JOIN staff    s  ON s.staff_id     = r.staff_id
  GROUP BY tf.film_id, tf.title, tf.total_revenue, s.staff_id, staff_name
)
SELECT *
FROM staff_stats
ORDER BY title, revenue_by_staff DESC, rentals_by_staff DESC, staff_name;

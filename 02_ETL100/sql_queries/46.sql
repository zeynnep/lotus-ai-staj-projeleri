WITH film_rev AS (                 -- yalnız kiralanmış filmler (ödemeli)
  SELECT f.film_id, f.title, SUM(p.amount) AS total_revenue
  FROM film f
  JOIN inventory i ON i.film_id = f.film_id
  JOIN rental   r  ON r.inventory_id = i.inventory_id
  JOIN payment  p  ON p.rental_id    = r.rental_id
  GROUP BY f.film_id, f.title
),
min_film AS (                      -- en düşük gelirli film(ler)
  SELECT film_id, title, total_revenue
  FROM film_rev
  WHERE total_revenue = (SELECT MIN(total_revenue) FROM film_rev)
),
staff_stats AS (                   -- çalışan bazında adet + gelir
  SELECT mf.film_id, mf.title, mf.total_revenue,
         s.staff_id,
         s.first_name || ' ' || s.last_name AS staff_name,
         COUNT(r.rental_id) AS rentals_by_staff,
         SUM(p.amount)      AS revenue_by_staff
  FROM min_film mf
  JOIN inventory i ON i.film_id = mf.film_id
  JOIN rental   r  ON r.inventory_id = i.inventory_id
  JOIN payment  p  ON p.rental_id    = r.rental_id
  JOIN staff    s  ON s.staff_id     = r.staff_id
  GROUP BY mf.film_id, mf.title, mf.total_revenue, s.staff_id, staff_name
)
SELECT *
FROM staff_stats
ORDER BY title, revenue_by_staff ASC, rentals_by_staff ASC, staff_name;

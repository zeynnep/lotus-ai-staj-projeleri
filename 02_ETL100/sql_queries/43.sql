WITH film_cnt AS (  -- film bazında toplam kiralama
  SELECT f.film_id, f.title, COUNT(r.rental_id) AS film_rentals
  FROM film f
  JOIN inventory i ON i.film_id = f.film_id
  JOIN rental   r ON r.inventory_id = i.inventory_id
  GROUP BY f.film_id, f.title
),
top_films AS (     -- en çok kiralanan film(ler)
  SELECT film_id, title, film_rentals
  FROM film_cnt
  WHERE film_rentals = (SELECT MAX(film_rentals) FROM film_cnt)
),
staff_cnt AS (     -- bu film(ler)i hangi çalışan kaç kez işlemiş?
  SELECT tf.film_id, tf.title, tf.film_rentals,
         s.staff_id,
         s.first_name || ' ' || s.last_name AS staff_name,
         COUNT(r.rental_id) AS rentals_by_staff
  FROM top_films tf
  JOIN inventory i ON i.film_id = tf.film_id
  JOIN rental   r ON r.inventory_id = i.inventory_id
  JOIN staff    s ON s.staff_id = r.staff_id
  GROUP BY tf.film_id, tf.title, tf.film_rentals, s.staff_id, staff_name
),
best_staff AS (    -- her film için en çok işlemi yapan çalışan(lar)
  SELECT film_id, MAX(rentals_by_staff) AS mx
  FROM staff_cnt
  GROUP BY film_id
)
SELECT sc.film_id, sc.title, sc.film_rentals,
       sc.staff_id, sc.staff_name, sc.rentals_by_staff
FROM staff_cnt sc
JOIN best_staff bs USING(film_id)
WHERE sc.rentals_by_staff = bs.mx
ORDER BY sc.title, sc.staff_name;
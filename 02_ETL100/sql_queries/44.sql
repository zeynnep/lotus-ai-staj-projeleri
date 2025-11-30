WITH film_cnt AS (  -- sadece en az 1 kez kiralanan filmler
  SELECT f.film_id, f.title, COUNT(r.rental_id) AS film_rentals
  FROM film f
  JOIN inventory i ON i.film_id = f.film_id
  JOIN rental   r ON r.inventory_id = i.inventory_id
  GROUP BY f.film_id, f.title
),
min_films AS (     -- en az kiralanan film(ler)
  SELECT film_id, title, film_rentals
  FROM film_cnt
  WHERE film_rentals = (SELECT MIN(film_rentals) FROM film_cnt)
),
staff_cnt AS (     -- bu film(ler)i hangi çalışan kaç kez işlemiş?
  SELECT mf.film_id, mf.title, mf.film_rentals,
         s.staff_id,
         s.first_name || ' ' || s.last_name AS staff_name,
         COUNT(r.rental_id) AS rentals_by_staff
  FROM min_films mf
  JOIN inventory i ON i.film_id = mf.film_id
  JOIN rental   r ON r.inventory_id = i.inventory_id
  JOIN staff    s ON s.staff_id = r.staff_id
  GROUP BY mf.film_id, mf.title, mf.film_rentals, s.staff_id, staff_name
)
SELECT *
FROM staff_cnt
ORDER BY title, staff_name;


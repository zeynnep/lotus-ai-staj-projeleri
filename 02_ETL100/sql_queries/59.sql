WITH film_cnt AS (                -- film bazında toplam kiralama
  SELECT f.film_id, f.title, COUNT(r.rental_id) AS film_rentals
  FROM film f
  JOIN inventory i ON i.film_id = f.film_id
  LEFT JOIN rental r ON r.inventory_id = i.inventory_id
  GROUP BY f.film_id, f.title
),
min_films AS (                    -- en düşük sayıya sahip film(ler)
  SELECT film_id, title, film_rentals
  FROM film_cnt
  WHERE film_rentals = (SELECT MIN(film_rentals) FROM film_cnt)
)
SELECT mf.film_id,
       mf.title,
       mf.film_rentals,
       AVG(julianday(r.return_date) - julianday(r.rental_date)) AS avg_rental_days
FROM min_films mf
JOIN inventory i ON i.film_id = mf.film_id
JOIN rental   r  ON r.inventory_id = i.inventory_id
WHERE r.return_date IS NOT NULL
GROUP BY mf.film_id, mf.title, mf.film_rentals
ORDER BY mf.title;

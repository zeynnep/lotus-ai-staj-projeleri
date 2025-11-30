WITH cat_cnt AS (   -- tür bazında toplam kiralama
  SELECT c.category_id, c.name AS category_name, COUNT(r.rental_id) AS rental_count
  FROM category c
  JOIN film_category fc ON c.category_id = fc.category_id
  JOIN film f           ON fc.film_id = f.film_id
  JOIN inventory i      ON f.film_id = i.film_id
  JOIN rental r         ON r.inventory_id = i.inventory_id
  GROUP BY c.category_id, c.name
),
top_cat AS (        -- en çok kiralanan tür(ler)
  SELECT category_id, category_name, rental_count
  FROM cat_cnt
  WHERE rental_count = (SELECT MAX(rental_count) FROM cat_cnt)
)
SELECT f.film_id, f.title, tc.category_name, COUNT(r.rental_id) AS film_rentals
FROM top_cat tc
JOIN film_category fc ON tc.category_id = fc.category_id
JOIN film f           ON fc.film_id = f.film_id
JOIN inventory i      ON f.film_id = i.film_id
JOIN rental r         ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title, tc.category_name
ORDER BY film_rentals DESC, f.title;

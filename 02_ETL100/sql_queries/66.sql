WITH cat_cnt AS (       -- kategori bazında toplam kiralama
  SELECT c.category_id, c.name AS category_name,
         COUNT(r.rental_id) AS rental_count
  FROM category c
  JOIN film_category fc ON c.category_id = fc.category_id
  JOIN film f           ON f.film_id = fc.film_id
  JOIN inventory i      ON i.film_id = f.film_id
  JOIN rental r         ON r.inventory_id = i.inventory_id
  GROUP BY c.category_id, c.name
),
top_cat AS (            -- en çok kiralanan kategori(ler)
  SELECT category_id, category_name
  FROM cat_cnt
  WHERE rental_count = (SELECT MAX(rental_count) FROM cat_cnt)
)
SELECT f.film_id, f.title, tc.category_name, COUNT(r.rental_id) AS film_rentals
FROM top_cat tc
JOIN film_category fc ON tc.category_id = fc.category_id
JOIN film f           ON f.film_id = fc.film_id
JOIN inventory i      ON i.film_id = f.film_id
JOIN rental r         ON r.inventory_id = i.inventory_id
GROUP BY f.film_id, f.title, tc.category_name
ORDER BY film_rentals DESC, f.title;

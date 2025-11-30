WITH cat_cnt AS (       -- kategori bazında toplam kiralama
  SELECT c.category_id, c.name AS category_name,
         COUNT(r.rental_id) AS rental_count
  FROM category c
  JOIN film_category fc ON c.category_id = fc.category_id
  JOIN film f           ON f.film_id = fc.film_id
  JOIN inventory i      ON i.film_id = f.film_id
  LEFT JOIN rental r    ON r.inventory_id = i.inventory_id
  GROUP BY c.category_id, c.name
),
min_cat AS (            -- en az kiralanan kategori(ler)
  SELECT category_id, category_name
  FROM cat_cnt
  WHERE rental_count = (SELECT MIN(rental_count) FROM cat_cnt)
)
SELECT f.film_id, f.title, mc.category_name,
       COUNT(r.rental_id) AS film_rentals
FROM min_cat mc
JOIN film_category fc ON mc.category_id = fc.category_id
JOIN film f           ON f.film_id = fc.film_id
JOIN inventory i      ON i.film_id = f.film_id
LEFT JOIN rental r    ON r.inventory_id = i.inventory_id
GROUP BY f.film_id, f.title, mc.category_name
ORDER BY film_rentals ASC, f.title;

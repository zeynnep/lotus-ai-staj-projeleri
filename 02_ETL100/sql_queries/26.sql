-- Kategori içindeki en çok kiralanan filmi seç
SELECT x.category_id,x.category_name,x.film_id,x.title,x.rental_count
FROM (
  SELECT c.category_id,c.name AS category_name,f.film_id,f.title,
         COUNT(r.rental_id) AS rental_count
  FROM category c
  JOIN film_category fc ON c.category_id = fc.category_id
  JOIN film f           ON fc.film_id = f.film_id
  JOIN inventory i      ON f.film_id = i.film_id
  JOIN rental r         ON i.inventory_id = r.inventory_id
  GROUP BY c.category_id, c.name, f.film_id, f.title
) AS x
WHERE x.rental_count = (
  SELECT MAX(cnt)
  FROM (
    SELECT COUNT(r2.rental_id) AS cnt
    FROM film_category fc2
    JOIN inventory i2 ON fc2.film_id = i2.film_id
    JOIN rental r2    ON i2.inventory_id = r2.inventory_id
    WHERE fc2.category_id = x.category_id
    GROUP BY fc2.film_id
  )
)
ORDER BY x.category_name, x.title;

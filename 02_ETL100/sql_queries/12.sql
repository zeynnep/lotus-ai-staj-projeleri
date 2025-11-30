SELECT c.name  AS category_name,
       f.film_id,
       f.title,
       COUNT(r.rental_id) AS rental_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f           ON fc.film_id = f.film_id
JOIN inventory i      ON f.film_id = i.film_id
JOIN rental r         ON i.inventory_id = r.inventory_id
GROUP BY c.name, f.film_id, f.title
ORDER BY c.name, rental_count DESC, f.title;

SELECT f.film_id,
       f.title,
       COUNT(r.rental_id) AS rental_count
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r    ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY rental_count ASC, f.title
LIMIT 5;

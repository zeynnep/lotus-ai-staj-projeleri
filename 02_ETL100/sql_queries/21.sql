SELECT f.film_id,
       f.title,
       MAX(julianday(r.return_date) - julianday(r.rental_date)) AS max_rental_days
FROM film f
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r    ON r.inventory_id = i.inventory_id
WHERE r.return_date IS NOT NULL
GROUP BY f.film_id, f.title
ORDER BY max_rental_days DESC;

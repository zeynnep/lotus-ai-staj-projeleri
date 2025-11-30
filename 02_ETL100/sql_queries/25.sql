SELECT f.film_id,
       f.title,
       AVG(julianday(r.return_date) - julianday(r.rental_date)) AS avg_rental_days
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r    ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
GROUP BY f.film_id, f.title
ORDER BY avg_rental_days DESC;

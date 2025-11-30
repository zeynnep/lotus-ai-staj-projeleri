SELECT f.film_id,
       f.title,
       MIN(julianday(r.return_date) - julianday(r.rental_date)) AS min_days
FROM film f
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r    ON r.inventory_id = i.inventory_id
WHERE r.return_date IS NOT NULL
GROUP BY f.film_id, f.title
ORDER BY min_days ASC, f.title;

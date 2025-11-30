SELECT COUNT(*) AS missing_film_count
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
WHERE i.film_id IS NULL;

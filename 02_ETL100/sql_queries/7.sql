SELECT f.film_id,
       f.title,
       f.rental_rate
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
WHERE i.film_id IS NULL;

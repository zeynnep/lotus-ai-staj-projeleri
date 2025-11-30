SELECT f.film_id,
       f.title,
       COUNT(r.rental_id) AS rental_count,
       SUM(p.amount) AS total_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r    ON i.inventory_id = r.inventory_id
JOIN payment p   ON r.rental_id = p.rental_id
GROUP BY f.film_id, f.title
ORDER BY rental_count DESC;

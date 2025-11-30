SELECT c.name            AS category_name,
       DATE(r.rental_date) AS rental_date,
       COUNT(r.rental_id) AS rental_count,
       SUM(p.amount)     AS total_revenue
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f          ON fc.film_id = f.film_id
JOIN inventory i     ON f.film_id = i.film_id
JOIN rental r        ON i.inventory_id = r.inventory_id
JOIN payment p       ON r.rental_id = p.rental_id
GROUP BY c.name, DATE(r.rental_date)
ORDER BY c.name, rental_date;

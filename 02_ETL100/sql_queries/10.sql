SELECT c.name AS category_name,f.title,COUNT(r.rental_id) AS rental_count,
       SUM(p.amount) AS total_revenue
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f           ON fc.film_id = f.film_id
JOIN inventory i      ON f.film_id = i.film_id
JOIN rental r         ON i.inventory_id = r.inventory_id
JOIN payment p        ON r.rental_id = p.rental_id
GROUP BY c.name, f.title
HAVING COUNT(r.rental_id) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(r2.rental_id) AS cnt
        FROM film_category fc2
        JOIN film f2      ON fc2.film_id = f2.film_id
        JOIN inventory i2 ON f2.film_id = i2.film_id
        JOIN rental r2    ON i2.inventory_id = r2.inventory_id
        WHERE fc2.category_id = c.category_id
        GROUP BY f2.film_id
    )
)
ORDER BY category_name;

-- Özet: film bazında sayılar
SELECT f.film_id, f.title,
       SUM(CASE WHEN DATE(r.return_date) > DATE(r.rental_date, '+'||f.rental_duration||' days') THEN 1 ELSE 0 END) AS gec,
       SUM(CASE WHEN DATE(r.return_date) < DATE(r.rental_date, '+'||f.rental_duration||' days') THEN 1 ELSE 0 END) AS erken,
       SUM(CASE WHEN DATE(r.return_date) = DATE(r.rental_date, '+'||f.rental_duration||' days') THEN 1 ELSE 0 END) AS zamaninda
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f      ON i.film_id = f.film_id
WHERE r.return_date IS NOT NULL
GROUP BY f.film_id, f.title
ORDER BY (gec+erken+zamaninda) DESC, f.title;

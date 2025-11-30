SELECT s.store_id,
       SUM(julianday(r.return_date) - julianday(r.rental_date)) AS total_days
FROM store s
JOIN inventory i ON i.store_id = s.store_id
JOIN rental   r  ON r.inventory_id = i.inventory_id
WHERE r.return_date IS NOT NULL
GROUP BY s.store_id
ORDER BY s.store_id;

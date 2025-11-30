WITH last_tx AS (
  SELECT i.inventory_id, i.film_id, MAX(r.rental_date) AS last_rental_date
  FROM inventory i
  LEFT JOIN rental r ON r.inventory_id = i.inventory_id
  GROUP BY i.inventory_id
),
last_pair AS (
  SELECT lt.inventory_id, lt.film_id, r.return_date
  FROM last_tx lt
  LEFT JOIN rental r
    ON r.inventory_id = lt.inventory_id
   AND r.rental_date  = lt.last_rental_date
)
SELECT f.film_id,
       f.title,
       AVG(julianday('now') - julianday(lp.return_date)) AS avg_shelf_days,
       COUNT(*) AS copies_on_shelf
FROM last_pair lp
JOIN film f ON f.film_id = lp.film_id
WHERE lp.return_date IS NOT NULL               -- rafta olan kopyalar
GROUP BY f.film_id, f.title
ORDER BY avg_shelf_days DESC
LIMIT 10;


WITH store_cnt AS (
  SELECT s.store_id, COUNT(r.rental_id) AS rental_count
  FROM store s
  JOIN inventory i ON i.store_id = s.store_id
  JOIN rental   r  ON r.inventory_id = i.inventory_id
  GROUP BY s.store_id
)
SELECT store_id, rental_count
FROM store_cnt
WHERE rental_count = (SELECT MAX(rental_count) FROM store_cnt)
ORDER BY store_id;

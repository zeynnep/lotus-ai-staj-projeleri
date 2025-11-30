WITH store_rev AS (
  SELECT s.store_id,
         SUM(p.amount) AS total_revenue
  FROM store s
  JOIN inventory i ON i.store_id = s.store_id
  JOIN rental   r  ON r.inventory_id = i.inventory_id
  JOIN payment  p  ON p.rental_id    = r.rental_id
  GROUP BY s.store_id
)
SELECT store_id, total_revenue
FROM store_rev
WHERE total_revenue = (SELECT MAX(total_revenue) FROM store_rev)
ORDER BY store_id;

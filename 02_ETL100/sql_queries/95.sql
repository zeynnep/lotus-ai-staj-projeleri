WITH store_rev AS (
  SELECT s.store_id,
         COALESCE(SUM(p.amount), 0) AS total_revenue
  FROM store s
  LEFT JOIN inventory i ON i.store_id = s.store_id
  LEFT JOIN rental   r  ON r.inventory_id = i.inventory_id
  LEFT JOIN payment  p  ON p.rental_id    = r.rental_id
  GROUP BY s.store_id
)
SELECT store_id, total_revenue
FROM store_rev
WHERE total_revenue = (SELECT MIN(total_revenue) FROM store_rev)
ORDER BY store_id;

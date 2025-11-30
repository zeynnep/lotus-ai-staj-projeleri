WITH nr AS (
  SELECT r.customer_id, COUNT(*) AS not_returned
  FROM rental r
  WHERE r.return_date IS NULL
  GROUP BY r.customer_id
)
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       nr.not_returned
FROM nr
JOIN customer c ON c.customer_id = nr.customer_id
WHERE nr.not_returned = (SELECT MAX(not_returned) FROM nr)
ORDER BY c.customer_id;

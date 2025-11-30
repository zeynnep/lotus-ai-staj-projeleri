WITH cust_cnt AS (                -- müşteri başına kiralama adedi
  SELECT r.customer_id, COUNT(*) AS total_rentals
  FROM rental r
  GROUP BY r.customer_id
),
topc AS (                         -- en çok kiralayan müşteri(ler)
  SELECT customer_id, total_rentals
  FROM cust_cnt
  WHERE total_rentals = (SELECT MAX(total_rentals) FROM cust_cnt)
)
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       t.total_rentals,
       AVG(p.amount) AS avg_payment
FROM topc t
JOIN customer c ON c.customer_id = t.customer_id
JOIN payment  p ON p.customer_id = t.customer_id
GROUP BY c.customer_id, customer_name, t.total_rentals
ORDER BY avg_payment DESC;

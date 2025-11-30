WITH cust_rev AS (                      -- müşteri toplam harcama
  SELECT p.customer_id, COALESCE(SUM(p.amount),0) AS total_spent
  FROM payment p
  GROUP BY p.customer_id
),
minc AS (                               -- en az harcayan müşteri(ler)
  SELECT customer_id
  FROM cust_rev
  WHERE total_spent = (SELECT MIN(total_spent) FROM cust_rev)
)
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       AVG(p.amount) AS avg_payment
FROM minc m
JOIN customer c ON c.customer_id = m.customer_id
LEFT JOIN payment p ON p.customer_id = m.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY avg_payment ASC;

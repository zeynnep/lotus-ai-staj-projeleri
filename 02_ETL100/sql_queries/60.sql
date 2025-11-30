WITH cust_rev AS (                       -- müşteri toplam harcama
  SELECT p.customer_id, SUM(p.amount) AS total_spent
  FROM payment p
  GROUP BY p.customer_id
),
topc AS (                                -- en çok harcayan müşteri(ler)
  SELECT customer_id
  FROM cust_rev
  WHERE total_spent = (SELECT MAX(total_spent) FROM cust_rev)
)
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       AVG(p.amount) AS avg_payment       -- ortalama ödeme (işlem başına)
FROM topc t
JOIN payment p ON p.customer_id = t.customer_id
JOIN customer c ON c.customer_id = t.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY avg_payment DESC;

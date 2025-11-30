WITH cust_cnt AS (                             -- tüm müşteriler için kiralama adedi
  SELECT c.customer_id,
         c.first_name || ' ' || c.last_name AS customer_name,
         COUNT(r.rental_id) AS total_rentals
  FROM customer c
  LEFT JOIN rental r ON r.customer_id = c.customer_id
  GROUP BY c.customer_id, customer_name
),
minc AS (                                       -- en az kiralayan(lar)
  SELECT customer_id, customer_name, total_rentals
  FROM cust_cnt
  WHERE total_rentals = (SELECT MIN(total_rentals) FROM cust_cnt)
)
SELECT m.customer_id,
       m.customer_name,
       m.total_rentals,
       AVG(p.amount) AS avg_payment            -- ödeme yoksa NULL döner
FROM minc m
LEFT JOIN payment p ON p.customer_id = m.customer_id
GROUP BY m.customer_id, m.customer_name, m.total_rentals
ORDER BY avg_payment ASC;

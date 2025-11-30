WITH cust_rev AS (         D
  SELECT c.customer_id,
         c.first_name || ' ' || c.last_name AS customer_name,
         COALESCE(SUM(p.amount),0) AS total_spent
  FROM customer c
  LEFT JOIN payment p ON p.customer_id = c.customer_id
  GROUP BY c.customer_id, customer_name
),
mincust AS (                -- en az harcayan(lar)
  SELECT customer_id, customer_name
  FROM cust_rev
  WHERE total_spent = (SELECT MIN(total_spent) FROM cust_rev)
),
cust_cat AS (               -- bu müşteri(ler)in tür bazında kiralama adedi
  SELECT m.customer_id,
         m.customer_name,
         c.name AS category_name,
         COUNT(*) AS rentals_in_cat
  FROM mincust m
  JOIN rental r    ON r.customer_id   = m.customer_id
  JOIN inventory i ON i.inventory_id  = r.inventory_id
  JOIN film_category fc ON fc.film_id = i.film_id
  JOIN category c       ON c.category_id = fc.category_id
  GROUP BY m.customer_id, m.customer_name, c.name
),
best AS (                   -- her müşteri için maksimum tür adedi
  SELECT customer_id, MAX(rentals_in_cat) AS mx
  FROM cust_cat
  GROUP BY customer_id
)
SELECT cc.customer_id,
       cc.customer_name,
       cc.category_name,
       cc.rentals_in_cat
FROM cust_cat cc
JOIN best b USING(customer_id)
WHERE cc.rentals_in_cat = b.mx
ORDER BY cc.customer_id, cc.category_name;

-- (1) Toplam kiralama sayısı
SELECT r.customer_id,
       COUNT(r.rental_id) AS total_rentals
FROM rental r
GROUP BY r.customer_id
ORDER BY r.customer_id;


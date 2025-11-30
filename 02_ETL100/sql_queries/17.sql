SELECT s.staff_id,
       s.first_name || ' ' || s.last_name AS staff_name,
       COUNT(r.rental_id) AS rental_count
FROM staff s
JOIN rental r ON s.staff_id = r.staff_id
GROUP BY s.staff_id, staff_name
ORDER BY rental_count DESC
LIMIT 1;

-- ===============================================
-- AIRBNB CLONE DATABASE - SUBQUERIES
-- Repository: alx-airbnb-database
-- Directory: database-adv-script
-- File: subqueries.sql
-- ===============================================

-- 1️⃣ Non-Correlated Subquery: Find all properties where the average rating is greater than 4.0
SELECT 
    p.property_id,
    p.name,
    p.location,
    p.pricepernight
FROM 
    Property p
WHERE 
    p.property_id IN (
        SELECT 
            r.property_id
        FROM 
            Review r
        GROUP BY 
            r.property_id
        HAVING 
            AVG(r.rating) > 4.0
    )
ORDER BY 
    p.name;


-- 2️⃣ Correlated Subquery: Find all users who have made more than 3 bookings
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM 
    "User" u
WHERE 
    (
        SELECT 
            COUNT(*)
        FROM 
            Booking b
        WHERE 
            b.user_id = u.user_id
    ) > 3
ORDER BY 
    u.first_name, u.last_name;

-- ===============================================
-- END OF FILE
-- ===============================================

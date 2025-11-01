-- =========================================================
-- AIRBNB CLONE DATABASE - PERFORMANCE TEST & QUERY REFACTOR
-- Repository: alx-airbnb-database
-- Directory: database-adv-script
-- File: perfomance.sql
-- =========================================================

-- =========================================================
-- 1️⃣ INITIAL QUERY (Before Optimization)
-- Retrieves all bookings along with:
-- - User details
-- - Property details
-- - Payment details
-- =========================================================

EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.user_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.status,
    u.full_name,
    u.email,
    p.title AS property_title,
    p.location,
    p.pricepernight,
    pay.amount,
    pay.payment_method,
    pay.payment_date
FROM Booking b
JOIN "User" u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
JOIN Payment pay ON b.booking_id = pay.booking_id;

-- =========================================================
-- 2️⃣ IDENTIFIED ISSUES:
-- - Multiple JOINs on large tables may slow down query
-- - Missing indexes on join keys (user_id, property_id, booking_id)
-- - Unnecessary columns retrieved
-- =========================================================


-- =========================================================
-- 3️⃣ OPTIMIZED QUERY
-- Improvements:
-- - Select only necessary columns
-- - Ensure proper indexing (see database_index.sql)
-- - Use EXISTS instead of JOIN for checking relationships when needed
-- - Filter by recent bookings to limit dataset size
-- =========================================================

EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    u.full_name,
    u.email,
    p.title AS property_title,
    p.location,
    pay.amount,
    pay.payment_date
FROM Booking b
JOIN "User" u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.start_date >= NOW() - INTERVAL '6 months'
ORDER BY b.start_date DESC;

-- =========================================================
-- 4️⃣ NOTES:
-- - This query now reads fewer columns and rows
-- - Indexes on (user_id), (property_id), and (booking_id) reduce scan cost
-- - LEFT JOIN on Payment prevents excluding bookings without payments
-- =========================================================

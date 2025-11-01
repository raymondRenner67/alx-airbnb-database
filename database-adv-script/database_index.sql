-- ===============================================
-- AIRBNB CLONE DATABASE - INDEX CREATION
-- Repository: alx-airbnb-database
-- Directory: database-adv-script
-- File: database_index.sql
-- ===============================================

-- -----------------------------------------------
-- 1️⃣ Identify High-Usage Columns
-- Based on typical Airbnb queries involving:
--   - Filtering by user email or role
--   - Joining users with bookings
--   - Filtering or sorting properties by location or price
--   - Joining bookings with properties
-- -----------------------------------------------

-- -----------------------------------------------
-- 2️⃣ CREATE INDEX COMMANDS
-- -----------------------------------------------

-- 🔹 USER TABLE INDEXES
-- Frequently searched columns: email (for login), role (for filtering by user type)
CREATE INDEX idx_user_email ON "User" (email);
CREATE INDEX idx_user_role ON "User" (role);

-- 🔹 BOOKING TABLE INDEXES
-- Frequently used in JOINs and WHERE clauses
CREATE INDEX idx_booking_user_id ON Booking (user_id);
CREATE INDEX idx_booking_property_id ON Booking (property_id);
CREATE INDEX idx_booking_status ON Booking (status);

-- 🔹 PROPERTY TABLE INDEXES
-- Frequently used for searches, filters, and sorting
CREATE INDEX idx_property_location ON Property (location);
CREATE INDEX idx_property_price ON Property (pricepernight);

-- -----------------------------------------------
-- 3️⃣ VERIFY INDEX CREATION
-- PostgreSQL command:
-- \di
-- -----------------------------------------------

-- -----------------------------------------------
-- 4️⃣ PERFORMANCE TESTING
-- Use EXPLAIN or EXPLAIN ANALYZE to measure improvement
-- -----------------------------------------------

-- Example: Before adding indexes
EXPLAIN ANALYZE
SELECT *
FROM Booking b
JOIN "User" u ON b.user_id = u.user_id
WHERE u.email = 'example@mail.com';

-- Example: After adding indexes
EXPLAIN ANALYZE
SELECT *
FROM Booking b
JOIN "User" u ON b.user_id = u.user_id
WHERE u.email = 'example@mail.com';

-- Observe the reduction in cost and execution time.

-- ===============================================
-- END OF FILE
-- ===============================================

-- =========================================================
-- AIRBNB CLONE DATABASE - BOOKING TABLE PARTITIONING
-- Repository: alx-airbnb-database
-- Directory: database-adv-script
-- File: partitioning.sql
-- =========================================================

-- ===========================================
-- 1️⃣ PREPARATION
-- Rename the existing Booking table to keep a backup
-- ===========================================
ALTER TABLE Booking RENAME TO Booking_backup;

-- ===========================================
-- 2️⃣ CREATE PARTITIONED BOOKING TABLE
-- Partitioned by RANGE on start_date
-- ===========================================
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price NUMERIC(10, 2) NOT NULL CHECK (total_price > 0),
    status booking_status NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_dates CHECK (end_date > start_date),
    CONSTRAINT fk_booked_property FOREIGN KEY (property_id)
        REFERENCES Property (property_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_guest_user FOREIGN KEY (user_id)
        REFERENCES "User" (user_id)
        ON DELETE RESTRICT
) PARTITION BY RANGE (start_date);

-- ===========================================
-- 3️⃣ CREATE PARTITIONS BY YEAR
-- Adjust ranges depending on data coverage
-- ===========================================
CREATE TABLE Booking_2023 PARTITION OF Booking
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE Booking_2024 PARTITION OF Booking
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE Booking_2025 PARTITION OF Booking
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Optional partition for future data
CREATE TABLE Booking_future PARTITION OF Booking
    FOR VALUES FROM ('2026-01-01') TO (MAXVALUE);

-- ===========================================
-- 4️⃣ RE-INSERT EXISTING DATA FROM BACKUP
-- ===========================================
INSERT INTO Booking
SELECT * FROM Booking_backup;

-- ===========================================
-- 5️⃣ TEST QUERY PERFORMANCE
-- Run EXPLAIN ANALYZE before and after partitioning
-- ===========================================
EXPLAIN ANALYZE
SELECT *
FROM Booking
WHERE start_date BETWEEN '2025-01-01' AND '2025-03-31';

-- ===========================================
-- 6️⃣ CLEANUP NOTE
-- You can DROP TABLE Booking_backup once validated
-- ===========================================
-- DROP TABLE Booking_backup;

-- =========================================================
-- END OF FILE
-- =========================================================

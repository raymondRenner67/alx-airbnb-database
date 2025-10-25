-- =======================================================
-- AIRBNB CLONE DATABASE SEED DATA
-- Repository: alx-airbnb-database
-- File: database-script-0x02/seed.sql
--
-- This script inserts sample data into the database.
-- NOTE: UUIDs are hardcoded here to maintain foreign key integrity.
-- If your database requires a specific UUID function (e.g., uuid_in), adjust accordingly.
-- This script assumes standard string casting for UUIDs.
-- =======================================================

-- Disable foreign key checks temporarily if needed (e.g., MySQL), not necessary for PostgeSQL
-- SET foreign_key_checks = 0;

-- Define common timestamps for predictability
-- We use NOW() for simplicity, but defining variables is cleaner in application code.
-- For this script, we just use string literals for UUIDs and current_timestamp.

-- =======================================================
-- 1. USER INSERTS (5 Users: 1 Admin, 2 Hosts, 2 Guests)
--    Note: Password hashes are placeholders (e.g., 'password' hashed)
-- =======================================================

INSERT INTO "User" (user_id, first_name, last_name, email, password_hash, role) VALUES
-- Admin
('a0a0a0a0-0000-4000-a000-000000000000', 'Jane', 'Admin', 'jane.admin@air.com', '$2a$10$xyz', 'admin'),

-- Hosts
('b1b1b1b1-1111-4111-b111-111111111111', 'Host', 'Alpha', 'host.alpha@air.com', '$2a$10$abc', 'host'),
('c2c2c2c2-2222-4222-c222-222222222222', 'Host', 'Beta', 'host.beta@air.com', '$2a$10$def', 'host'),

-- Guests
('d3d3d3d3-3333-4333-d333-333333333333', 'Guest', 'Delta', 'guest.delta@air.com', '$2a$10$ghi', 'guest'),
('e4e4e4e4-4444-4444-e444-444444444444', 'Guest', 'Echo', 'guest.echo@air.com', '$2a$10$jkl', 'guest');


-- =======================================================
-- 2. PROPERTY INSERTS (3 Properties)
-- =======================================================

INSERT INTO Property (property_id, host_id, name, description, location, pricepernight) VALUES
-- Luxury Property (Host Alpha)
('10101010-1010-4010-1010-101010101010', 'b1b1b1b1-1111-4111-b111-111111111111', 'Luxury Ocean View Villa', 'Stunning villa with infinity pool and private beach access.', 'Malibu, CA', 950.00),

-- Cozy Cabin (Host Beta)
('20202020-2020-4020-2020-202020202020', 'c2c2c2c2-2222-4222-c222-222222222222', 'Cozy Mountain Cabin', 'A secluded getaway perfect for hiking and stargazing.', 'Aspen, CO', 225.50),

-- Downtown Studio (Host Alpha)
('30303030-3030-4030-3030-303030303030', 'b1b1b1b1-1111-4111-b111-111111111111', 'Modern Downtown Studio', 'Perfect for business travelers, right in the heart of the city.', 'New York, NY', 180.00);


-- =======================================================
-- 3. BOOKING INSERTS (3 Bookings)
-- =======================================================

-- Booking 1: Confirmed (Studio, Guest Delta, 3 nights @ 180 = 540.00)
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status) VALUES
('50505050-5050-4050-5050-505050505050', '30303030-3030-4030-3030-303030303030', 'd3d3d3d3-3333-4333-d333-333333333333', '2025-11-01', '2025-11-04', 540.00, 'confirmed');

-- Booking 2: Canceled (Luxury Villa, Guest Echo, 5 nights @ 950 = 4750.00)
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status) VALUES
('60606060-6060-4060-6060-606060606060', '10101010-1010-4010-1010-101010101010', 'e4e4e4e4-4444-4444-e444-444444444444', '2025-12-15', '2025-12-20', 4750.00, 'canceled');

-- Booking 3: Pending (Cozy Cabin, Guest Delta, 2 nights @ 225.50 = 451.00)
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status) VALUES
('70707070-7070-4070-7070-707070707070', '20202020-2020-4020-2020-202020202020', 'd3d3d3d3-3333-4333-d333-333333333333', '2026-01-10', '2026-01-12', 451.00, 'pending');


-- =======================================================
-- 4. PAYMENT INSERTS (1 Payment for the confirmed booking)
-- =======================================================

INSERT INTO Payment (payment_id, booking_id, amount, payment_method) VALUES
-- Payment for Booking 1 (Studio)
('80808080-8080-4080-8080-808080808080', '50505050-5050-4050-5050-505050505050', 540.00, 'credit_card');


-- =======================================================
-- 5. REVIEW INSERTS (1 Review)
-- =======================================================

INSERT INTO Review (review_id, property_id, user_id, rating, comment) VALUES
-- Guest Delta reviews the Luxury Villa (where they previously booked/canceled, simulating a past stay)
('90909090-9090-4090-9090-909090909090', '10101010-1010-4010-1010-101010101010', 'd3d3d3d3-3333-4333-d333-333333333333', 5, 'Absolutely spectacular location! Host Alpha was very responsive and helpful. Highly recommend the villa!');


-- =======================================================
-- 6. MESSAGE INSERTS (3 Messages)
-- =======================================================

INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
-- Guest Delta -> Host Alpha (Question about Studio property)
('a1a1a1a1-1a1a-4a1a-1a1a-1a1a1a1a1a1a', 'd3d3d3d3-3333-4333-d333-333333333333', 'b1b1b1b1-1111-4111-b111-111111111111', 'Is there fast Wi-Fi available at the downtown studio?', CURRENT_TIMESTAMP - INTERVAL '2 days'),

-- Host Alpha -> Guest Delta (Reply)
('b2b2b2b2-2b2b-4b2b-2b2b-2b2b2b2b2b2b', 'b1b1b1b1-1111-4111-b111-111111111111', 'd3d3d3d3-3333-4333-d333-333333333333', 'Yes, gigabit fiber connection is standard! Looking forward to hosting you.', CURRENT_TIMESTAMP - INTERVAL '1 day'),

-- Guest Echo -> Host Beta (Question about Cabin)
('c3c3c3c3-3c3c-4c3c-3c3c-3c3c3c3c3c3c', 'e4e4e4e4-4444-4444-e444-444444444444', 'c2c2c2c2-2222-4222-c222-222222222222', 'What is the closest ski resort to the cozy mountain cabin?', CURRENT_TIMESTAMP);


-- Re-enable foreign key checks (if disabled)
-- SET foreign_key_checks = 1;

-- COMMIT;

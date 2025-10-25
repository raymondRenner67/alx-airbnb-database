-- ===============================================
-- AIRBNB CLONE DATABASE SCHEMA DEFINITION
-- Repository: alx-airbnb-database
-- File: database-script-0x01/schema.sql
-- Target Database: PostgreSQL or MySQL (with minor type adjustments)
--
-- This script defines all tables, primary keys (PK), foreign keys (FK),
-- and necessary constraints (ENUMs, CHECKs, NOT NULL) based on the
-- project's Entity Relationship Diagram (ERD).
-- ===============================================

-- Ensure UUID generation is available (Common in PostgreSQL, optional/different in MySQL)
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ---------------------------------
-- 1. DEFINE ENUM TYPES (PostgreSQL Syntax)
--    If using MySQL, ENUM types are defined inline within the CREATE TABLE statement.
-- ---------------------------------
-- User Role
CREATE TYPE user_role AS ENUM ('guest', 'host', 'admin');

-- Booking Status
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'canceled');

-- Payment Method
CREATE TYPE payment_method AS ENUM ('credit_card', 'paypal', 'stripe');


-- ---------------------------------
-- 2. CREATE TABLES
-- ---------------------------------

-- Table: User
CREATE TABLE "User" (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- Use UUID for PK
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL, -- Email must be unique for login
    password_hash VARCHAR(255) NOT NULL, -- Stored as a hash
    phone_number VARCHAR(20),
    role user_role NOT NULL, -- Enforces roles ('guest', 'host', 'admin')
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table: Property
CREATE TABLE Property (
    property_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    host_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    pricepernight NUMERIC(10, 2) NOT NULL CHECK (pricepernight > 0), -- Price must be positive
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP, -- Tracks latest modification

    -- Foreign Key Constraint
    CONSTRAINT fk_host
        FOREIGN KEY (host_id)
        REFERENCES "User" (user_id)
        ON DELETE CASCADE -- If a host user is deleted, their properties are deleted
);

-- Table: Booking (Includes total_price for historical integrity and performance)
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL, -- The guest who made the booking
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price NUMERIC(10, 2) NOT NULL CHECK (total_price > 0),
    status booking_status NOT NULL, -- Enforces status ('pending', 'confirmed', 'canceled')
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Custom constraint to ensure end date is after start date
    CONSTRAINT check_dates CHECK (end_date > start_date),

    -- Foreign Key Constraints
    CONSTRAINT fk_booked_property
        FOREIGN KEY (property_id)
        REFERENCES Property (property_id)
        ON DELETE RESTRICT, -- Do not allow property deletion if bookings exist
    CONSTRAINT fk_guest_user
        FOREIGN KEY (user_id)
        REFERENCES "User" (user_id)
        ON DELETE RESTRICT -- Do not allow user deletion if active bookings exist
);

-- Table: Payment
CREATE TABLE Payment (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID UNIQUE NOT NULL, -- Payment is 1:1 with Booking
    amount NUMERIC(10, 2) NOT NULL CHECK (amount > 0),
    payment_date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    payment_method payment_method NOT NULL, -- Enforces payment method types

    -- Foreign Key Constraint
    CONSTRAINT fk_payment_booking
        FOREIGN KEY (booking_id)
        REFERENCES Booking (booking_id)
        ON DELETE CASCADE -- If a booking is deleted, the payment record is deleted
);

-- Table: Review
CREATE TABLE Review (
    review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL, -- The user who wrote the review
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5), -- Rating must be between 1 and 5
    comment TEXT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Key Constraints
    CONSTRAINT fk_reviewed_property
        FOREIGN KEY (property_id)
        REFERENCES Property (property_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_reviewer_user
        FOREIGN KEY (user_id)
        REFERENCES "User" (user_id)
        ON DELETE CASCADE
);

-- Table: Message
CREATE TABLE Message (
    message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Foreign Key Constraints
    CONSTRAINT fk_message_sender
        FOREIGN KEY (sender_id)
        REFERENCES "User" (user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_message_recipient
        FOREIGN KEY (recipient_id)
        REFERENCES "User" (user_id)
        ON DELETE CASCADE,
    
    -- Constraint to prevent a user from messaging themselves (optional but good practice)
    CONSTRAINT check_different_users CHECK (sender_id <> recipient_id)
);


-- ---------------------------------
-- 3. CREATE INDEXES FOR PERFORMANCE
--    These indexes cover frequently used foreign key columns and search fields.
-- ---------------------------------

-- Index for quickly finding properties listed by a host
CREATE INDEX idx_property_host_id ON Property (host_id);

-- Index for efficient property searching by location
CREATE INDEX idx_property_location ON Property (location);

-- Indexes for efficient lookup of bookings by property or guest
CREATE INDEX idx_booking_property_id ON Booking (property_id);
CREATE INDEX idx_booking_user_id ON Booking (user_id);

-- Index for fast lookup of payments tied to a booking (in addition to the UNIQUE constraint)
CREATE INDEX idx_payment_booking_id ON Payment (booking_id);

-- Indexes for quickly fetching reviews for a property or written by a user
CREATE INDEX idx_review_property_id ON Review (property_id);
CREATE INDEX idx_review_user_id ON Review (user_id);

-- Indexes for fast retrieval of messages sent to or from a user
CREATE INDEX idx_message_sender_id ON Message (sender_id);
CREATE INDEX idx_message_recipient_id ON Message (recipient_id);

-- ---------------------------------
-- END OF SCHEMA
-- ---------------------------------

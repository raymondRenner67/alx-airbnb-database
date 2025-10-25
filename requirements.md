# Property Rental Platform - System Requirements

## 1.0 Introduction

This document outlines the functional and non-functional requirements for a property rental platform. The system is designed to connect hosts, who list properties, with guests, who book them. It will also facilitate communication, payments, and reviews, with administrative oversight.

---

## 2.0 Functional Requirements

### 2.1 User Management & Authentication

* **FR-2.1.1: User Registration**
    * The system must allow individuals to create a new account.
    * Required information for registration: `first_name`, `last_name`, `email`, and `password`.
    * The `email` address must be unique across all users in the system.

* **FR-2.1.2: User Login**
    * Registered users must be able to log in using their `email` and `password`.
    * The system must securely validate user credentials.

* **FR-2.1.3: User Roles**
    * The system must support three distinct user roles, assigned at registration or by an admin:
        * **`guest`**: Can browse properties, make bookings, write reviews, and send messages.
        * **`host`**: Can list and manage properties, manage bookings for their properties, and send/receive messages.
        * **`admin`**: Has full system oversight, including managing users, properties, and bookings.

* **FR-2.1.4: User Profile**
    * Users may optionally add a `phone_number` to their profile.
    * The system must record the `created_at` timestamp for all new user accounts.

### 2.2 Property & Listings Management

* **FR-2.2.1: Create Property Listing**
    * Users with the `host` role must be able to create new property listings.
    * Each property must be associated with the `host_id` of the user who created it.
    * Required fields for a new listing: `name`, `description`, `location`, and `pricepernight`.

* **FR-2.2.2: Manage Property Listing**
    * Hosts must be able to view, edit, and delete their own property listings.
    * The system must track the `created_at` timestamp for new listings.
    * The system must automatically update an `updated_at` timestamp whenever a property's details are modified.

* **FR-2.2.3: View Property Listings**
    * All users (including unauthenticated visitors) must be able to browse and view property listings.

### 2.3 Booking & Reservation System

* **FR-2.3.1: Create Booking**
    * A logged-in `guest` must be able to book a property.
    * A booking must be associated with one `property_id` and one `user_id` (the guest).
    * A booking request must include a `start_date` and an `end_date`.

* **FR-2.3.2: Booking Status Workflow**
    * The system must manage the lifecycle of a booking using a `status`.
    * The allowed statuses are:
        * **`pending`**: The initial state when a guest requests a booking.
        * **`confirmed`**: The state when a host accepts the booking.
        * **`canceled`**: The state when the booking is canceled by either the guest or the host.

* **FR-2.3.3: Booking Price**
    * The system must calculate and store the `total_price` for the booking (e.g., `pricepernight` * number of nights).

### 2.4 Payment Processing

* **FR-2.4.1: Process Payment**
    * The system must be able to process a payment for a booking.
    * Each payment must be directly linked to one `booking_id`.
    * The system must store the `amount` of the payment.

* **FR-2.4.2: Payment Methods**
    * The system must support and record the `payment_method` used.
    * Supported methods include: `credit_card`, `paypal`, and `stripe`.

* **FR-2.4.3: Payment Record**
    * The system must record the `payment_date` (timestamped) for every transaction.

### 2.5 Reviews & Ratings

* **FR-2.5.1: Submit Review**
    * A logged-in `guest` (`user_id`) must be able to submit a review for a `property_id`.
    * A review must include a `rating` and a `comment`.

* **FR-2.5.2: Review Content**
    * The `rating` must be an integer between 1 and 5 (inclusive).
    * The `comment` must be a text block.

* **FR-2.5.3: Review Association**
    * Each review must be linked to the specific user who wrote it and the property it is about.
    * The system must store the `created_at` timestamp for all new reviews.

### 2.6 Messaging System

* **FR-2.6.1: Send Message**
    * A logged-in user (`sender_id`) must be able to send a text-based message to another user (`recipient_id`).
    * The system must store the `message_body`.

* **FR-2.6.2: View Messages**
    * Users must be able to view messages they have sent and received.
    * The system must store the `sent_at` timestamp for every message.

---

## 3.0 Non-Functional Requirements

### 3.1 Data & Schema
The database implementation must adhere to the data model defined in Appendix A. All specified data types, constraints, and relationships must be enforced at the database level.

### 3.2 Data Integrity

* **NI-3.2.1:** A `Property` cannot exist without a valid `host_id` linking to a `User`.
* **NI-3.2.2:** A `Booking` cannot exist without a valid `property_id` and `user_id`.
* **NI-3.2.3:** A `Payment` cannot exist without a valid `booking_id`.
* **NI-3.2.4:** A `Review` cannot exist without a valid `property_id` and `user_id`.
* **NI-3.2.5:** A `Message` cannot exist without a valid `sender_id` and `recipient_id`.
* **NI-3.2.6:** All `NOT NULL` fields must be populated upon record creation.

### 3.3 Data Validation

* **DV-3.3.1:** The `email` field in the `User` table must be unique.
* **DV-3.3.2:** The `rating` field in the `Review` table must be constrained to values from 1 to 5.
* **DV-3.3.3:** The `role`, `status`, and `payment_method` fields must be constrained to their respective ENUM values.

### 3.4 Performance & Indexing

To ensure fast query performance, the following fields must be indexed:
* `User(user_id)` (Primary Key)
* `User(email)` (For login and uniqueness checks)
* `Property(property_id)` (Primary Key)
* `Booking(booking_id)` (Primary Key)
* `Booking(property_id)` (For finding all bookings for a property)
* `Payment(payment_id)` (Primary Key)
* `Payment(booking_id)` (For finding the payment for a booking)
* `Review(review_id)` (Primary Key)
* `Message(message_id)` (Primary Key)

### 3.5 Security

* **SEC-3.5.1:** All user passwords must be stored in a non-reversible, hashed format (e.g., using `password_hash`). Plain-text passwords must never be stored.

### 3.6 Auditing

* **AUD-3.6.1:** All primary entities (`User`, `Property`, `Booking`, `Payment`, `Review`, `Message`) must have a `created_at` timestamp that defaults to the current time of record creation.
* **AUD-3.6.2:** The `Property` entity must have an `updated_at` timestamp that automatically updates when the record is modified.

---

## Appendix A: Database Schema

### Table: `User`

| Column | Type | Constraints | Details |
| :--- | :--- | :--- | :--- |
| **user_id** | UUID | **Primary Key**, Indexed | Unique identifier for the user. |
| first_name | VARCHAR | NOT NULL | User's first name. |
| last_name | VARCHAR | NOT NULL | User's last name. |
| email | VARCHAR | UNIQUE, NOT NULL | User's email address. |
| password_hash | VARCHAR | NOT NULL | Hashed password. |
| phone_number | VARCHAR | NULL | Optional phone number. |
| role | ENUM | NOT NULL | ('guest', 'host', 'admin') |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | |

### Table: `Property`

| Column | Type | Constraints | Details |
| :--- | :--- | :--- | :--- |
| **property_id** | UUID | **Primary Key**, Indexed | Unique identifier for the property. |
| host_id | UUID | **Foreign Key** (User.user_id) | The host who owns the property. |
| name | VARCHAR | NOT NULL | Name of the property. |
| description | TEXT | NOT NULL | Detailed description. |
| location | VARCHAR | NOT NULL | Physical location/address. |
| pricepernight | DECIMAL | NOT NULL | Cost per night. |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | |
| updated_at | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | |

### Table: `Booking`

| Column | Type | Constraints | Details |
| :--- | :--- | :--- | :--- |
| **booking_id** | UUID | **Primary Key**, Indexed | Unique identifier for the booking. |
| property_id | UUID | **Foreign Key** (Property.property_id) | The property being booked. |
| user_id | UUID | **Foreign Key** (User.user_id) | The guest making the booking. |
| start_date | DATE | NOT NULL | |
| end_date | DATE | NOT NULL | |
| total_price | DECIMAL | NOT NULL | Total calculated price. |
| status | ENUM | NOT NULL | ('pending', 'confirmed', 'canceled') |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | |

### Table: `Payment`

| Column | Type | Constraints | Details |
| :--- | :--- | :--- | :--- |
| **payment_id** | UUID | **Primary Key**, Indexed | Unique identifier for the payment. |
| booking_id | UUID | **Foreign Key** (Booking.booking_id) | The associated booking. |
| amount | DECIMAL | NOT NULL | Amount paid. |
| payment_date | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | |
| payment_method | ENUM | NOT NULL | ('credit_card', 'paypal', 'stripe') |

### Table: `Review`

| Column | Type | Constraints | Details |
| :--- | :--- | :--- | :--- |
| **review_id** | UUID | **Primary Key**, Indexed | Unique identifier for the review. |
| property_id | UUID | **Foreign Key** (Property.property_id) | The property being reviewed. |
| user_id | UUID | **Foreign Key** (User.user_id) | The guest who wrote the review. |
| rating | INTEGER | NOT NULL, CHECK (1-5) | Star rating from 1 to 5. |
| comment | TEXT | NOT NULL | The review text. |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | |

### Table: `Message`

| Column | Type | Constraints | Details |
| :--- | :--- | :--- | :--- |
| **message_id** | UUID | **Primary Key**, Indexed | Unique identifier for the message. |
| sender_id | UUID | **Foreign Key** (User.user-id) | The user sending the message. |
| recipient_id | UUID | **Foreign Key** (User.user_id) | The user receiving the message. |
| message_body | TEXT | NOT NULL | Content of the message. |
| sent_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | |
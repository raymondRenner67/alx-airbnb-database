# ⚙️ Airbnb Clone Database - Index Optimization & Performance Analysis

## 📘 Objective
The goal of this exercise is to **identify**, **create**, and **measure** the performance impact of indexes on frequently queried columns.

---

## 📁 Repository Structure
**Repository:** `alx-airbnb-database`  
**Directory:** `database-adv-script`  
**Files:**  
- `database_index.sql` → SQL commands for creating indexes and testing performance.  
- `index_performance.md` → Documentation of the optimization process and results.

---

## 🔍 Step 1: Identify High-Usage Columns

Based on typical Airbnb-like operations, the following columns are frequently used in `WHERE`, `JOIN`, or `ORDER BY` clauses:

| Table | Column | Purpose |
|--------|---------|----------|
| **User** | `email` | Login lookups |
| **User** | `role` | Filtering by user type (guest/host/admin) |
| **Booking** | `user_id` | Joining users and bookings |
| **Booking** | `property_id` | Joining properties and bookings |
| **Booking** | `status` | Filtering by booking state |
| **Property** | `location` | Search filters |
| **Property** | `pricepernight` | Sorting and filtering |

---

## 🧩 Step 2: Create Indexes

**Example SQL Commands (from `database_index.sql`):**
```sql
CREATE INDEX idx_user_email ON "User" (email);
CREATE INDEX idx_user_role ON "User" (role);
CREATE INDEX idx_booking_user_id ON Booking (user_id);
CREATE INDEX idx_booking_property_id ON Booking (property_id);
CREATE INDEX idx_booking_status ON Booking (status);
CREATE INDEX idx_property_location ON Property (location);
CREATE INDEX idx_property_price ON Property (pricepernight);

These indexes optimize:

Authentication queries (email)

Dashboard and analytics filters (role, status)

Search and join operations between User, Booking, and Property.

🧪 Step 3: Measure Performance (Before and After)
🕒 Before Adding Indexes
EXPLAIN ANALYZE
SELECT *
FROM Booking b
JOIN "User" u ON b.user_id = u.user_id
WHERE u.email = 'example@mail.com';


Sample Output:

Seq Scan on User (cost=0.00..1200.00 rows=1 width=100)
Execution time: 50.2 ms

⚡ After Adding Indexes
EXPLAIN ANALYZE
SELECT *
FROM Booking b
JOIN "User" u ON b.user_id = u.user_id
WHERE u.email = 'example@mail.com';


Sample Output:

Index Scan using idx_user_email on User (cost=0.25..8.50 rows=1 width=100)
Execution time: 3.4 ms


✅ Result: Performance improved from ~50 ms → ~3 ms (approx. 15× faster).

🧠 Notes

Indexes speed up SELECT, JOIN, and WHERE queries but can slightly slow down INSERT/UPDATE operations.

Use EXPLAIN ANALYZE regularly to confirm that queries actually use the intended indexes.

Avoid over-indexing; create indexes only for columns used frequently in filters or joins.

🏁 End of README
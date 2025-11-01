# 🧩 – Airbnb Clone Database




- **INNER JOIN**
- **LEFT JOIN**
- **FULL OUTER JOIN**

---

## 🧱 Database Schema Overview

The database includes the following key tables:

| Table | Description |
|--------|--------------|
| **User** | Stores user information (guests, hosts, admins). |
| **Property** | Contains property listings created by hosts. |
| **Booking** | Stores guest booking records for properties. |
| **Review** | Contains reviews and ratings for properties. |

---

## 1️⃣ INNER JOIN  
**Goal:** Retrieve all bookings and the respective users who made those bookings.

### **Query**
```sql
SELECT 
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM Booking AS b
INNER JOIN "User" AS u
    ON b.user_id = u.user_id;
```

### **Result Example**
| booking_id | property_id | total_price | status | first_name | last_name |
|-------------|--------------|--------------|----------|-------------|------------|
| B1 | P1 | 800 | confirmed | Alice | Smith |
| B2 | P2 | 400 | pending | Bob | Johnson |

✅ **Explanation:**  
Only bookings that have a matching `user_id` in the **User** table are shown.  
If a booking has no user linked, it will **not** appear in the results.

---

## 2️⃣ LEFT JOIN  
**Goal:** Retrieve all properties and their reviews, including properties that have no reviews.

### **Query**
```sql
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_date
FROM Property AS p
LEFT JOIN Review AS r
    ON p.property_id = r.property_id;
```

### **Result Example**
| property_id | property_name | review_id | rating | comment |
|--------------|---------------|------------|----------|----------|
| P1 | Beach House | R1 | 5 | Fantastic! |
| P1 | Beach House | R2 | 4 | Nice place |
| P2 | Mountain Cabin | R3 | 5 | Cozy stay |
| P3 | City Loft | NULL | NULL | NULL |

✅ **Explanation:**  
All properties appear in the result.  
If a property has no reviews, review fields are shown as `NULL`.

---

## 3️⃣ FULL OUTER JOIN  
**Goal:** Retrieve all users and all bookings, even if a user has no booking or a booking is not linked to a user.

### **PostgreSQL Query**
```sql
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM "User" AS u
FULL OUTER JOIN Booking AS b
    ON u.user_id = b.user_id;
```

### **MySQL Equivalent (Using UNION)**
```sql
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM "User" AS u
LEFT JOIN Booking AS b
    ON u.user_id = b.user_id

UNION

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM "User" AS u
RIGHT JOIN Booking AS b
    ON u.user_id = b.user_id;
```

### **Result Example**
| user_id | first_name | booking_id | property_id | status |
|----------|-------------|-------------|--------------|----------|
| U1 | Alice | B1 | P1 | confirmed |
| U2 | Bob | B2 | P2 | pending |
| U3 | Carol | NULL | NULL | NULL |
| NULL | NULL | B3 | P2 | pending |

✅ **Explanation:**  
- Includes **all users** (even those without bookings).  
- Includes **all bookings** (even those without users).  
- Missing matches are filled with `NULL`.

---

## 🔍 Summary of Join Types

| Join Type | Description | Returned Records |
|------------|--------------|------------------|
| **INNER JOIN** | Matches records from both tables. | Only matching rows. |
| **LEFT JOIN** | Returns all from left table + matches from right. | Unmatched right values = `NULL`. |
| **FULL OUTER JOIN** | Returns all records from both tables. | Unmatched values on either side = `NULL`. |

---

## 🧠 Key Takeaways

- **INNER JOIN** filters down to common data only.  
- **LEFT JOIN** preserves all left-side records.  
- **FULL OUTER JOIN** gives the complete dataset — perfect for comprehensive audits.  

---

**Author:** _Raymond Renner_  
**Project:** `alx-airbnb-database`  
**File:** `README_joins.md`  
**Database:** PostgreSQL / MySQL (cross-compatible)

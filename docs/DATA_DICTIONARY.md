# Data Dictionary

This document provides detailed information about the datasets used in this analysis.

## 📊 Dataset Overview

| Dataset | Records | Description | File Size |
|---------|---------|-------------|-----------|
| orders.csv | 250,000+ | Order transaction data | ~25 MB |
| users.csv | 30,000+ | User profile information | ~1.1 MB |
| restaurants.csv | 10,000+ | Restaurant details | ~396 KB |
| complaints.csv | 18,566 | Customer complaints | ~798 KB |

---

## 📋 orders.csv

Contains all order transactions on the platform.

| Column Name | Data Type | Description | Example | Notes |
|-------------|-----------|-------------|---------|-------|
| order_id | String | Unique order identifier | O00001 | Primary key |
| user_id | String | User who placed the order | U29975 | Foreign key to users |
| restaurant_id | String | Restaurant fulfilling order | R5542 | Foreign key to restaurants |
| order_date | Date | When order was placed | 2025-12-18 | Format: YYYY-MM-DD |
| order_value | Float | Total order amount in ₹ | 704.53 | Includes tax |
| discount_applied | Float | Discount given in ₹ | 104.76 | Platform + restaurant discounts |
| delivery_fee | Integer | Delivery charge in ₹ | 30 | Fixed per order |
| delivery_time_minutes | Float | Time to deliver in minutes | 52.57 | NULL for cancelled orders |
| is_cancelled | Integer | Order cancellation status | 0 or 1 | 0=completed, 1=cancelled |
| payment_type | String | Payment method | Card, UPI, COD | Three types available |
| city | String | Delivery city | Bangalore | 10 major cities |

### Data Quality Issues Identified:
- **1,492 duplicate order_ids** detected
- **2,000 orders with negative values** (requires investigation)
- **~1,500 missing delivery_time_minutes** (mostly cancelled orders)

---

## 👥 users.csv

User profile and registration information.

| Column Name | Data Type | Description | Example | Notes |
|-------------|-----------|-------------|---------|-------|
| user_id | String | Unique user identifier | U29975 | Primary key |
| signup_date | Date | Account creation date | 2025-09-15 | Format: YYYY-MM-DD |
| acquisition_channel | String | How user found platform | YouTube Ads, Referral, etc. | Marketing channel |
| city | String | User's primary city | Hyderabad | May order from other cities |
| age_group | String | User demographic | 18-25, 26-35, etc. | Age bracket |
| lifetime_orders | Integer | Total orders placed | 12 | As of data extraction |
| total_spent | Float | Cumulative spending in ₹ | 8,432.12 | Before discounts |

### Acquisition Channels:
- YouTube Ads
- Facebook Ads
- Referral Program
- Organic Search
- Google Ads

---

## 🍽️ restaurants.csv

Restaurant partner information and performance metrics.

| Column Name | Data Type | Description | Example | Notes |
|-------------|-----------|-------------|---------|-------|
| restaurant_id | String | Unique restaurant identifier | R5542 | Primary key |
| restaurant_name | String | Business name | "Pizza Palace" | May contain duplicates across cities |
| city | String | Restaurant location | Bangalore | Single city per restaurant |
| cuisine_type | String | Food category | Italian, Chinese, etc. | Primary cuisine |
| commission_percentage | Float | Platform commission | 18.5 | Percentage of order value |
| average_rating | Float | Customer rating | 4.2 | Scale: 1-5 |
| total_orders | Integer | Orders fulfilled | 1,247 | Lifetime metric |
| active_since | Date | Onboarding date | 2024-01-15 | Partnership start |

### Commission Structure:
- Standard: 15-20%
- Premium partners: 12-15%
- New restaurants: 18-22%

---

## 😠 complaints.csv

Customer complaint records and resolution tracking.

| Column Name | Data Type | Description | Example | Notes |
|-------------|-----------|-------------|---------|-------|
| order_id | String | Associated order | O00003 | Foreign key to orders |
| complaint_id | String | Unique complaint identifier | C000000 | Primary key |
| complaint_type | String | Issue category | Food Quality, Late Delivery, etc. | 6 main categories |
| complaint_date | Date | When complaint filed | 2025-10-13 | Format: YYYY-MM-DD |
| resolution_time_hours | Integer | Time to resolve in hours | 6 | Customer satisfaction metric |

### Complaint Types:
1. **Food Quality** - Taste, freshness, preparation issues
2. **Late Delivery** - Exceeded promised time
3. **Wrong Item** - Incorrect order delivered
4. **App Issue** - Technical problems
5. **Refund Not Processed** - Payment issues
6. **Other** - Miscellaneous complaints

### Complaint Rate Calculation:
```
Complaint Rate = (Total Complaints / Total Orders) × 100
Platform Average: 7.4%
```

---

## 🔗 Data Relationships

```
users (user_id) ──────┐
                      ├──> orders (order_id) ──> complaints (complaint_id)
restaurants (restaurant_id) ──┘
```

### Key Relationships:
- One user can have many orders (1:N)
- One restaurant can fulfill many orders (1:N)
- One order can have 0 or 1 complaint (1:0..1)
- Orders link users to restaurants (junction entity)

---

## 📌 Business Rules

1. **Order Value Calculation:**
   ```
   Net Revenue = (Order Value × Commission %) - Discount Applied + Delivery Fee
   ```

2. **Cancellation Policy:**
   - Orders can be cancelled by user or restaurant
   - Cancelled orders have `is_cancelled = 1`
   - Delivery time is NULL for cancelled orders

3. **Discount Rules:**
   - Platform discounts (promo codes)
   - Restaurant discounts (special offers)
   - Combined in `discount_applied` field

4. **Delivery Fee Structure:**
   - ₹40 for orders under ₹300
   - ₹30 for orders ₹300-500
   - ₹20 for orders above ₹500

---

## 🔍 Data Quality Checks

### Recommended Validations:

```sql
-- Check for duplicates
SELECT order_id, COUNT(*) 
FROM orders 
GROUP BY order_id 
HAVING COUNT(*) > 1;

-- Check for negative values
SELECT COUNT(*) 
FROM orders 
WHERE order_value < 0;

-- Check for missing delivery times
SELECT COUNT(*) 
FROM orders 
WHERE delivery_time_minutes IS NULL 
AND is_cancelled = 0;

-- Validate date ranges
SELECT MIN(order_date), MAX(order_date) 
FROM orders;
```

---

## 📅 Data Collection Period

- **Start Date:** October 1, 2025
- **End Date:** December 31, 2025
- **Duration:** 3 months (Q4 2025)
- **Cities Covered:** 10 major Indian metros

---

## 💾 Storage & Format

- **Format:** CSV (Comma-Separated Values)
- **Encoding:** UTF-8
- **Delimiter:** Comma (,)
- **Header Row:** Yes
- **Null Representation:** Empty string or NULL

---

*For questions about specific data fields or values, please refer to the analysis notebooks or contact the repository maintainer.*

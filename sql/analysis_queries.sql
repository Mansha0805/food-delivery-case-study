USE fooddeliveryplatform;
SELECT
    MONTH (o.order_date) AS month,
    COUNT(CASE WHEN is_cancelled=0 AND o.order_value >= 0
               THEN CONCAT(o.order_id,o.user_id) END) AS total_orders,
    ROUND(SUM(CASE WHEN is_cancelled=0 AND o.order_value >= 0
              THEN o.order_value ELSE 0 END),3)  AS gross_order_value,
    ROUND(SUM(CASE WHEN is_cancelled=0 AND o.order_value >= 0
              THEN o.discount_applied ELSE 0 END),3) AS total_discounts,
    ROUND(SUM(CASE WHEN is_cancelled=0 AND o.order_value >= 0
              THEN o.delivery_fee ELSE 0 END),3) AS delivery_fee_revenue,
    ROUND(AVG(CASE WHEN is_cancelled=0 AND o.order_value >= 0
              THEN o.order_value END),3)AS avg_order_value,

    -- Net Revenue  does not include negative order values for all completed orders
    ROUND(SUM(CASE WHEN is_cancelled=0 AND o.order_value >= 0 
    THEN (o.order_value*r.commission_percentage/100) - o.discount_applied + o.delivery_fee
             ELSE 0 END),3)  AS net_revenue,
    ROUND(COUNT(CASE WHEN is_cancelled=1 THEN 1 END) * 100.0
        / COUNT(CONCAT(o.order_id,o.user_id)),2)     AS cancellation_rate_pct
FROM orders o 
LEFT JOIN restaurants r 
ON o.restaurant_id = r.restaurant_id
GROUP BY MONTH(o.order_date)
ORDER BY month;


----city level performance 
SELECT
    o.city,
    MONTH (o.order_date) AS month,
     COUNT(CASE WHEN is_cancelled=0 AND o.order_value >= 0
               THEN CONCAT(o.order_id,o.user_id) END) AS total_orders,
    ROUND(AVG(CASE WHEN o.is_cancelled=0 AND o.order_value >= 0
              THEN o.order_value END),3)  AS avg_order_value,
    ROUND(SUM(CASE WHEN o.is_cancelled=0 AND o.order_value >= 0
              THEN (o.order_value* r.commission_percentage/100) - o.discount_applied + o.delivery_fee
             ELSE 0 END),3)AS net_revenue,
    ROUND(COUNT(CASE WHEN o.is_cancelled=1 THEN 1 END) * 100.0
        / COUNT(o.order_id),2) AS cancellation_rate_pct,
    ROUND(COUNT(DISTINCT c.complaint_id) * 100.0
        / COUNT(o.order_id),2) AS complaint_rate_pct
FROM orders o 
LEFT JOIN restaurants r  ON o.restaurant_id = r.restaurant_id
LEFT JOIN complaints c ON o.order_id = c.order_id
GROUP BY o.city, Month (o.order_date )
ORDER BY o.city, month;


---acquistion channel analysis 
SELECT
    u.acquisition_channel,
    COUNT(u.user_id) AS total_users,
    COUNT(CASE WHEN o.is_cancelled=0 AND o.order_value>=0
               THEN o.order_id END) AS total_orders,
    ROUND(SUM(CASE WHEN o.is_cancelled=0 AND o.order_value>=0
              THEN (o.order_value* r.commission_percentage/100) - o.discount_applied + o.delivery_fee
             ELSE 0 END),3) AS net_revenue,
    ROUND(SUM(CASE WHEN o.is_cancelled=0 AND o.order_value>=0
              THEN (o.order_value* r.commission_percentage/100) - o.discount_applied + o.delivery_fee
             ELSE 0 END)
        / COUNT(DISTINCT u.user_id),2)   AS revenue_per_user,
    ROUND(AVG(CASE WHEN o.is_cancelled=0 AND o.order_value>=0
              THEN o.discount_applied END),2 ) AS avg_discount_per_order
    
FROM users u
LEFT JOIN orders o on u.user_id = o.user_id
LEFT JOIN restaurants r  ON o.restaurant_id = r.restaurant_id
GROUP BY u.acquisition_channel;

-- Duplicate Order IDs
SELECT order_id, COUNT(*) AS occurrences
FROM orders
GROUP BY order_id HAVING COUNT(*) > 1;
SELECT 
COUNT(*) - COUNT(DISTINCT order_id) AS count
FROM orders ;

-----3 month revenue cohort 
SELECT
    DATEFROMPARTS(YEAR(u.signup_date), MONTH(u.signup_date), 1) AS cohort_month,
    u.acquisition_channel,
       SUM(CASE WHEN o.is_cancelled=0 AND o.order_value>=0
              THEN (o.order_value* r.commission_percentage/100) - o.discount_applied + o.delivery_fee
             ELSE 0 END) AS revenue_3_months
FROM users u
LEFT JOIN orders o
    ON u.user_id = o.user_id
    AND o.order_date >= u.signup_date
    AND o.order_date < DATEADD(MONTH, 3, u.signup_date)
    LEFT JOIN restaurants r  ON o.restaurant_id = r.restaurant_id
GROUP BY
    DATEFROMPARTS(YEAR(u.signup_date), MONTH(u.signup_date), 1),
    u.acquisition_channel
ORDER BY cohort_month;

-- Negative order values
SELECT
    is_cancelled,
    COUNT(*) AS count,
    SUM(order_value) AS total_value
FROM orders
WHERE order_value < 0
GROUP BY is_cancelled;

-- Null delivery times
SELECT COUNT(*) AS null_delivery_times
FROM orders
WHERE delivery_time_minutes IS NULL;



IF OBJECT_ID('tempdb..#Ranked_Performance') IS NOT NULL
    DROP TABLE #Ranked_Performance;

WITH Order_Stats AS (
    SELECT 
        restaurant_id,
        COUNT(*) AS total_orders,
        SUM(CASE WHEN is_cancelled = 1 THEN 1 ELSE 0 END) AS cancelled_orders
    FROM orders
    WHERE order_value >= 0 
    GROUP BY restaurant_id
),

Complaint_Stats AS (
    SELECT 
        o.restaurant_id,
        COUNT(DISTINCT c.complaint_id) AS total_complaints
    FROM complaints c
    JOIN orders o ON c.order_id = o.order_id
    GROUP BY o.restaurant_id
),

Combined_Data AS (
    
    SELECT 
        r.restaurant_id,
        r.commission_percentage,
        COALESCE(os.total_orders, 0) AS total_orders,
        COALESCE(os.cancelled_orders, 0) AS cancelled_orders,
        COALESCE(cs.total_complaints, 0) AS total_complaints
    FROM restaurants r
    LEFT JOIN Order_Stats os ON r.restaurant_id = os.restaurant_id
    LEFT JOIN Complaint_Stats cs ON r.restaurant_id = cs.restaurant_id
    WHERE os.total_orders > 10 
)


SELECT 
    *,
    (CAST(total_complaints AS FLOAT) / NULLIF(total_orders, 0)) AS complaint_rate,
    (CAST(cancelled_orders AS FLOAT) / NULLIF(total_orders, 0)) AS cancellation_rate,
    --  Percentile Ranks (0 = Lowest/Best, 1 = Highest/Worst)
    PERCENT_RANK() OVER (ORDER BY (CAST(total_complaints AS FLOAT) / NULLIF(total_orders, 0)) DESC) AS complaint_rank_pct,
    PERCENT_RANK() OVER (ORDER BY (CAST(cancelled_orders AS FLOAT) / NULLIF(total_orders, 0)) DESC) AS cancellation_rank_pct
INTO #Ranked_Performance
FROM Combined_Data;

-- Bottom 10% Restaurants by Complaint Rate (Highest Complaints)
SELECT restaurant_id, complaint_rate, commission_percentage
FROM #Ranked_Performance
WHERE complaint_rank_pct <= 0.10
ORDER BY complaint_rate DESC;

--  Bottom 10% Restaurants by Cancellation Rate (Highest Cancellations)
SELECT restaurant_id, cancellation_rate, commission_percentage
FROM #Ranked_Performance
WHERE cancellation_rank_pct <= 0.10
ORDER BY cancellation_rate DESC;

-- Compare Commission Percentage (Best vs Worst)
WITH Ranks_Fixed AS (
    SELECT 
        *,
        PERCENT_RANK() OVER (ORDER BY complaint_rate ASC) AS complaint_rank_best,
        PERCENT_RANK() OVER (ORDER BY cancellation_rate ASC) AS cancellation_rank_best
    FROM #Ranked_Performance
)
SELECT 
    'Complaint Performance' AS metric_type,
    'Bottom 10% (Worst)' AS segment,
    AVG(commission_percentage) AS avg_commission
FROM Ranks_Fixed
WHERE complaint_rank_pct <= 0.10 

UNION ALL

SELECT 
    'Complaint Performance' AS metric_type,
    'Top 10% (Best)' AS segment,
    AVG(commission_percentage) AS avg_commission
FROM Ranks_Fixed
WHERE complaint_rank_best <= 0.10kkk

UNION ALL

SELECT 
    'Cancellation Performance' AS metric_type,
    'Bottom 10% (Worst)' AS segment,
    AVG(commission_percentage) AS avg_commission
FROM Ranks_Fixed
WHERE cancellation_rank_pct <= 0.10

UNION ALL

SELECT 
    'Cancellation Performance' AS metric_type,
    'Top 10% (Best)' AS segment,
    AVG(commission_percentage) AS avg_commission
FROM Ranks_Fixed
WHERE cancellation_rank_best <= 0.10;

-- Step 1: Calculate per-customer average transactions per month (since signup)
WITH CustomerFrequency AS (
    SELECT
        u.id AS customer_id,
        -- Calculate number of months since user joined (at least 1 to avoid division by zero)
        GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 1) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        -- Compute average successful transactions per month
        ROUND(COUNT(s.id) / GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 1), 2) AS avg_transactions_per_month
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s 
        ON u.id = s.owner_id 
        AND s.transaction_status = 'success'  -- Only successful transactions
    WHERE u.is_active = 1 AND u.is_account_deleted = 0  -- Only valid, active users
    GROUP BY u.id, u.date_joined
)

-- Step 2: Categorize frequency and count customers in each group
SELECT
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM CustomerFrequency
GROUP BY frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');

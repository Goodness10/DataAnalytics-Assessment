-- CTE to compute tenure, transaction count, and average profit per transaction
WITH CustomerMetrics AS (
    SELECT 
        u.id AS customer_id, -- Customer ID from users_customuser
        -- Concatenate first_name and last_name, handle nulls, fallback to 'Unknown'
        COALESCE(TRIM(CONCAT(COALESCE(u.first_name, ''), ' ', COALESCE(u.last_name, ''))), 'Unknown') AS name,
        -- Calculate tenure in months from date_joined to current date (May 19, 2025)
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
        -- Count successful transactions
        COUNT(s.id) AS total_transactions,
        -- Calculate avg profit per transaction: 0.1% of confirmed_amount, convert kobo to naira
        (SUM(s.confirmed_amount * 0.001) / COUNT(s.id)) / 100 AS avg_profit_per_transaction
    FROM users_customuser u
    -- INNER JOIN ensures only customers with transactions are included
    INNER JOIN savings_savingsaccount s 
        ON u.id = s.owner_id
        AND s.transaction_status = 'success' -- Filter for successful transactions
    WHERE 
        u.is_active = 1 -- Only active users
        AND u.is_account_deleted = 0 -- Exclude deleted accounts
    GROUP BY u.id, u.first_name, u.last_name, u.date_joined -- Group by customer
)
-- Main query to compute CLV and format output
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    -- Calculate CLV: (transactions / tenure) * 12 * avg_profit, round to 2 decimals
    -- Use GREATEST to avoid division by zero for tenure
    ROUND(
        (total_transactions / GREATEST(tenure_months, 1)) * 12 * avg_profit_per_transaction,
        2
    ) AS estimated_clv
FROM CustomerMetrics
ORDER BY estimated_clv DESC; -- Sort by CLV, highest to lowest
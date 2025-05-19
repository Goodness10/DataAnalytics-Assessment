-- CTE to get the last inflow transaction per plan
WITH LastTransactions AS (
    SELECT 
        sa.plan_id,
        MAX(sa.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount sa
    WHERE sa.confirmed_amount > 0  -- only inflows
    GROUP BY sa.plan_id
)

-- Main query to flag inactive savings or investment plans
SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    lt.last_transaction_date,
    DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days
FROM plans_plan p
JOIN LastTransactions lt ON p.id = lt.plan_id
WHERE 
    DATEDIFF(CURDATE(), lt.last_transaction_date) > 365  -- No inflow in last year
    AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)  -- Limit to relevant plan types
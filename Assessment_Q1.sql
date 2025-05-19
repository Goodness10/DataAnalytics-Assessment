SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,

    -- Count distinct funded savings plans
    COUNT(DISTINCT CASE 
        WHEN p.is_regular_savings = 1 AND sa.confirmed_amount > 0 THEN p.id 
    END) AS savings_count,

    -- Count distinct funded investment plans
    COUNT(DISTINCT CASE 
        WHEN p.is_a_fund = 1 AND sa.confirmed_amount > 0 THEN p.id 
    END) AS investment_count,

    -- Sum all confirmed inflows and convert from kobo to naira
    ROUND(SUM(CASE 
        WHEN sa.confirmed_amount > 0 THEN sa.confirmed_amount 
        ELSE 0 
    END) / 100, 2) AS total_deposits

FROM users_customuser u

-- Join users to their plans
JOIN plans_plan p
    ON u.id = p.owner_id

-- Join plans to their savings/investment transactions
JOIN savings_savingsaccount sa
    ON sa.plan_id = p.id

-- Consider only funded transactions
WHERE sa.confirmed_amount > 0

-- Group by each user to compute metrics per customer
GROUP BY u.id, u.first_name, u.last_name

-- Filter only customers who have both savings and investment products
HAVING 
    savings_count > 0 
    AND investment_count > 0

-- Rank customers by their total deposits
ORDER BY total_deposits DESC;
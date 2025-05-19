# DataAnalytics-Assessment
This repository contains solutions to CowryWise Data Analytics SQL Assessment

I had issuses importing the database and creating the table. I resolved this by using phpMyAdmin. File size was large but I increased the file size limit on the Config part of the phpMyAdmin which allowed me to upload the file and the database and tables were created automatically

## QUESTION 1

1.I first joined the user_customuser, plans_plan and savings_savingsaccount tables using the foreign key relationships.

2.I used the CASE statement inside the COUNT(DISTINCT) block to count the number of unique funded savings using the is_regular_savings = 1 and investment plans using is_a_fund = 1. I filtered using confirmed_amount > 0 to ensure that they are funded.

3.I added up all the confirmed inflows and divided by 100 in order to convert from kobo to naira using 2 decimal places.

4.HAVING ensures that only customers with both product types are included

5.The final value is then sorted in desecending order.

## QUESTION 2

1. I created a CTE for the customers metrics by joining the two tables using LEFT JOIN. Using is_active =1 and is_account_deleted = 0 to include all active and non-deleted users were included and even those without transactions as 0. They might have future transactions so they are included in the analysis.

2. I included only successful transactions excluding pending or failed transactions

3. I used number of months since sign up and prevented division by zero by using GREATEST.

4. The total number of transactions per customer and average transactions was calculated.

5. The CASE statement was used to categorise the customers based on their average transactions per month

6. Finally, I aggregrated by category and ordered the result.

The challenge here is that I was in a dilemma in including customers with zero transaction. 

## QUESTION 3
1. I used CTE to first isolate the latest inflow transaction per plan which ensures that I access user activity based solely on actual deposits. 

2. I then joined this data with the plans_plan table and filtered for accounts where the number of days since last inflow is more than 365 days

3. I then limited the scope to just savings and investments plans. 

## QUESTION 4
1. I began by isolating, non-deleted customers with successful transactions, ensuring the data reflects engaged users only.

2. Using the formula for CLV (Customer Lifetime Value), the metrics used in the calculation was first derived using Common Table Expression (CTE) which are account tenure, total successful transactions and average profit per transaction. Also converting from kobo to naira.

3. To handle edge cases, I used the GREATEST () to prevent division by zero errors

4. I applied the CLV formular and sorted the result.

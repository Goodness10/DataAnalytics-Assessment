# DataAnalytics-Assessment
This repository contains solutions to CowryWise Data Analytics SQL Assessment

**QUESTION 1**

1.I first joined the user_customuser, plans_plan and savings_savingsaccount tables using the foreign key relationships.

2.I used the CASE statement inside the COUNT(DISTINCT) block to count the number of unique funded savings using the is_regular_savings = 1 and investment plans using is_a_fund = 1. I filtered using confirmed_amount > 0 to ensure that they are funded.

3.I added up all the confirmed inflows and divided by 100 in order to convert from kobo to naira using 2 decimal places.

4.HAVING ensures that only customers with both product types are included

5.The final value is then sorted in desecending order.

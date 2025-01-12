-- Ques 1:Count the no. of churned customers
SELECT COUNT(customerid) AS ChurnedCustomers
FROM billing_details
WHERE churn='Yes';

-- Ques 2: List of customers with having Internet Service.
SELECT customerid, internetservice
FROM services
WHERE internetservice='Yes';

-- Ques 3: Average monthy charges of all customers.
SELECT 
	ROUND(AVG(monthlycharges), 2) AS AVGMonthlyCharges
FROM billing_details;

-- Ques 4: Churn Rate by Contract Type. 
SELECT 
    Contract,
    COUNT(customerID) AS TotalCustomers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(customerID), 2) AS ChurnRate
FROM subscription_details 
JOIN billing_details USING (customerID)
GROUP BY Contract;

-- Ques 5: Top 3 Customers with the Highest Total Charges
SELECT 
    customerID, TotalCharges 
FROM billing_details 
ORDER BY TotalCharges DESC 
LIMIT 3;

-- Ques 6: Churn Rate by Internet Service type
SELECT 
    InternetService,
    COUNT(customerID) AS TotalCustomers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(customerID), 2) AS ChurnRate
FROM services 
JOIN billing_details USING (customerID)
GROUP BY InternetService;

-- Ques 7: Correlation Between Monthly Charges and Churn
-- Analyze if higher monthly charges lead to churn by categorizing customers into charge ranges.
SELECT 
    CASE 
        WHEN MonthlyCharges < 50 THEN '<$50'
        WHEN MonthlyCharges BETWEEN 50 AND 100 THEN '$50-$100'
        ELSE '>$100' 
    END AS ChargeRange,
    COUNT(customerID) AS TotalCustomers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(customerID), 2) AS ChurnRate
FROM billing_details
GROUP BY ChargeRange
ORDER BY ChurnRate DESC;

-- Ques 8: Services Combination Leading to High Churn
-- Identify combinations of services (e.g., Phone, Internet) with the highest churn rate.
SELECT 
    PhoneService,
    InternetService,
    COUNT(customerID) AS TotalCustomers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(customerID), 2) AS ChurnRate
FROM services 
JOIN billing_details USING (customerID)
GROUP BY PhoneService, InternetService
ORDER BY ChurnRate DESC;

-- Ques 9: Customer Segmentation by Tenure and Churn
-- Segment customers into tenure ranges and analyze their churn behavior.

SELECT 
    CASE 
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
        WHEN tenure BETWEEN 25 AND 36 THEN '25-36 months'
        ELSE '36+ months' 
    END AS TenureGroup,
    COUNT(customerID) AS TotalCustomers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(customerID), 2) AS ChurnRate
FROM subscription_details 
JOIN billing_details USING (customerID)
GROUP BY TenureGroup
ORDER BY ChurnRate DESC;
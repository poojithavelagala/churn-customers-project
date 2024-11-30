use customerchurn;
SELECT Customer_ID,
       CASE 
           WHEN Avg_Monthly_GB_Download < 5 
                AND Premium_Tech_Support = 'No' THEN 'High Risk'
           WHEN Avg_Monthly_GB_Download BETWEEN 5 AND 20 
                AND Premium_Tech_Support = 'No' THEN 'Moderate Risk'
           ELSE 'Low Risk'
       END AS Risk_Level
FROM cleaned_customer_churn;
select* from cleaned_customer_churn;
SELECT * FROM cleaned_customer_churn limit 1000 offset 1000;
ALTER TABLE cleaned_customer_churn  ADD COLUMN customer_risk VARCHAR(20);
UPDATE cleaned_customer_churn
SET customer_risk = 
    CASE
        WHEN CustomerStatus= 'Churned' OR Monthly_Charge > 80 OR Tenure_in_Months < 12 THEN 'High Risk'
        WHEN  Monthly_Charge BETWEEN 50 AND 80 THEN 'Moderate Risk'
        ELSE 'Low Risk'
    END;
SELECT Customer_ID, CustomerStatus, Monthly_Charge, Tenure_In_Months, customer_risk
FROM cleaned_customer_churn
LIMIT 10;
SELECT customer_id, churn_risk, monthly_charges, tenure, customer_segmentation
FROM cleaned_customer_churn
LIMIT 10;
SELECT * 
INTO OUTFILE '/path/to/cusromer segementaton_risk.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM cleaned_customer_churn;

select*from cleaned_customer_churn;
# table about the customers who are marriage and gender and age wise categorized to find churned customers
SELECT 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 40 THEN '25-40'
        WHEN Age BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
    END AS age_group,
    Gender,
    Married,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN CustomerStatus = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
    (SUM(CASE WHEN CustomerStatus = 'Churned' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS churn_rate
FROM cleaned_customer_churn
WHERE customer_risk = 'High Risk'
GROUP BY age_group, Gender, Married
ORDER BY churn_rate DESC;
# table of only high risk customers
SELECT *
FROM cleaned_customer_churn
WHERE customer_risk = 'High Risk';

# number of customers who are churned and who are in high risk and who are in churned high risk

SELECT 
    COUNT(*) AS total_high_risk_customers,
    SUM(CASE WHEN CustomerStatus = 'Churned' THEN 1 ELSE 0 END) AS churned_high_risk,
    (SUM(CASE WHEN CustomerStatus = 'Churned' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS churn_rate
FROM cleaned_customer_churn
WHERE customer_risk = 'High Risk';

# calculating the customers to monthly charges vs. total customers vs. churnes customers vs. churn rate.

SELECT 
    CASE 
        WHEN Monthly_Charge < 50 THEN 'Low (<$50)'
        WHEN Monthly_Charge BETWEEN 50 AND 100 THEN 'Medium ($50-$100)'
        ELSE 'High (>$100)'
    END AS charge_segment,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN CustomerStatus = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
    (SUM(CASE WHEN CustomerStatus = 'Churned' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS churn_rate
FROM cleaned_customer_churn
WHERE customer_risk = 'High Risk'
GROUP BY charge_segment
ORDER BY churn_rate DESC;

# probability of churnred vs active
SELECT 
    status,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) / (SELECT COUNT(*) FROM Customerstatus) * 100, 2) AS probability_percentage
FROM 
    cleaned_customer_churn
GROUP BY 
    status;

CREATE DATABASE telco_churn;
USE telco_churn;
CREATE TABLE customer_churn (
    customerID VARCHAR(50),
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(10),
    Dependents VARCHAR(10),
    tenure INT,
    PhoneService VARCHAR(10),
    MultipleLines VARCHAR(20),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(20),
    OnlineBackup VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport VARCHAR(20),
    StreamingTV VARCHAR(20),
    StreamingMovies VARCHAR(20),
    Contract VARCHAR(20),
    PaperlessBilling VARCHAR(10),
    PaymentMethod VARCHAR(50),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges DECIMAL(10,2),
    Churn VARCHAR(10)
);
SET GLOBAL local_infile = 1;
LOAD DATA LOCAL INFILE 'C:/Users/hp/Documents/Telco Customer Churn.csv'
INTO TABLE customer_churn
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customerID, gender, SeniorCitizen, Partner, Dependents, tenure, PhoneService, 
 MultipleLines, InternetService, OnlineSecurity, OnlineBackup, DeviceProtection, 
 TechSupport, StreamingTV, StreamingMovies, Contract, PaperlessBilling, 
 PaymentMethod, MonthlyCharges, TotalCharges, Churn);
UPDATE customer_churn
SET TotalCharges = NULL
WHERE TRIM(TotalCharges) = '';
ALTER TABLE customer_churn
MODIFY TotalCharges DECIMAL(10,2);
SELECT COUNT(*) AS missing_TotalCharges
FROM customer_churn
WHERE TotalCharges IS NULL;
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM customer_churn;
SELECT 
    gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM customer_churn
GROUP BY gender
ORDER BY churn_rate_percent DESC;
SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM customer_churn
GROUP BY Contract
ORDER BY churn_rate_percent DESC;
SELECT 
    CASE 
        WHEN tenure BETWEEN 0 AND 12 THEN '0-1 Year'
        WHEN tenure BETWEEN 13 AND 24 THEN '1-2 Years'
        WHEN tenure BETWEEN 25 AND 48 THEN '2-4 Years'
        WHEN tenure BETWEEN 49 AND 72 THEN '4-6 Years'
        ELSE '6+ Years'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM customer_churn
GROUP BY tenure_group
ORDER BY tenure_group;
SELECT 
    Churn,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(AVG(TotalCharges), 2) AS avg_total_charges
FROM customer_churn
GROUP BY Churn;
SELECT 
    customerID,
    MonthlyCharges,
    tenure,
    ROUND(MonthlyCharges * tenure, 2) AS estimated_clv,
    Churn
FROM customer_churn
LIMIT 10;
SELECT 
    Contract,
    ROUND(AVG(MonthlyCharges * tenure), 2) AS avg_clv
FROM customer_churn
GROUP BY Contract
ORDER BY avg_clv DESC;
SELECT 
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN TotalCharges ELSE 0 END), 2) AS revenue_lost,
    ROUND(SUM(CASE WHEN Churn = 'No' THEN TotalCharges ELSE 0 END), 2) AS retained_revenue
FROM customer_churn;
SELECT 
    InternetService,
    ROUND(AVG(MonthlyCharges * tenure), 2) AS avg_clv,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM customer_churn
GROUP BY InternetService
ORDER BY churn_rate_percent DESC;
SELECT 
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM customer_churn
GROUP BY PaymentMethod
ORDER BY churn_rate_percent DESC;
SELECT 
    TechSupport,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM customer_churn
GROUP BY TechSupport
ORDER BY churn_rate_percent DESC;
SELECT 
    OnlineSecurity,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM customer_churn
GROUP BY OnlineSecurity
ORDER BY churn_rate_percent DESC;
SELECT 
    PaperlessBilling,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM customer_churn
GROUP BY PaperlessBilling
ORDER BY churn_rate_percent DESC;
SELECT 
    Partner,
    Dependents,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_percent
FROM customer_churn
GROUP BY Partner, Dependents
ORDER BY churn_rate_percent DESC;
SELECT 
    Contract,
    InternetService,
    TechSupport,
    PaperlessBilling,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS churn_rate_percent,
    COUNT(*) AS segment_size
FROM customer_churn
GROUP BY Contract, InternetService, TechSupport, PaperlessBilling
HAVING COUNT(*) > 20
ORDER BY churn_rate_percent DESC
LIMIT 5;

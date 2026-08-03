CREATE DATABASE hr_analytics_db;
USE hr_analytics_db;
CREATE TABLE Employee_attrition(
	Age INT,
    Attrition VARCHAR(10),
    BusinessTravel VARCHAR(50),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT PRIMARY KEY,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(20),
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 CHAR(1),
    OverTime VARCHAR(10),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);
SELECT * FROM employee_attrition;
SELECT count(*) as total_rows
FROM employee_attrition;
-- Scenario1:
-- HR director wants to know the total workforce and average employee age & Average years at company.
SELECT COUNT(employeenumber) AS total_employees,
       avg(Age) AS Avg_Age,
       avg(Monthlyincome) AS Avg_Monthly_Income,
       avg(yearsatcompany) AS Avg_years_at_company
FROM employee_attrition;
-- The HR Head wants to know which department has the highest employee attrition.
SELECT Department,
       COUNT(EmployeeNumber) AS TotalEmployees,
       SUM(
       CASE
       WHEN Attrition="Yes" THEN 1
       ELSE 0
       END) AS Employees_left,
	ROUND(
         SUM(
		 CASE
         WHEN Attrition ="Yes" THEN 1
         ELSE 0
         END)*100.0
         /COUNT(EmployeeNumber),
         2
         ) AS Attrition_Percentage
FROM employee_attrition
GROUP BY department
ORDER BY Attrition_Percentage DESC;
-- Overall company attrition(%)
SELECT COUNT(employeenumber) AS Total_Employees,
       SUM(
       CASE
       WHEN Attrition="Yes" THEN 1
       ELSE 0
       END) AS Employees_Left,
	ROUND(
          SUM(
          CASE 
          WHEN Attrition="Yes" THEN 1
          ELSE 0
          END)*100.0
          /COUNT(EmployeeNumber),
          2) AS Attrition_Percentage
FROM employee_attrition;
       
-- HR wants to identify the Top 5 Job Roles with the highest attrition percentage.
SELECT JobRole,
       COUNT(employeenumber) AS Total_Employees,
       SUM(
       CASE
       WHEN Attrition="yes" THEN 1
       ELSE 0
       END) AS Employees_left,
	ROUND(
          SUM(
              CASE
              WHEN Attrition="Yes" THEN 1
              ELSE 0
              END) * 100.0
              / COUNT(employeenumber),
              2) AS Attrition_Percentage
FROM employee_attrition
GROUP BY JobRole
ORDER BY Attrition_Percentage DESC
LIMIT 5;

-- HR wants to know the average monthly income for each department.
SELECT Department,
       avg(MonthlyIncome) AS Average_MonthlyIncome
FROM employee_attrition
GROUP BY Department
ORDER BY Average_MonthlyIncome DESC;

-- HR wants to identify employees earning more than the company-wide average monthly income.
SELECT EmployeeNumber,
       Department,
       JobRole,
       MonthlyIncome
FROM employee_attrition
WHERE MonthlyIncome>(
SELECT AVG(MonthlyIncome)
FROM employee_attrition
);
-- HR wants to rank all departments based on their average monthly income.
SELECT Department,
       avg(MonthlyIncome)AS Average_MonthlyIncome,
       RANK() OVER(ORDER BY avg(MonthlyIncome) DESC) AS Ranks
FROM employee_attrition
GROUP BY Department;
--  Which education fields have the highest employee attrition percentage?
SELECT EducationField,
       COUNT(EmployeeNumber) as Total_employees,
       SUM(
       CASE
       WHEN Attrition="Yes" THEN 1
       ELSE 0
       END) AS Employees_left,
	ROUND(
          SUM(
          CASE
          WHEN Attrition = "Yes" THEN 1
          ELSE 0
          END)*100.0
          /COUNT(EmployeeNumber),
          2) AS Attrition_Percentage
FROM employee_attrition
GROUP BY EducationField
ORDER BY Attrition_Percentage DESC;

-- Which age groups have the highest employee attrition percentage?
SELECT
	CASE 
      WHEN Age BETWEEN 18 AND 25 THEN "18-25"
      WHEN Age BETWEEN 26 AND 35 THEN "26-35"
      WHEN Age BETWEEN 36 AND 45 THEN "36-45"
      ELSE "56+"
	END AS Age_Group,
    COUNT(EmployeeNumber) AS Total_Employees,
    SUM(
        CASE 
        WHEN Attrition = "Yes" THEN 1
        ELSE 0
        END) AS Employees_left,
	ROUND(
          SUM(
          CASE 
		  WHEN Attrition = "Yes" THEN 1
          ELSE 0
		  END)*100.0
          /COUNT(EmployeeNumber),
          2) AS Attrition_percentage
FROM Employee_Attrition
GROUP BY Age_Group
ORDER BY Attrition_percentage DESC;
        
-- How does employee attrition differ between male and female employees?
SELECT Gender,
       COUNT(EmployeeNumber) AS Total_Employees,
       SUM(
           CASE 
           WHEN Attrition="Yes" THEN 1
           ELSE 0
           END) AS Employees_left,
		ROUND(
              SUM(
                  CASE 
                  WHEN Attrition="Yes" THEN 1
				  ELSE 0
                  END)*100.0
                  /COUNT(EmployeeNumber),
                  2) AS Attrition_Percentage
FROM employee_attrition
GROUP BY Gender
ORDER BY Attrition_percentage DESC;

SELECT * FROM
employee_attrition;

-- How does overtime impact employee attrition?
SELECT OverTime,
	  COUNT(EmployeeNumber) AS Total_employees,
      SUM(
      CASE
	  WHEN Attrition="YES" THEN 1
      ELSE 0
      END) AS Employees_left,
      ROUND(
            SUM(
            CASE 
			WHEN Attrition="Yes" THEN 1
            ELSE 0
            END)*100.0
            /COUNT(EmployeeNumber),
            2) AS Attrition_Percentage
FROM employee_attrition
GROUP BY Overtime
ORDER BY Attrition_percentage DESC;

-- Which salary slab has the highest employee attrition percentage?
SELECT min(MonthlyIncome) AS Min_salary,
       MAX(MonthlyIncome) AS Max_salary
FROM employee_attrition;

SELECT 
       CASE 
       WHEN MonthlyIncome BETWEEN 1000 AND 5000 THEN "Low Salary"
       WHEN MonthlyIncome BETWEEN 5001 AND 10000 THEN "Medium Salary"
       WHEN MonthlyIncome BETWEEN 10001 AND 15000 THEN "High Salary"
       ELSE "Very High Salary"
       END AS Salary_slabs,
       COUNT(EmployeeNumber) AS Total_employees,
       SUM(
           CASE
           WHEN Attrition="Yes" THEN 1
           ELSE 0
           END) AS Employees_Left,
	   ROUND(
             SUM(
                  CASE
           WHEN Attrition="Yes" THEN 1
           ELSE 0
           END)*100.0
           /COUNT(EmployeeNumber),
           2) AS Attrition_Percentage
FROM employee_attrition
GROUP BY Salary_slabs
ORDER BY Attrition_Percentage DESC;
             
-- How does employee attrition vary based on years spent at the company?
SELECT  
           CASE
			WHEN YearsAtCompany BETWEEN 0 AND 2 THEN "New Employee"
            WHEN YearsAtCompany BETWEEN 3 AND 5 THEN "Early Career"
            WHEN YearsAtCompany BETWEEN 6 AND 10 THEN "Mid Career"
            ELSE "Long Tenure"
            END AS ExperienceGroup,
	   count(EmployeeNumber) AS total_employees,
       SUM(
           CASE
           WHEN Attrition ="Yes" THEN 1
           ELSE 0
           END) AS Employees_left,
	  ROUND(
            SUM(
                CASE 
                 WHEN Attrition ="Yes" THEN 1
				 ELSE 0
                 END)*100.0
                 /COUNT(EmployeeNumber),
                 2) AS Attrition_Percentage
FROM employee_attrition
GROUP BY ExperienceGroup
ORDER BY Attrition_percentage DESC;
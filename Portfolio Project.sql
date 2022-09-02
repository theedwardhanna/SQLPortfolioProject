--In this portfolio project, I have demonstrated my ability to use various SQL skills and functions, retrieve and manipulate data,
-- joins, CTE's, temp tables, stored procedures and subqueries:



--Creating two tables and inserting datasets:
Create Table EmployeeDemographics
(EmployeeID int,
FirstName varchar(50),
LastName varchar(50),
Age int,
Gender varchar(50))

Create Table EmployeeSalary
(EmployeeID int,
JobTitle varchar(50),
Salary int)

Insert into EmployeeDemographics values
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male'),
(1011, 'Ryan', 'Howard', 26, 'Male'),
(NULL, 'Holly','Flax', NULL, 'Male'),
(1013, 'Darryl', 'Philbin', NULL, 'Male')

Insert into EmployeeSalary values
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000),
(1010, NULL, 47000),
(NULL, 'Salesman', 43000)

Select *
From PortfolioProject.dbo.EmployeeDemographics

Select Top 5 *
From PortfolioProject.dbo.EmployeeDemographics

Select Distinct(Gender)
From PortfolioProject.dbo.EmployeeDemographics

Select Count(LastName) as 'Last Name Count'
From PortfolioProject..EmployeeDemographics

Select Max(Age) 'Maximum Age'
From PortfolioProject..EmployeeDemographics

Select Min(Salary) 'Minimum Salary'
From PortfolioProject..EmployeeSalary

Select Avg(Salary) 'Average Salary'
From PortfolioProject..EmployeeSalary

Select *
From EmployeeDemographics
Where FirstName = 'Jim'

Select *
From EmployeeDemographics
Where FirstName <> 'Jim'

Select *
From EmployeeSalary
Where Salary > 40000

Select *
From EmployeeDemographics
Where Age <= 32 or Gender = 'Male'

Select *
From EmployeeDemographics
Where LastName like '%s%o%'

Select *
From EmployeeDemographics
Where EmployeeID is not null


--Finding all employees where first name is 'Jim' or 'Michael'
Select *
From EmployeeDemographics
Where FirstName in ('Jim', 'Michael')


--Seeing how many males and females are working at the company over 31
Select Gender, Count(Gender) as 'Gender count'
From EmployeeDemographics
Where Age > 31
Group by Gender


--Ordering the required information in ascending order based on first name
Select FirstName, LastName, Age
From EmployeeDemographics
Order by 1


--Left outer joins combine everything from the EmployeeDemographics table and any values which match with the EmployeeSalary table:
--(It will leave any additional information from the EmployeeSalary table)
Select *
From EmployeeDemographics
Left Outer Join EmployeeSalary
	On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID


--In this case, we know Michael is the highest paid colleague and are trying to find the second highest paid colleague:
Select EmployeeDemographics.EmployeeID, FirstName, LastName, Salary
From EmployeeDemographics
Join EmployeeSalary
	On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
Where FirstName <> 'Michael'
Order by Salary Desc


--Finding the average salary of the salesman:
Select JobTitle, Avg(Salary) as 'Job title average salary'
From EmployeeDemographics
Join EmployeeSalary
	On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
Where JobTitle = 'Salesman'
Group by JobTitle


--Creating a new table:
Create Table WareHouseEmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50))

Insert into WareHouseEmployeeDemographics VALUES
(1013, 'Darryl', 'Philbin', NULL, 'Male'),
(1050, 'Roy', 'Anderson', 31, 'Male'),
(1051, 'Hidetoshi', 'Hasagawa', 40, 'Male'),
(1052, 'Val', 'Johnson', 31, 'Female')


--Unions collect all the data and combine it into one output instead of being in two columns as with a join:
Select *
From EmployeeDemographics
Union 
--Union removes the duplicate (in this case, 'Darryl Philbin'). Union All will keep both instances in the output
Select *
From WareHouseEmployeeDemographics


Select FirstName, LastName, Age,
Case
	When Age > 30 then 'Old'
	When Age between 27 and 30 then 'Middle'
	Else 'Young'
End as 'Age ranking'
From EmployeeDemographics
Where Age is not null
Order by Age


--Giving pay raises relative to job title:
Select FirstName, LastName, JobTitle, Salary,
Case
	When JobTitle = 'Salesman' then 1.1 * Salary
	When JobTitle = 'Accountant' then 1.05 * Salary
	When JobTitle = 'HR' then 1.01 * Salary
	Else Salary + (Salary * .03)
End as 'Salary after raise'
From EmployeeDemographics
Join EmployeeSalary
	On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID


--Having statements have to go after 'group by' statements because we can't look at aggregated information 
--before it has been aggregated with the 'group by' function:
Select JobTitle, Count(JobTitle) as 'Job title count', Avg(Salary) as 'Average salary'
From EmployeeDemographics
Join EmployeeSalary
	On EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
Group by JobTitle
Having Avg(Salary) > 45000
Order by Avg(Salary)


--Updating information to give 'Holly Flax' an EmployeeID, Age and Gender:
Update EmployeeDemographics
Set EmployeeID = 1012, Age = 31, Gender = 'Female'
Where FirstName = 'Holly' and LastName = 'Flax'


--Removing information from table (I am checking I have located the correct values I want to remove before
--deleting the data as I can't reverse the deletion):
--Select *
--From EmployeeDemographics
--Where EmployeeID = 1005
Delete from EmployeeDemographics
Where EmployeeID = 1005


--Aliasing:
Select FirstName + ' ' + LastName 'Full Name'
From EmployeeDemographics

--Renaming the tables to input data quicker and reduce unncessarily long names in code:
Select Demo.EmployeeID, Sal.Salary
From EmployeeDemographics as Demo
Join EmployeeSalary as Sal
	On Demo.EmployeeID = Sal.EmployeeID


--Partition by statements allow us to isolate one column we want to perform our aggregate function on
--and add additional information we may not need to perform functions on:
Select FirstName, LastName, Gender, Salary, Count(Gender) over (partition by Gender) as 'Total Gender'
From EmployeeDemographics Demo
Join EmployeeSalary Sal
	On Demo.EmployeeID = Sal.EmployeeID


With CTE_Employee as
(Select FirstName, LastName, Gender, Salary,
Count(Gender) over (partition by Gender) as 'Total gender count',
Avg(Salary) over (partition by Gender) as 'Average salary'
From EmployeeDemographics Emp
Join EmployeeSalary Sal
	On Emp.EmployeeID = Sal.EmployeeID
Where Salary > 45000)
Select *
From CTE_Employee

--Temp tables allow us to place values into temporary table and allow us to perform functions/calculations in less time: 
Create table #Temp_Employee
(EmployeeID int,
JobTitle varchar(100),
Salary int)

Insert into #Temp_Employee
Select *
From EmployeeSalary

Select JobTitle
From #Temp_Employee

Drop table if exists #Temp_Employee2
Create table #Temp_Employee2
(JobTitle varchar(50),
EmployeesPerJob int,
AvgAge int,
AvgSalary int)

Insert into #Temp_Employee2
Select JobTitle, Count(JobTitle), Avg(Age), Avg(Salary)
From EmployeeDemographics Emp
Join EmployeeSalary Sal
	On Emp.EmployeeID = Sal.EmployeeID
Group by JobTitle

Select *
From #Temp_Employee2


--String functions:
Create table EmployeeErrors
(EmployeeID varchar (50),
FirstName varchar(50),
LastName varchar(50))

Insert into EmployeeErrors values
('1001  ', 'Jimbo', 'Halbert'),
('  1002', 'Pamela', 'Beasely'),
('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

--Get rid of blank spaces in EmployeeID with trim function:
Select EmployeeID, Trim(EmployeeID) as 'ID trimmed'
From EmployeeErrors

--Using replace function:
Select LastName, Replace(LastName, '- Fired', '') as 'Last name fixed'
From EmployeeErrors

--Using substring function to tidy data and get values to match:
Select Substring(Err.FirstName,1,3), Substring(Demo.FirstName,1,3), Substring(Err.LastName,1,3), Substring(Demo.LastName,1,3)
From EmployeeErrors Err
Join EmployeeDemographics Demo
	On Substring(Err.FirstName,1,3) = Substring(Demo.FirstName,1,3)
	and Substring(Err.LastName,1,3) = Substring(Demo.LastName,1,3)


--Using upper and lower functions:
Select FirstName, Lower(FirstName) as 'Lower first name'
From EmployeeErrors

Select Firstname, UPPER(FirstName) as 'Upper first name'
From EmployeeErrors


--Creating and modifying stored procedures:
Create Procedure Test
As
Select *
From EmployeeDemographics
Exec Test


Create Procedure Temp_Employees
As
Create table #Temp_Employees
(JobTitle varchar(100),
EmployeesPerJob int,
AvgAge int,
AvgSalary int)

Insert into #Temp_Employees
Select JobTitle, Count(JobTitle), Avg(Age), Avg(Salary)
From EmployeeDemographics Emp
Join EmployeeSalary Sal
	On Emp.EmployeeID = Sal.EmployeeID
Group by JobTitle

Select *
From #Temp_Employees
Exec Temp_Employees @JobTitle = 'Salesman'


--Introducing subqueries:
Select *
From EmployeeSalary

--Subquery in select function:
Select EmployeeID, Salary, (Select Avg(Salary) from EmployeeSalary) as 'All average salary'
From EmployeeSalary

--Subquery with partition by:
Select EmployeeID, Salary, Avg(Salary) over () as 'All average salary'
From EmployeeSalary

--Why group by does't work:
Select EmployeeID, Salary, Avg(Salary) over () as 'All average salary'
From EmployeeSalary
Group by EmployeeID, Salary
Order by 1,2

--Subquery in from:
Select a.EmployeeID, AllAvgSalary
From (Select EmployeeID, Salary, Avg(Salary) over () as AllAvgSalary From EmployeeSalary) a

--Subquery in where:
Select EmployeeID, JobTitle, Salary
From EmployeeSalary
Where EmployeeID in
	(Select EmployeeID
	From EmployeeDemographics
	Where Age > 30)
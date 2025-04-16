use SD

CREATE TABLE Department( 
	DeptNo varchar(2) primary key,
	DeptName varchar(20),
	Location loc
)
---

CREATE TYPE loc from nchar(2) NOT NULL

CREATE rule locDT as @x in('NY','DS','KW')
sp_bindrule loc,locDT

CREATE default def AS 'NY'
sp_bindefault def, loc

---
INSERT INTO Department
VALUES(
	'd1','Research','NY'),
	('d2','Accounting','DS'),
	('d3','Marketing','KW')


----- Employee Table
CREATE TABLE Employee
(
	EmpNo int,
	Emp_Fname varchar(50),
	Emp_Lname varchar(50),
	DeptNo varchar(2),
	Salary int,

CONSTRAINT c1 PRIMARY KEY(EmpNo),
CONSTRAINT c2 FOREIGN KEY (DeptNo) REFERENCES Department(DeptNo),
CONSTRAINT c3 UNIQUE (Salary),
CONSTRAINT c4 CHECK (Emp_Fname IS NOT NULL 
	AND Emp_Lname IS NOT NULL)
)

INSERT INTO Employee
VALUES(
	25348, 'Mathew', 'Smith', 'd3', 2500),
	(10102, 'Ann', 'Jones', 'd3', 3000),
	(18316,'John' ,'Barrimore','d1', 2400),
	(29346, 'James', 'James', 'd2', 2800),
	(9031, 'Lisa', 'Bertoni', 'd2', 4000),
	(2581,'Elisa' ,'Hansel', 'd2',3600),
	(28559,'Sybl' ,'Moser' ,'d1',2900)

CREATE RULE R_SALARY AS @salary < 6000
sp_bindrule R_SALARY,'Employee.Salary'


----1-Add new employee with EmpNo =11111 In the works_on table
INSERT INTO Works_on 
VALUES(11111,'p1','Analyst','2006.10.1') ---ERROR: The INSERT statement conflicted with the FOREIGN KEY constraint "FK_Works_on_Employee1". The conflict occurred in database "SD", table "dbo.Employee", column 'EmpNo'.

----2-Change the employee number 10102 to 11111 in the works on table
UPDATE Works_on
	SET EmpNo = 11111
	WHERE EmpNo = 10102 ---ERROR

----3.Modify the employee number 10102 in the employee table to 22222.
UPDATE Works_on
	SET EmpNo = 222222
	WHERE EmpNo = 10102 ---FAIL

----4.Delete the employee with id 10102
DELETE FROM Employee
WHERE EmpNo = 10102 ---the refrence must be deleted

---------------------

---2. a 
CREATE SCHEMA Company

CREATE SCHEMA HumanResource

ALTER SCHEMA Company TRANSFER Department
ALTER SCHEMA HumanResource TRANSFER Employee

---3.Write query to display the constraints for the Employee table.
SELECT * 
FROM 
	INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Employee'

---4.
CREATE synonym Emp for Employee

Select * from Employee ---ERROR: Employee in HumanResource SCHEMA not in dbo
Select * from HumanResource.Employee ---IT WORKS AS I gave the humanresource.employee a synonym called Emp
Select * from Emp ---ERROR: Employee in HumanResource SCHEMA not in dbo
Select * from HumanResource.Emp ---ERROR: It doesn't work because Emp is a synonym and it contains the humanresource schema inside it.

---5.Increase the budget of the project where the manager number is 10102 by 10%.
UPDATE Project 
	SET Budget += Budget*0.1
	FROM Project JOIN  dbo.Works_on
		ON Project.ProjectNo = Works_on.ProjectNo
	WHERE Works_on.EmpNo = 10102

---6. Change the name of the department for which the employee named James works. The new department name is Sales.
UPDATE Company.Department
	SET DeptName = 'Sales'
	FROM  Company.Department JOIN HumanResource.Employee
		ON  Company.Department.DeptNo = HumanResource.Employee.DeptNo
	WHERE HumanResource.Employee.Emp_Fname = 'James'


---7. Change the enter date for the projects for those employees who
---work in project p1 and belong to department ‘Sales’. The new date is
---12.12.2007.
UPDATE  dbo.Works_on
	SET Enter_date ='2007/12/12'
	FROM 
		HumanResource.Employee e JOIN Company.Department d
	ON e.DeptNo = d.DeptNo 
WHERE d.DeptName = 'sales' AND d.DeptNo = 'p1'

---8. Delete the information in the works_on table for all employees who work for the department located in KW
DELETE FROM works_on 
WHERE EmpNo IN(
	SELECT EmpNo 
	FROM Company.Department d join HumanResource.Employee e 
	ON d.DeptNo =e.DeptNo 
WHERE location = 'KW')


---9.Try to Create Login Named(ITIStud) who can access Only student and Course tablesfrom ITI DB then allow him to select and insert data into tables and deny Delete and update .(Use ITI DB)
---DONE USING WIZARD

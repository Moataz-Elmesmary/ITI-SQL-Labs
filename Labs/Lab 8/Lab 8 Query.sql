USE ITI

--1.	 Create a view that displays student full name, course name if the student has a grade more than 50. 
CREATE VIEW vgrade
AS
SELECT 
	CONCAT(s.st_fname, ' ', s.St_Lname) AS fullName,
	c.crs_name,
	sc.Grade
FROM student s JOIN Stud_Course sc
	ON s.St_Id = sc.St_Id
JOIN Course c 
	ON sc.Crs_Id = c.Crs_Id
WHERE sc.Grade > 50

SELECT * FROM vgrade

--2.	 Create an Encrypted view that displays manager names and the topics they teach. 
CREATE VIEW vmgr_topic
WITH ENCRYPTION
AS
SELECT
	i.Ins_Name,
	c.Crs_Name
FROM Instructor i JOIN Department d
	ON i.Ins_Id = d.Dept_Manager
JOIN Ins_Course ic 
	ON i.Ins_Id = ic.Ins_Id
JOIN Course c 
	ON ic.Crs_Id = c.Crs_Id

SELECT * FROM vmgr_topic


--3.	Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 
CREATE VIEW vins_Dept
AS
SELECT
	i.Ins_Name,
	d.Dept_Name

FROM Instructor i JOIN Department d
	ON i.Dept_Id = d.Dept_Id
WHERE d.Dept_Name IN ('SD','Java')

SELECT * FROM vins_Dept


--4.	 Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
--Note: Prevent the users to run the following query 
--Update V1 set st_address=’tanta’
--Where st_address=’alex’;
CREATE VIEW V1
AS
SELECT *
FROM Student
WHERE St_Address IN ('Cairo', 'Alex')
WITH CHECK OPTION

UPDATE V1                --PREVENTED
	SET st_address = 'tanta'
WHERE st_address = 'alex'

SELECT * FROM V1


--5.	Create a view that will display the project name and the number of employees work on it. “Use SD database”
USE Company_SD

CREATE VIEW vproj_Emp
AS
SELECT
	p.Pname,
	COUNT(w.essn) [Count Of Emp]
FROM Project p JOIN Works_for w 
	ON p.Pnumber=w.Pno
GROUP BY p.Pname

SELECT * FROM vproj_Emp

--6.	Create index on column (Hiredate) that allow u to cluster the data in table Department. What will happen?
USE ITI
CREATE CLUSTERED INDEX i -- A cluster is already existed on the primary key,
	ON department (manager_hiredate) --so this aint working

--7.	Create index that allow u to enter unique ages in student table. What will happen? 
CREATE UNIQUE INDEX i_age
	ON student (st_age) -- DUPLICATE VALUE WAS FOUND


--8.	Using Merge statement between the following two tables [User ID, Transaction Amount]
CREATE TABLE DailyT (user_id int, trans_amount int)
CREATE TABLE LastT (user_id int, trans_amount int)

INSERT INTO DailyT 
VALUES (1, 1000), (2, 2000), (3, 1000)
INSERT INTO LastT
VALUES (1, 4000), (4, 2000), (2, 10000)

MERGE INTO LastT AS l 
USING DailyT as d
ON l.user_id = d.user_id
WHEN MATCHED THEN 
	UPDATE SET l.trans_amount = d.trans_amount 
WHEN NOT MATCHED THEN
	INSERT VALUES (d.user_id, d.trans_amount);

SELECT * FROM LastT
ORDER BY user_id
 
--9.	Create a cursor for Employee table that increases Employee salary by 10% if Salary <3000 and increases it by 20% if Salary >=3000. Use company DB
DECLARE c1 CURSOR
FOR SELECT Salary FROM Instructor
FOR UPDATE

DECLARE @sal INT
OPEN c1
FETCH c1 INTO @sal    --counter=0
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@sal<3000)
			UPDATE Instructor
				SET Salary = @sal*1.1
				where current of c1
		ELSE IF (@sal<3000)
			UPDATE Instructor
				SET Salary =@sal*1.2
				where current of c1
		FETCH c1 INTO @sal
	END
CLOSE c1
DEALLOCATE c1

--10.	Display Department name with its manager name using cursor. Use ITI DB
DECLARE c1 CURSOR
FOR SELECT d.Dept_Name, i.Ins_Name
FROM Department d JOIN Instructor i 
	ON i.Ins_Id = d.Dept_Manager
for read only

DECLARE @Dept_name nvarchar(20), @mgr_name nvarchar(20)
OPEN c1
FETCH c1 INTO @Dept_name, @mgr_name
WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT 
			@Dept_name AS Depart, 
			@mgr_name AS Manager
		FETCH c1 INTO @Dept_name, @mgr_name
	END
CLOSE c1
DEALLOCATE c1

--11.	Try to display all students first name in one cell separated by comma. Using Cursor 
DECLARE c1 CURSOR 
FOR 
	SELECT St_Fname 
	FROM Student 
	WHERE St_Fname IS NOT NULL
FOR READ ONLY

DECLARE @name nvarchar(20), @all_names nvarchar(200) = ''
OPEN c1
FETCH c1 INTO @all_names
WHILE @@FETCH_STATUS=0
	BEGIN
		FETCH c1 INTO @name
		SET @all_names = CONCAT(@all_names, ' , ' , @name)
	END
SELECT @all_names
CLOSE c1
DEALLOCATE c1

--12.	Try to generate script from DB ITI that describes all tables and views in this DB
--DONE
 
--13.	Use import export wizard to display student’s data (ITI DB) in excel sheet
--DONE



--Part2: use SD_DB
USE SD

--1)	Create view named   “v_clerk” that will display employee#,project#, the date of hiring of all the jobs of the type 'Clerk'.
CREATE VIEW v_clerk 
AS
	SELECT 
		e.empno, 
		p.projectno, 
		w.enter_date
	FROM 
		humanresource.employee e JOIN works_on w 
			ON e.empno = w.EmpNo
	JOIN dbo.project p 
		ON w.ProjectNo = p.ProjectNo
	WHERE w.Job = 'clerk'

SELECT * FROM v_clerk


--2)	 Create view named  “v_without_budget” that will display all the projects data without budget
CREATE VIEW v_without_budget 
AS 
	SELECT *
	FROM dbo.project
	WHERE Budget IS NULL

SELECT * FROM v_without_budget

--3)	Create view named  “v_count “ that will display the project name and the # of jobs in it
CREATE VIEW v_count
AS
	SELECT 
		COUNT(job) AS job_num,
		p.ProjectName
	FROM Works_on w JOIN dbo.Project p 
		ON w.ProjectNo = p.ProjectNo
GROUP BY p.ProjectName

SELECT * FROM v_count

--4)	 Create view named ” v_project_p2” that will display the emp#  for the project# ‘p2’ use the previously created view  “v_clerk”
ALTER VIEW v_project_p2
AS
	SELECT empno
	FROM v_clerk
	WHERE projectno = 2
	
SELECT * FROM v_project_p2

--5)	modifey the view named  “v_without_budget”  to display all DATA in project p1 and p2 
ALTER VIEW v_without_budget
AS
	SELECT *
	FROM dbo.project
	WHERE ProjectName IN('p1', 'p2')
	
SELECT * FROM v_without_budget


--6)	Delete the views  “v_ clerk” and “v_count”
DROP VIEW v_clerk
DROP VIEW v_count


--7)	Create view that will display the emp# and emp lastname who works on dept# is ‘d2’
CREATE VIEW v10
AS
	SELECT 
		p.EmpNo, 
		p.Emp_Lname
	FROM company.Department d JOIN HumanResource.Employee p 
		ON d.DeptNo = p.DeptNo
	WHERE d.DeptNo = '2'

SELECT * FROM v10

--8)	Display the employee  lastname that contains letter “J”
       --Use the previous view created in Q#7
SELECT Emp_Lname 
FROM v10 
WHERE Emp_Lname LIKE '%j%'


--9)	Create view named “v_dept” that will display the department# and department name.
CREATE VIEW v_dept
AS
	SELECT 
		d.DeptNo,
		d.DeptName
	FROM company.Department d
	
SELECT * FROM v_dept

--10)	using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’
INSERT INTO v_dept 
VALUES('d4','Development')
SELECT * FROM v_dept


--11)	Create view name “v_2006_check” that will display employee#, the project #where he works and the date of joining the project which must be from the first of January and the last of December 2006.
CREATE VIEW v_2006_check
AS
	SELECT 
		e.EmpNo, 
		p.ProjectName, 
		w.Enter_Date
	FROM HumanResource.Employee e JOIN Works_on w 
		ON e.EmpNo = w.EmpNo
	JOIN dbo.Project p 
		ON w.ProjectNo = p.ProjectNo
	WHERE w.Enter_Date BETWEEN '2006-01-01' AND '2006-12-12'


SELECT * FROM v_2006_check
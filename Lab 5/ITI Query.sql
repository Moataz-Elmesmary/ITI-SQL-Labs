use ITI

-- 1. Retrieve number of students who have a value in their age. 
SELECT COUNT(St_Id) AS #Students
FROM Student
WHERE St_Age IS NOT NULL

-- 2. Get all instructors Names without repetition
SELECT DISTINCT Ins_Name
FROM Instructor

-- 3. Display student with the following Format (use isNull function)
	-- Student ID	Student Full Name	Department name

SELECT 
	s.St_Id AS [Student ID],
	ISNULL(s.St_Fname + ' ' + s.St_Lname, 'Not Assigned') AS [Student Full Name], 
	d.Dept_Name
FROM Student s JOIN Department d 
	ON s.Dept_Id = d.Dept_Id

-- 4.	Display instructor Name and Department Name 
	-- Note: display all the instructors if they are attached to a department or not
SELECT 
	i.Ins_Name, 
	d.Dept_Name
FROM Instructor i LEFT JOIN Department d 
	ON i.Dept_Id = d.Dept_Id

-- 5. Display student full name and the name of the course he is taking For only courses which have a grade  
SELECT 
	s.St_Fname + ' ' + s.St_Lname AS [Student Full Name],
	c.Crs_Name as 'Course Name' 
FROM Student s JOIN Stud_Course sc
	ON s.St_Id = sc.St_Id
JOIN Course c
	ON c.Crs_Id = sc.Crs_Id
WHERE sc.Grade IS NOT NULL


-- 6. Display number of courses for each topic name
SELECT
	COUNT(c.Crs_Id),
	t.Top_Name
FROM Course c JOIN Topic t
	ON c.Top_Id = t.Top_Id
GROUP BY t.Top_Name


-- 7. Display max and min salary for instructors
select min(salary) as 'Min Salary',max(salary) as 'Max Salary'	from Instructor

SELECT 
	Ins_Name
	,MAX(Salary) max_Salary 
	,MIN(Salary) min_Salary
FROM Instructor
GROUP BY Ins_Name

-- 8. Display instructors who have salaries less than the average salary of all instructors.
SELECT Ins_Name 
FROM Instructor
WHERE Salary < (
	SELECT AVG(Salary) 
	FROM Instructor)


-- 9. Display the Department name that contains the instructor who receives the minimum salary.
SELECT d.Dept_Name
FROM Department d JOIN Instructor i 
	ON d.Dept_Id = i.Dept_Id
WHERE i.Salary = (
	SELECT MIN(Salary) 
	FROM Instructor)

--10. Select max two salaries in instructor table. 
SELECT MAX(Salary) maxSalary1
FROM Instructor

SELECT MAX(Salary) AS maxSalary2
FROM Instructor
WHERE Salary < (
	SELECT MAX(Salary) 
	FROM Instructor)

--OR
SELECT TOP(2) Salary 
FROM Instructor 
ORDER BY Salary DESC


--11. Select instructor name and his salary but if there is no salary display instructor bonus keyword. “use coalesce Function”
SELECT 
	Ins_Name, 
	COALESCE(CONVERT(nvarchar(20),salary), 'Bonus') AS [Salary or Bonus]
FROM Instructor

-- 12.Select Average Salary for instructors 
SELECT AVG(Salary) AvgSalary
FROM Instructor

-- 13. Select Student first name and the data of his supervisor 
SELECT 
	s.St_Fname AS StudentFirstName, 
	sup.*

FROM Student s JOIN Student sup 
	ON s.St_super = sup.St_Id

-- 14.Write a query to select the highest two salaries in Each Department for instructors who have salaries. “using one of Ranking Functions”
SELECT *
FROM (
	SELECT *,ROW_NUMBER() OVER (PARTITION BY Dept_id ORDER BY salary DESC) AS RN
	FROM Instructor) AS newtable
WHERE RN <=2

-- 15. Write a query to select a random student from each department.  “using one of Ranking Functions”
SELECT *
FROM (SELECT *, ROW_NUMBER() OVER(PARTITION BY Dept_Id ORDER BY NEWID()) AS RN
      FROM Student) AS newtable
WHERE RN = 1


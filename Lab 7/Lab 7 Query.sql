USE ITI

---1.	Create a scalar function that takes date and returns Month name of that date.
create function getmonth(@date date)
returns varchar(10)
AS
	BEGIN
		DECLARE @month varchar(10) = format(@date,'MM')
		RETURN @month
	END
GO
SELECT dbo.getmonth('1999-09-09') AS MonthResult


---2.	 Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
create function getvalue(@x int, @y int)
returns @t table (vals int)
AS
BEGIN
	WHILE @x < @y
	BEGIN
        INSERT INTO @t VALUES (@x)
        SET @x += 1
    END
    RETURN
END
GO 

SELECT* 
FROM dbo.getvalue(10,15) 

---3.	 Create inline function that takes Student No and returns Department Name with Student full name.
create function getstud(@id int)
returns table
as
	 return
		 (
		 SELECT 
			d.Dept_Name, 
			s.St_Fname +' '+ s.St_Lname as fullname
		 FROM Student s JOIN Department d
			ON s.Dept_Id = d.Dept_Id
			WHERE s.St_Id = @id)
GO
SELECT * FROM getstud(12)

---4.	Create a scalar function that takes Student ID and returns a message to user 
---a.	If first name and Last name are null then display 'First name & last name are null'
---b.	If First name is null then display 'first name is null'
---c.	If Last name is null then display 'last name is null'
---d.	Else display 'First name & last name are not null'
create function name_check(@id int)
returns varchar(40)
BEGIN
	declare @msg varchar(40)

	SELECT @msg = 
		CASE 
			WHEN St_Fname is null and St_lname is null THEN  'First name & last name are null'
			WHEN St_Fname is null THEN  'first name is null'
			WHEN St_lname is null THEN  'last name is null'
			ELSE 'First name & last name are not null'
		END
	FROM Student
	WHERE  st_id = @id

return @msg
END
GO
SELECT dbo.name_check(13) AS [name checked]

---5.	Create inline function that takes integer which represents manager ID and displays department name, Manager Name and hiring date 
create function getmngr(@id int)
returns table as return(
	SELECT 
		d.dept_name,
		i.ins_name,
		d.manager_hiredate
	FROM Instructor i JOIN Department d
		ON i.Ins_Id = d.Dept_Manager
		WHERE d.Dept_Manager = @id)
GO
SELECT * 
FROM getmngr(5)

---6.	Create multi-statements table-valued function that takes a string
---If string='first name' returns student first name
---If string='last name' returns student last name 
---If string='full name' returns Full Name from student table 
---Note: Use “ISNULL” function
create function stName(@name varchar(10))
returns @t table
(
id int, name varchar(20)
)
AS
BEGIN
	IF @name = 'first name'
	   INSERT INTO @t
	   SELECT ISNULL(st_fname,' ') FROM Student
	ELSE IF @name = 'last name'
	   INSERT INTO @t
	   SELECT ISNULL(st_Lname,' ') FROM Student
	ELSE IF @name = 'full name'
	   INSERT INTO @t
	   SELECT ISNULL(St_Fname+' '+St_Lname,' ') FROM Student
	RETURN
END
GO

SELECT * 
FROM stname('full name')

---7.	Write a query that returns the Student No and Student first name without the last char
SELECT st_id, SUBSTRING(st_fname, 1, len(st_fname) - 1) AS fname
FROM Student

---8.	Write query to delete all grades for the students Located in SD Department 
DELETE sc 
FROM Stud_Course sc JOIN student st
	ON sc.St_Id = st.St_Id
JOIN Department dep
	ON st.Dept_Id=dep.Dept_Id
WHERE dep.Dept_Name = 'SD'



---Bonus:
--1.	Give an example for hierarchyid Data type
CREATE TABLE Organization (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Position HIERARCHYID
)

INSERT INTO Organization VALUES (1, 'CEO', hierarchyid::GetRoot());

INSERT INTO Organization VALUES (2, 'Manager', hierarchyid::GetRoot().GetDescendant(NULL, NULL));

INSERT INTO Organization VALUES (3, 'Developer', 
    (SELECT Position FROM Organization WHERE Name = 'Manager').GetDescendant(NULL, NULL));

SELECT 
	Name,
	Position.ToString() AS HierarchyPath,
	Position.GetLevel() AS Level
FROM Organization;

--(((ANOTHER EXAMPLE)))
CREATE TABLE emp
(
    id int identity(1,1) primary key,
    mgr_id hierarchyid not null,
    emp_name varchar(50)
)
INSERT INTO emp (mgr_id, emp_name)
VALUES 
    (('/'), 'CEO'),
    (('/1/'), 'Manager'),
    (('/1/1/'), 'Assistant'),
    (('/1/1/2/'), 'Dev'),
    (('/1/2/'), 'someone')

SELECT emp_name, mgr_id.GetLevel() AS lvl
FROM emp;

SELECT emp_name, mgr_id.GetAncestor(2) as ancestor
FROM emp

--2.	Create a batch that inserts 3000 rows in the student table(ITI database). The values of the st_id column should be unique and between 3000 and 6000. All values of the columns st_fname, st_lname, should be set to 'Jane', ' Smith' respectively.
DECLARE @iterator int = 3000  
WHILE @iterator <6000
	BEGIN
	INSERT INTO Student(St_Id,St_Fname,St_Lname)
	VALUES(@iterator,'Jane','Smith')
	SET @iterator+=1
	END
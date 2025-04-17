--1.	Create a stored procedure without parameters to show the number of students per department name.[use ITI DB] 
USE ITI

CREATE PROC stNum_perDept
AS
	SELECT 
		d.Dept_Name,
		COUNT(s.st_id)
	FROM Department d JOIN Student s
		ON d.Dept_Id=s.Dept_Id
	GROUP BY d.Dept_Name

stNum_perDept

--2.	Create a stored procedure that will check for the # of employees in the project p1 if they are more than 3 print message to the user “'The number of employees in the project p1 is 3 or more'” if they are less display a message to the user “'The following employees work for the project p1'” in addition to the first name and last name of each one. [Company DB] 
USE SD

CREATE PROC empNum_p1 
AS	
	DECLARE @num INT
	SELECT @num  = count (*) FROM Works_On WHERE ProjectNo = 'p1'

	IF @num >= 3
	BEGIN
		SELECT 'The number of employees in the project p1 is '+ CAST(@num as varchar(10))
	END
	ELSE
	BEGIN
		SELECT 'The following employees work for the project p1'
		UNION ALL
		SELECT (e.Emp_Fname + ' ' + e.Emp_Lname) AS fullName
		FROM HumanResource.EMPLOYEE e JOIN Works_On w 
			ON e.EmpNo=w.EmpNo
		JOIN dbo.PROJECT p 
			ON w.ProjectNo=p.ProjectNo
		WHERE p.ProjectNo=1
	END

empNum_p1

--3.	Create a stored procedure that will be used in case there is an old employee has left the project and a new one become instead of him. The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) and it will be used to update works_on table. [Company DB]
CREATE PROC updateEMP @old INT, @new INT, @pnum INT
AS
	UPDATE Works_On
	SET EmpNo = @new
	FROM HumanResource.EMPLOYEE JOIN Works_On
		ON HumanResource.EMPLOYEE.EmpNo = Works_On.EmpNo
	WHERE Works_On.EmpNo = @old and ProjectNo = @pnum

updateEMP 2551,3,50


--4.	add column budget in project table and insert any draft values in it then then Create an Audit table with the following structure 
--ProjectNo 	UserName 	ModifiedDate 	Budget_Old 	Budget_New 
--  p2            	Dbo 	2008-01-31	      95000 	200000 
--This table will be used to audit the update trials on the Budget column (Project table, Company DB)
--Example:
--If a user updated the budget column then the project number, user name that made that update, the date of the modification and the value of the old and the new budget will be inserted into the Audit table
--Note: This process will take place only if the user updated the budget column
CREATE TABLE audit
(
	projectNo INT,
	username VARCHAR(20),
	modifiedDate DATE,
	oldBudget INT,
	newBudget INT
)

CREATE TRIGGER t1
ON dbo.Project
AFTER UPDATE
AS
	IF UPDATE(budget)
		BEGIN 
			DECLARE @new INT, @old INT,@pnum INT
				SELECT @old = budget FROM deleted
				SELECT @new = budget FROM inserted
				SELECT @pnum = ProjectNo FROM inserted
			INSERT INTO audit
			VALUES(@pnum, SUSER_NAME(), GETDATE(), @old, @new)
		END

UPDATE dbo.Project
SET Budget = 90000
WHERE ProjectNo = 1

--5.	Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
-- “Print a message for user to tell him that he can’t insert a new record in that table”
USE ITI

CREATE TRIGGER t2
ON Department
INSTEAD OF INSERT
AS
	SELECT 'can’t insert a new record in that table'

INSERT INTO Department(Dept_Id,Dept_Location)
VALUES(1,'E')

--6.	 Create a trigger that prevents the insertion Process for Employee table in March [Company DB].
USE Company_SD

Create Trigger Prevent_Insertion
ON Employee
AFTER INSERT
	AS
		IF format(GETDATE(),'MM')='March'
			BEGIN
				SELECT 'can`t insert'
				rollback
			END

--7.	Create a trigger on student table after insert to add Row in Student Audit table (Server User Name , Date, Note) where note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”
Use ITI

CREATE TABLE Student_Audit
(
	username nvarchar(50),
	ModifiedDate date,
	Notes nvarchar(100),
)

Create Trigger Update_Audit
ON Student
AFTER INSERT
AS 
	DECLARE @note VARCHAR(300), @id INT
	SELECT @id=st_id FROM inserted
	SELECT @note = CONVERT(VARCHAR(100), CONVERT(VARCHAR(100), suser_name()) + 'Insert New Row with Key=' + CONVERT(VARCHAR(100), @id) + 'in table student') 
	INSERT INTO Student_Audit
	values(SUSER_NAME(), GETDATE(), @note)

INSERT INTO student (st_id,st_fname) 
VALUES(120, 'ahmed')

--8.	 Create a trigger on student table instead of delete to add Row in Student Audit table (Server User Name, Date, Note) where note will be“ try to delete Row with Key=[Key Value]”
CREATE TRIGGER StdAudit
ON Student 
INSTEAD OF DELETE
AS 
	DECLARE @n INT
	SELECT @n = St_Id FROM deleted
	INSERT INTO Student_Audit
	VALUES(SUSER_SNAME(),GETDATE(),'try to delete Row with Key'+CONVERT(VARCHAR(10),@n)+' in table student')
	
DELETE FROM Student
WHERE St_Id=1

--1.	Create a sequence object that allow values from 1 to 10 without cycling in a specific column and test it.
CREATE SEQUENCE S
AS INT
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 10
	NO CYCLE

CREATE TABLE SEQ
(
	ID INT,
	NAME VARCHAR(50)
)

INSERT INTO SEQ
VALUES(1, 'ahmed')

INSERT INTO SEQ 
VALUES(NEXT VALUE FOR S,'ahmed')

SELECT* FROM SEQ
DROP SEQUENCE S

--2.	Create full, differential Backup for SD DB.
-- DONE ://D

--Part2:
--1.	Transform all functions in lab7 to be stored procedures

USE ITI
-- 1.
CREATE PROC getmonth @date DATE
AS
BEGIN
    DECLARE @month VARCHAR(10) = FORMAT(@date, 'MM')
    PRINT @month
END

EXEC getmonth '1999-09-09'

-- 2.
CREATE PROC getvalue @x INT, @y INT
AS
BEGIN
    DECLARE @t TABLE (vals INT)
    WHILE @x < @y
    BEGIN
        INSERT INTO @t VALUES (@x)
        SET @x += 1
    END
    SELECT * FROM @t
END

EXEC getvalue 10, 15

-- 3.
CREATE PROC getstud @id INT
AS
BEGIN
    SELECT 
        d.Dept_Name, 
        s.St_Fname + ' ' + s.St_Lname AS fullname
    FROM Student s JOIN Department d 
		ON s.Dept_Id = d.Dept_Id
    WHERE s.St_Id = @id
END

EXEC getstud 12

-- 4.
CREATE PROC name @id INT
AS
BEGIN
    DECLARE @msg VARCHAR(40)
    SELECT @msg = 
        CASE 
            WHEN St_Fname IS NULL AND St_Lname IS NULL THEN 'First name & last name are null'
            WHEN St_Fname IS NULL THEN 'first name is null'
            WHEN St_Lname IS NULL THEN 'last name is null'
            ELSE 'First name & last name are not null'
        END
    FROM Student
    WHERE St_Id = @id
    PRINT @msg
END


EXEC name 13

-- 5.
CREATE PROC getmangr @id INT
AS
BEGIN
    SELECT 
        d.dept_name,
        i.ins_name,
        d.manager_hiredate
    FROM Instructor i JOIN Department d 
		ON i.Ins_Id = d.Dept_Manager
    WHERE d.Dept_Manager = @id
END


EXEC getmangr 5

-- 6.
CREATE PROC stuName @name VARCHAR(10)
AS
BEGIN
    DECLARE @t TABLE (id INT, name VARCHAR(20))
    IF @name = 'first name'
        INSERT INTO @t
        SELECT st_id, ISNULL(st_fname, ' ') FROM Student
    ELSE IF @name = 'last name'
        INSERT INTO @t
        SELECT st_id, ISNULL(st_Lname, ' ') FROM Student
    ELSE IF @name = 'full name'
        INSERT INTO @t
        SELECT st_id, ISNULL(st_fname + ' ' + st_Lname, ' ') FROM Student

    SELECT * FROM @t
END


EXEC stuName 'full name'
----Stored procedure is not precompiled but it is complied with first run

--stored procedure
----allows the end user to execute a group of precompiled statements by
----entering a single predefined command

--benifits
----Simplify repeated tasks
----Run faster
----Reduce network traffic
----Can catch user errors before they are entered into the database
----Establish consistency by performing tasks the same way 
----Help to provide security 
----Can enforce complex business rules and defaults

--types of SP
----1)system stored procedure
----2)user defined stored procedure
----3)trigger

--performance benifits
--A compiled stored procedure executes more rapidly than a batch because:
--1)The stored procedure has already been parsed
--2)Server does not need to build a query tree;
--3)it can use the one in sysprocedures
--3)If an unused query plan for the procedure exists in procedure cache
--Server does not need to create a query plan

create proc p1
as
select ins_name,salary
from instructor where ins_id=10
return

[exec] p1


create proc p1
as
declare @x int
select @x=avg(salary)
from instructor 
return @x

declare @out int
exec @out=p1
select @out

--input parameters

create proc dd @x int,@y int=10
as
select @x,@y

create proc deptname
(@fname varchar(40), @lname varchar(20)=NULL)
	as
	  select d_name
		from student s,department d
		where st_fname = @fname
		and st_lname = @lname
		and s.d_id=d.d_id
	return

deptname 'ahmed','kariem'

--passing paramerter
--1)Passing by parameter position
--2)Passing by parameter name

--default
--generics
--use execute
--Input and output parameters
--with encryption
--with recompile
--sp_recompile
----WITH RECOMPILE at creation
----WITH RECOMPILE on execution
--disable and enabled trigger

alter PROC P10 @id INT,@age int output
as
select @age=St_Age from Student where St_Id=@id
return 100

declare @age int
declare @r int
exec @r=p10 1,@age output
select @age,@r

create proc p4
as
insert into Student(st_id) values(99)

exec p4
--output parameter

--with encryption
--with recompile
--sp_recompile
--WITH RECOMPILE at creation
--WITH RECOMPILE on execution

exec sp_recompile dd

--u can return a table variable from a SP


------------Example(1)---------------
create proc p22      -- procedure that don't take parameter
as
declare @x nvarchar(20)
set @x='test'
print @x			--without return

p22  --calling or excuting it
GO
-----------Example(2)-------------------
create  proc p23(@x nvarchar(20) output) -- proc takes output parameter
as
select @x='test'		--without return

declare @y nvarchar(20)
exec p23 @y output
select @y
----------------------------------------------------
--Example(3)
GO
create proc p24
as
begin
	exec('create proc vv as select * from student')
end
/*
1st time command exec succf.
2nd time
Msg 2714, Level 16, State 3, Procedure vv, Line 4
There is already an object named 'vv' in the database.
*/
p24 -- calling or excuting
---------------------------------------------
--Example(4)
Go
create proc pp(@id int)--proc that take input parameter
as
select @id

pp @id=8--work correctly
	
pp @id=8
select @id=@id+3
select @id	
/*Msg 137, Level 15, State 2, Line 2
Must declare the scalar variable "@id".
*/
----------------------------------------------
--Example(5)
GO
use AdventureWorks;  --as view

CREATE PROCEDURE HumanResources.uspGetAllEmployees
AS
    SELECT LastName, FirstName, JobTitle, Department
    FROM HumanResources.vEmployeeDepartment;
GO

exec HumanResources.uspGetAllEmployees
						------------------------
--Example(5)												
USE AdventureWorks;
GO
CREATE PROCEDURE uspNResults 
AS
SELECT COUNT(ContactID) FROM Person.Contact
SELECT COUNT(CustomerID) FROM Sales.Customer;
GO

DECLARE	@return_value int
EXEC	@return_value = dbo.uspNResults
SELECT	'Return Value' = @return_value
GO
						--------------------------		
--Example(6)						
use AdventureWorks 
go
						
SELECT *
FROM Person.Contact p
INNER JOIN HumanResources.Employee e
ON e.ContactID = p.ContactID
--encapsulate into stored procedure
go
--Example(7)
CREATE PROC usp_GetEmp
AS
SELECT *
FROM Person.Contact p
INNER JOIN HumanResources.Employee e
ON e.ContactID = p.ContactID
EXEC usp_GetEmp

--Modify the stored procedure to add a parameter
ALTER PROC usp_GetEmp
@LastName varchar(50)
AS
SELECT *
FROM Person.Contact p
INNER JOIN HumanResources.Employee e
ON e.ContactID = p.ContactID
WHERE LastName = @LastName

EXEC usp_GetEmp 'Gilbert'	
---------------------------------------------------------------------
/*
In Sql Server 2008 you can pass a table variable in a stored procedure as 
a parameter. now you have the ability to send multiple rows of data in 
a stored procedure.one main advantage of that is that it will reduce the amount 
of round trips to the server. 
*/
use SD30_Company 
CREATE TABLE Customers
(
   	 Cust_ID int NOT NULL
	,Cust_Name varchar(50) NOT NULL
	,Cust_Surname varchar(50) NOT NULL
	,Cust_Email varchar(50) NOT NULL
)
Go
								------------------------------
create procedure insertintocustomer
		(
				@Cust_ID int
				,@Cust_Name varchar(50)
				,@Cust_Surname varchar(50)
				,@Cust_Email varchar(50)
		)
as
begin 
		insert into dbo.Customers
		values(@Cust_ID, @Cust_Name,@Cust_Surname,@Cust_Email)
end
Go
										---------------------------
execute insertintocustomer 1,'robbie','fowler','rb@liverpool.com'
execute insertintocustomer 2,'michael','owen','mo@liverpool.com'

select * 
from dbo.Customers
								------------------------------
create type customertype 
as table
(
		Cust_ID int
		,Cust_Name varchar(50)
		,Cust_Surname varchar(50)
		,Cust_Email varchar(50)
)
go
								-----------------------------
/*
You must use the READONLY clause when passing in the table valued 
variable into the procedure. Data in the table variable cannot be 
modified — you can use the data in the table for any other operation. 
Also, you cannot use table variables as OUTPUT parameters — you 
can only use table variables as input parameters.
*/
create procedure newcustomer
		(@Customer_details customertype READONLY)
		--to be read only it have to be a table value data type
as
begin 
		insert into customers
		select * from @Customer_details
end
								----------------------------
declare @c customertype
insert into @c values (1,'steven','gerrard','sg@liverpool.com')
insert into @c values (2,'jamie','caragher','jc@liverpool.com')
execute newcustomer @c

select *
from dbo.Customers
								


--------------------------------------------

						-------- Q2 -------
create procedure p1 @col varchar(100),@tb varchar(100),@cond varchar(100)
as
	execute('select '+@col+' from '+@tb+' where '+@cond)
	

declare @col varchar(100)
declare @tb varchar(100)
declare @cond varchar(100)
set @col='*'
set @tb='student'
set @cond='st_id=1'
execute p1 @col,@tb,@cond

create proc p1
as
select t_name,sal from teacher where t_id=10
return

[exec] p1


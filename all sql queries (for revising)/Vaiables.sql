--------------------------------------------------------------------
--Variables
--Local and Global variables:
--What is variable?
--Why?
----To facilitate repeated use of constant values
----To return custom messages to the client that contain variable information
----To pass information to and from a stored procedure
----To avoid using a subquery.

--Local variables:
----What is the meaning of local?
----Variables are local to the batch, stored procedure, or trigger in which they are declared
		--local variable must begin with @.
		--must has data type
		--intial value = NULL

--Declare variable:
	Declare @x int

--Assign value		4ways
	Set @x=10
	Select @x=20
	Select @x=id from employee where ……
	Update employee set name='ahmed' , @x=id where salary=1000

--Using variable
	Select * from employee where id=@x
	
	
--View variable value
	Select @x

--Notes:
--	1-Missing declaration.
--	2-Mismatch date types.
--	3-if select has no result -------------- @x remains unchanged.
--	4-if select has multiple rows -------- @x retains the last value.
--	5- Variables can be used only in place of constants.

--What is new in variables
--declare variable default argument
 DECLARE @MyName varchar(20)=’Michael’
 -- Declare variable and initialize using query
DECLARE @max_pay_rate DECIMAL(15, 2) = (SELECT MAX(pay_rate)
                                        FROM PayRates);

--compound assignment "short hand operators"
DECLARE @MyNumber int = 2
SET @MyNumber += @myNumber

--top with variables
declare @top int
set @top=2
select Top(@top)* from Student

--Global variables:
--	defined by server.
--	begin with @@.
--	cann't be created by user
--	cann't assigned a value by user
--	local to server or connection

--Common global variables:
select	@@rowcount  ---number of rows affected.
select	@@error  --------0 or num of error message.
--Note: 
Select @@error must be executed in a single batch.

select	@@identity -----NULL or Returns the value last inserted IDENTITY column
select	@@version  ----- version of the DBMS.
select @@servername

--Examples:
--	Note: DB has no table called stud
	
Select * from stud
	Select @@error       --returns error message number

	Select * from student where 1=2
	Select @@error       --returns 0

--table variable
declare @t table(id int)

insert into @t
select st_id from student

select @t


--Dynamic SQL:
	
Declare @col_list nvarchar(100)='*',@table_name nvarchar(100)='student'
	exec('select ' + @col_list + ' from ' + @table_name)
	
--Note:
--Variables used in the execute statement must be char or nvarchar.
		--Variables can be used only in place of constants.
			Select * from @table_name  ----- generate errors.

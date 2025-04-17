		
--Control-of-Flow Statement:
--if...else
--begin...end
--if exists
--("statment must has no errors" and then check if executed or not)
--while
--break         exit while
--continue    go to while
--return	exit the batch or stored procedure
--case

--Operators:
--                      < , > , <= , >= , = , <> , and , or

--Examples:
--      1)IF
declare @num_rows  int
	delete from student where st_id=190
	select @num_rows = @@rowcount
	if @num_rows = 0
			select  'No rows were deleted.'
	Else if @num_rows = 1
			select  'One row was deleted.'
	Else
			select ' Multiple rows were deleted.'

 --    2)While
	-- While the average price is greater than
	-- $20, this loop cuts all prices in half.
	-- However, if the maximum price falls below
	-- $40, the loop is immediately terminated.

while (select avg(price) from titles) > $20
		begin
		   update titles
			set price = price / 2
		   if (select max(price) from titles) < $40
			break
		end
--3) If exists
if exists(select 1 from sys.tables where name='studen')
select * from studen

----Case Statment
----Case statement has 2 types (simple case [when has values], searched case[when has condition])
----Two syntax structures for case 
--------Based on expressions
--------Based on conditions
 
----The case expression is a Transact-SQL extension that can be used anywhere 
----an expression can be used In practice, case is typically used with update and select statements
----case allows for conditional return of a value from two or more possible values
            
update dbo.Instructor
		set Ins_Salary = 
		case 
			when Ins_salary<1000 then Ins_salary*0.1
			when Ins_salary=2000 then Ins_salary*0.2
			else Ins_salary*0.3
		end
		
--case statment with select
select Ins_Name,Salary =
		case 
			when salary<5000 then 'low salary'
			when salary>=5000 then 'high salary'
			else 'has no salary'
		end 
from Instructor 


------based on expression

SELECT   Ins_Name, Gender =
      CASE Gender
         WHEN 'M' THEN 'Male'
         WHEN 'F' THEN 'Female'
      END
from Instructor
--Message statements:
--	Select
--	Print
--	Raiserror           assignments

--select
--	Returns result set:
		Select col_list 			table date
		Select @x			variable of any type
	 	Select 'any string'		text
--print
	Returns debugging message
		Print 'string'		text
		Print  @x 	          variable only char or can be converted to char 
	
sp_addmessage @msgnum = 50005,
              @severity = 10,
              @msgtext = N'<<%7.3s>>';
GO
RAISERROR (50005, -- Message id.
           10, -- Severity,
           1, -- State,
           N'abcde'); -- First argument supplies the string.
-- The message text returned is: <<    abc>>.
GO
sp_dropmessage @msgnum = 50005;

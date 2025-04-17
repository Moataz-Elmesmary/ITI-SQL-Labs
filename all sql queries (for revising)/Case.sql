--Case Statment
----Case statement has 2 types (simple case [when has values], searched case[when has condition])
----Two syntax structures for case 
--------Based on expressions
--------Based on conditions
 
----The case expression is a Transact-SQL extension that can be used anywhere 
----an expression can be used In practice, case is typically used with update and select statements
----case allows for conditional return of a value from two or more possible values

--Syntax:
--------CASE expression
--------WHEN expression1 THEN expression1
-------- [[WHEN expression2 THEN expression2] [...]]
-------- [ELSE expressionN]
--------END
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

SELECT   Ins_Name,
      CASE Gender
         WHEN 'M' THEN 'Male'
         WHEN 'F' THEN 'Female'
      END
from Instructor


-------------------------------
DECLARE @TestVal INT
 SET @TestVal = 3
SELECT
CASE @TestVal
WHEN 1 THEN 'First'
WHEN 2 THEN 'Second'
WHEN 3 THEN 'Third'
ELSE 'Other'
END
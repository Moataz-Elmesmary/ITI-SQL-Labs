--Top with DML
--after using it with select 
--insert with top
INSERT INTO test
	SELECT TOP (3) St_Id,St_Fname
	FROM Student

INSERT top(3) INTO test
	SELECT St_Id,St_Fname
	FROM Student

--update with top
update top(2) Department
set Dept_Location = 'alex'

--Top with delete
--Delete with top
delete Top(2) from test

--delete 2.5% from the data
DELETE TOP (2.5) PERCENT
FROM Production.ProductInventory;

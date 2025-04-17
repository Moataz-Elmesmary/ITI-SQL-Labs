
--remove (Count of number of rows) message
SET NOCOUNT ON;

--Metadata
sp_help --followed by any Database object (db,table,column....)

SELECT * FROM sys.columns c WHERE c.object_id=OBJECT_ID('[dbo].[topic]')

--newid() method generate GUID
SELECT NEWID()


--dealing with null
--isnull or ConCat_NULL_YIELDS_NULL
SET CONCAT_NULL_YIELDS_NULL ON
go
DECLARE @x varchar(50)
SELECT @x+'ahmed'

SET CONCAT_NULL_YIELDS_NULL off
go
DECLARE @x varchar(50)
SELECT @x+'ahmed'



--insert constructor
--old solution
INSERT INTO topic
SELECT 13,'A'
UNION
SELECT 103,'b'
UNION
SELECT 1003,'c'

--solution
INSERT INTO topic
VALUES( 13,'A'),
(  103,NULL),
(  1003,default)



INSERT INTO topic
VALUES( 13,'A'),
(  (SELECT 1),(SELECT 'd')),
(  1003,default)

--Will cause error
INSERT INTO topic
VALUES( 13,'A'),
(SELECT 1'd')),
(  1003,default)


--how to insert document in DB
CREATE TABLE X
(
id INT, doc VARBINARY(max)
)

INSERT INTO X 
VALUES(1, (SELECT * FROM OPENROWSET(BULK 'f:\db\mydoc.docx',SINGLE_BLOB) AS doc1))

SELECT doc FROM X



--New T-SQL in 2012
--http://msdn.microsoft.com/en-us/library/bb500435.aspx
--------------------
--Error Handling
begin try
begin tran
delete from student
where st_id=1
commit tran
end try
begin catch
rollback tran
declare @msg varchar(4000),@severity int
select @msg=ERROR_MESSAGE(),
	   @severity=ERROR_SEVERITY()
raiserror(@msg,@severity,0)
end catch

begin try
begin tran t1
delete from student
where st_id=1
commit tran
end try
begin catch
 rollback tran;
throw;
end catch
--Enhanced EXECUTE keyword
--in sql 2008 i can use qith recompile option with execute statment in running SP
--now i can use with result set it is called Defensive Coding 
--means using result set with stored procedure
create proc p1
as
select st_id ,st_fname
from student

execute p1
with result sets
(
	(id int, name varchar(50))
);

--file table
--update Join

--throw and raiserror self study



--insert with Execute
--insert return values of stored procedure
insert into test
execute Sp_Student


--update with subqueries
UPDATE SomeTable
SET Column = Value
FROM SomeSubquery

--raise course grade for each student by 10 where course topic is programming
update stud_course
set grade +=10
from stud_course sc,course c
where sc.crs_id=c.crs_id 
	  and top_id=(select top_id
				  from topic
				  where top_name='programming')

update 
UPDATE Sales.SalesPerson
SET SalesYTD = SalesYTD + SubTotal
FROM Sales.SalesPerson AS sp
JOIN Sales.SalesOrderHeader AS so
    ON sp.BusinessEntityID = so.SalesPersonID
    AND so.OrderDate = (SELECT MAX(OrderDate)
                        FROM Sales.SalesOrderHeader 
                        WHERE SalesPersonID = 
                              sp.BusinessEntityID);

--Update randam records
update top(5) student
set st_age=20

--Update the smallest 5 salaries "raise by 500"
update Instructor
set Salary=Salary+500
where Salary in (select Top(5) Salary from Instructor order by Salary )


--Anther solution
update Student
set St_Age=10
from (select Top(5) St_Id from student order by St_Age) as "new"
where new.St_Id=Student.St_Id

--delete with subqueries
--delete all the instructors who has a bad evaluation in any course
delete from instructor
where Ins_Id in (select St_Id from dbo.Stud_Course evaluation='Bad')





--used with full text indexing
Select * from Student
WHERE CONTAINS(st_lname, 'Johnson')

Select * from Student
WHERE FREETEXT(Description, ‘Johnson’)


--In Any All
--Display the students whose thier ages greater than the ages of all supervisors
select * 
from student
where st_age > All(select super.st_age 
				   from student st,student super 
				   where super.st_id=st.st_super) 
				   
--Display the students whose thier ages greater than any age of the ages of all supervisors
--SOME is an ISO standard equivalent for ANY 
select * 
from student
where st_age > any(select super.st_age 
				   from student st,student super 
				   where super.st_id=st.st_super) 

select *
from student
where st_super=(select distinct(super.st_id) 
				   from student st,student super 
				   where super.st_id=st.st_super and super.st_fname='ahmed')
	 and 
	 st_age>(select distinct(super.st_age )
				   from student st,student super 
				   where super.st_id=st.st_super and super.st_fname='ahmed')
				   
		
--Display students whose their ages greater than the age of 
--Thier supervisor and the name of supervisor		   

select * from student
order by st_super
compute count(st_id) by st_super

select *
from student
where st_id(select distinct(super.st_id) 
				   from student st,student super 
				   where super.st_id=st.st_super and super.st_fname='ahmed')
	 and 
	 st_age>(select distinct(super.st_age )
				   from student st,student super 
				   where super.st_id=st.st_super and super.st_fname='ahmed')
group by st_super				   






 


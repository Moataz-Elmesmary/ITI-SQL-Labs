--Comments
--	Double-hyphen comments 
--	"—" comment one line
--	Slash-asterisk comments
--	"/*     */" comment multi lines

--T-SQL And ANSI SQL
--history of SQL 
----1)Square language (first text based query language) 
----2)SEQUEL (Structure English query language) 
----3)SQL (Structure query language)

--T-SQL(5 categories)
--1)DDL
--2)DML
--3)DCL
--4)TCL
--5)DQL

--Notes:
--Rules of Naming Objects in SQL Server
	--	First Character [Letter, _, @, #]
	--	Don’t use reserved words
	--	No spaces [should use square[]]
--Select followed by *, column name, scalar function, variable, subquery,top,distinct
--From can by Followed by 256 data source by max [table, view, subquery, table valued function, table variable]
--Aliases can be used with column name or table name
--Operators with where clause (And, OR, Not)
--DDL
use ITI2

create table test
(
id int,
name nvarchar(50)
)

create table test
(
id int identity(1,1) primary key,
name nvarchar(50),
sal int default 1000
)

alter table test
drop column name

alter table test 
add name nvarchar(50)

alter table test
ALTER COLUMN name NVARCHAR(60)

drop table test


--DML
--Insert Statment
Insert into Department
values(100,'DBA','database Administrator','cairo',107)

--using null and default in insert
Insert into Department
values(100,'DBA',null,'cairo',default)

--order , set of columns 
--other columns (allow null values,calculated,identity,default value) 
Insert into Department(Dept_Id,Dept_Name)
values(200,'ERP')

--Insert data using the new row constructors
INSERT INTO PayRates 
VALUES (1, 40.00, 5),
	   (2, 45.50, 4), 
	   (3, 39.50, 6);

--Insert based on select
insert into test
select st_id,st_fname from Student
where St_Address='cairo'

--insert based on exexute (with Stored procedure)

--using select into

--Update Statment
update Department
set Dept_Location = 'alex'
where Dept_Name='erp'

--using null and default with update
update Department
set Dept_Location = DEFAULT
where Dept_Name='erp'

--update more than one column

--update with joins
update stud_course
set grade +=10
from stud_course sc,course c
where sc.crs_id=c.crs_id 
	  and top_id=(select top_id
				  from topic
				  where top_name='programming')

				  Update Course

--Delete Statment
delete from test
where name='ahmed'

--Truncate Statment
--You cannot use TRUNCATE TABLE on tables thatare referenced by a FOREIGN KEY constraint
truncate table test

--Delete Drop Truncate
----sentax
----result and where
----performane and log
----space and shrink db

--DQL
--Select Statment
--ServerName.DatabaseName.Schema.Object
Select * From  "rami\myserver".ITI2.dbo.student

Select St_fname,st_lname from Student
Select * from student

--alias name and dealing with space in the column names
Select St_fname+' '+st_lname as [full name] from Student
Select * from student

--is null and IS NOT NULL with where clause
select * from Course
where Crs_Duration = null    --null is not a value

select * from Course
where Crs_Duration is not null

--Null Function
--ISNULL function  
select ISNULL(st_age,20) from Student

--COALESCE() – Queries where NULL values may exist and you wish to substitute one of several possibilities into a column of the result set.
SELECT COALESCE(hour_rate * 40 ,  salary, 
   Bonus )  AS 'Total Salary' 
FROM instructor

--NULLIF() – queries that you want to offer a more meaningful value in place of the NULL keyword being displayed in the result.
select nullif(st_age,dept_id)
from student
where st_id=14

--operators > , < ,()
-- or, and, and not
Select St_fname,st_lname from Student
where St_Age=25 or St_age=30

--In Statment
Select St_fname,st_lname from Student
where St_Age in(25,26,27)

--select into
select st_fname,st_age 
into test2
from Student

select st_fname,st_age 
into test3
from Student
where 1=2

--like
Select St_fname,st_lname from Student
where st_fname like 'A%'

Select St_fname,st_lname from Student
where st_fname like '_A%'

Select St_fname,st_lname from Student
where st_fname like '[_]A%'

Select St_fname,st_lname from Student
where st_fname like '___' 

select title_id, title
	from titles
	where title_id like "MC302[13579]"
--Means MC302 + any characters of the following 1,3,5,7,9

select title_id, title
	from titles
	where title_id like "MC302[^13579]"
--Means MC302 + any characters except  the following 1,3,5,7,9

select st_fname
	from student
	where st_fname like '[a-h]%'

--order by desc asc (default asc)
--Order by can by followed by numbers not column names [order by 1 Asc,2 Desc]
select * from Student
order by St_Id desc

select * from Student
order by 1,2 

--we can sort with more than one column

--Between

--joins
	--joins is faster than subqueries if the number of tables is smaller
	--and if there is indexes
--cross join

--Inner join and equi join
select st_fname,dept_name
from student s inner join department d
on s.dept_id=d.dept_id

select st_fname,dept_name
from student s,department d
where s.dept_id=d.dept_id

--inner with 3 tables
select st_fname,dept_name,ins.ins_name
from student s inner join department d
on s.dept_id=d.dept_id inner join instructor ins
on ins.dept_id=d.dept_id
order by ins_name

--Outer join ===> left, right and full
select st_fname,dept_name
from student s left outer join department d
on s.dept_id=d.dept_id

select st_fname,dept_name
from student s right outer join department d
on s.dept_id=d.dept_id

select st_fname,dept_name
from student s full outer join department d
on s.dept_id=d.dept_id

--Cross join or Cartsian product
select st_fname,dept_name
from student s cross join department d

--A Cartesian Product
select st_fname,dept_name
from student s , department d

--Self join
select stud.st_fname,super.st_fname as "supervisor Name"
from student super,student stud
where super.st_id=stud.st_super
 
--aggregate functions
--used in select, having

--count avg sum max min
select MAX(crs_duration) from Course

select COUNT(st_fname) from student
 
select COUNT(*) from student

SELECT AVG(ST_AGE) FROM Student
 
SELECT AVG(ISNULL(ST_AGE,0)) FROM Student

--group by
select COUNT(st_id),Dept_Id from Student
group by Dept_Id


--having
select COUNT(st_id),Dept_Id from Student
group by Dept_Id
having COUNT(st_id)>2

--having without group by 
--u should use aggregate in select close
select COUNT(*) from student
having Count(*)<25


--sub queries
--the problem
Select St_fname,st_lname from Student
where St_Age> AVG(st_age)

--solusion
Select St_fname,st_lname from Student
where St_Age> (select AVG(st_age) from Student)

Select ins_name 
from instructor
where Ins_Id in (select dept_manager from Department where Dept_Manager is not null)

--Exists 
select Ins_Name from Instructor
where exists 
(select dept_manager from Department where Dept_Manager is not null)
--inner query returns true or false
--no date returned or processed


--Joins Vs Subqueries
--Joins can yield better performance in some cases where existence must be checked
--Joins are performed faster by SQL Server than subqueries
--Subqueries can often be rewritten as joins
--SQL Server 2008 query optimizer is intelligent enough to covert a subquery into a join if it can be done
--A scalar subquery returns a single row of data, while a tabular subquery returns multiple rows of data

--Distinct
select distinct st_fname
from Student

--If a query contains more than one column, distinct filters out only the rows in which the entire combination of values appears more than once
select distinct st_fname,st_lname
from Student

--Top
select Top 4 * 
from student

--Top with ties
select Top 4 witH ties * 
from student
order by st_age

--Top randomized
SELECT TOP(5) *
FROM student
ORDER BY NEWID();

--table sample and top
SELECT TOP (5)
	st_fname, st_LName
FROM Student

SELECT st_fname, st_LName
FROM Student
TABLESAMPLE (70 PERCENT)

--Union [all] AND Rules
select St_Fname from Student
union all
select Ins_Name from Instructor
--Intersect and except operators
--Compares the results of 2 queries and returns the distinct values


--The order of executing commands:
------	From
------	On
------	Join
------	Where
------	Group By
------	With Cube and With rollup
------	Having
------	Select
------	Distinct
------	Order by
------	Top
--So we can use alias name of the column in order by clause because order by is executed after select but we can’t use alias name with where clause because where Clause is executed before select Clause
select st_fname as firstName
from student
where firstname like 'a%'
--error "invalid column"

select st_fname as firstName
from student
order by firstname

--I can say Top(50) means first 50 rows or say Top(50) percent means 50% of rows
select top(10)*
from student

select top(10) percent*
from student


--Notes
--•	Inner join is ANSI SQL and it is the default join so I can use join keyword instead of inner join
--•	Equi join is ANSI SQL but is older Than Inner Join
--•	Outer is optional keyword in writing joins
--•	Cross Join is called Cartesian Product
--•	Self-Join is supported for inner, outer and cross join
--•	Not equi join like any join but I but anther condition with On Clause if I want but the additional conditions is not Equi [<>,>,<…]
--•	Cross Apply and Outer Apply joins is used with table valued function (Self-study)
--•	Correlated sub queries means u have a sub query that use a column from outer query so there will be a reference from inner to outer query
--•	I can’t use order by with sub query because it is not persisted physically and I can’t use alias column names in sub query for the same reason
--•	Union all is faster than Union

--Template Explorer (it is a template for all queries)
----When u use template explorer and drag anything u can fill parameters 
----(Query menu ->specify values for template parameters ) 
----also I can add new template to template explore 
----(right click->new folder->right click->new template-> <nikename,name,default value>)

--view
--can't take parameters

--IS A select statment
--•	Simplify construction of complex queries
--•	Specify user view
--•	Limit access to data [grant revoke]
--•	Hide names of database objects [table name and columns]
--•	increase performance (only Index and partitioned view)

--types of views
--Standard view
--partitioned view
--indexed views

create view v2(studept_name,dept_name)
as
	select st_fname,dept_name
	from student s,department d
	where	s.dept_id=d.dept_id
	and s.st_address='cairo'

select * from v2
select studept_name from v2

drop view v1

create view v3
as 
	select st_fname from student
	union
	select dept_name from department

--insert through a view if:
----All the affected columns belong to one table
----All the columns not named in the view either allow NULLs
----or have default clauses, or IDENTITY or calculated

--update if:
----All the affected columns belong to one table

--delete if:
----The view is based on only one table

sp_depends v2
sp_help v2
sp_helptext v2
sp_rename v2,v10
select * from v10

--LIMITATIONS
--CANT USE ORDER BY eXCEPT IF U USE IT WITH tOP
--Total number of columns referenced in the view cannot exceed 1024
--i can't use select into
--temp tables Cannot be referenced


--ENCRYPTED VIEW
CREATE VIEW V1
WITH ENCRYPTION
AS
SELECT * FROM Student

SP_HELPTEXT V1

--INDEXED VIEWS
--U CAN CREATE INDEX ON VIEW AS ON TABLES

--An indexed view has been computed and stored. 
--You index a view by creating a unique clustered index on it
alter VIEW VP
WITH schemabinding
AS
SELECT st_fname,st_age 
FROM dbo.Student
where st_age>10


select * from VP

create unique clustered index Myindex on VP(st_age)

drop index VP.myindex

--error
alter table student
alter column st_age bigint

--ok
alter table student
alter column st_lname varchar(60)


--U CAN CREATE PARTITIONED VIEWS
--PARTITIONED VIEWS COMBINE DATA FROM DIFFERENT SOURCES
--PARTITIONED VIEWS lock changing in table design
CREATE VIEW vSales 
AS
SELECT * FROM SQLServerNorth.Sales.Sale
UNION ALL
SELECT * FROM SQLServerSouth.Sales.Sale


--with check option
----working with inset update only
alter view v13
as
	select st_id,st_fname,st_age
	from student
	where st_age=20
	with check option

select * from v13

insert into v13 
values(111,'ali',33)

update v13
set st_age=30
where st_age=20
--------------------------------


----------------------------------
--indexes
create clustered index i1
on student(st_id)

create nonclustered index i2
on student(st_age)



---------------------------------
--CTE
with cte (sid)as
(
select st_id
from Student

)
select *,(select COUNT(*) from cte) from  cte

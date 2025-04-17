
--types of function--
------------------------

--1)isnull function

select upper(st_fname) from student
select lower(st_lname) from student

--2)convet function
select st_id from student 
where st_fname='ahmed' --Ahmed

select 	st_id from student where st_age like 20

select 	st_id from student where st_age like 2%

select 	st_id from student where convert(nvarchar(10),st_age) like '2%'

select convert(nvarchar(20),hiredate,3)
from instructor --1:5

select t_id from instructor 
where convert(nvarchar(50),hiredate,3) like '01%'

select * from Department 
where cast([Manager_hiredate] as varchar(40)) like '%1'
--3)system function
select db_name()
select suser_name()
--4)aggregate function

--5)date
select getdate()

select datename(dd,hiredate) from Department

select datename(mm,hiredate) from Department

select datename(yy,hiredate) from Department

select datename(mm,getdate())

--6)string

select lower(st_fname) from student
select lower(st_lname) from student
select substring(st_fname,1,5) from student  --start--length 

--7)math
select sin(100)
select power(100,2)

--types of built in functions

--scalar funcion
--return oe vales
--all perviouse functions are scalar function

alter function getname(@sid int)
returns nvarchar(20)
begin
declare @name nvarchar(20)
	if @sid > 0
		select @name=st_fname from student 
		where st_id=@sid
	else
		set @name='sid must be positive'
return @name 	
end 


select dbo.getname(-1) as "name"
 
print dbo.getname(-1)

--table_valued function
--return table as a result of select statment

create function highage()
returns table
as 
return
(
select st_fname,st_age from student where st_age>=20 
)

select * from dbo.highage()

--multi_statment table-valued function
--return a new table as a result of insert statment 

create function student_names(@format nvarchar(50)) 
returns @t table
		(
		 student_id int primary key,
		 student_name nvarchar(50)
		)
as
begin
	if @format='fullname'
		insert @t
		select st_id,st_fname+' '+st_lname 
		from student
	else
	if @format='firstname'
		insert  into @t
		select st_id,st_fname
		from student
return
end

select * from student_names('fullname')

select * from student_names('firstname')


create function myday(@x datetime)
returns nvarchar(20)
as
begin
declare @d nvarchar(20)
select @d=datename(mm,@x)
return @d
end

select dbo.myday(02/02/2000)


 
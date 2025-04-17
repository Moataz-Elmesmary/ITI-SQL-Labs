create Proc getmydata
as
SELECT Course.Crs_Name, Stud_Course.Grade, Student.St_Fname
FROM   Course INNER JOIN
             Stud_Course ON Course.Crs_Id = Stud_Course.Crs_Id INNER JOIN
             Student ON Stud_Course.St_Id = Student.St_Id
WHERE (Stud_Course.Grade > 50)
ORDER BY Course.Crs_Name

--calling
getmydata
execute getmydata
exec getmydata

alter proc getstbyadd @add varchar(30)
as
	select st_id,st_fname
	from Student
	where St_Address=@add

getstbyadd 'cairo'
getstbyadd 'alex'
alter schema hr transfer getstbyadd
hr.getstbyadd 'cairo'
alter schema dbo transfer hr.getstbyadd
drop proc getstbyadd

--DML  SP

alter Proc Deltopic @tid int
as
	if exists(Select top_id from course where top_id=@tid)
		select 'table has relation'
	else
		delete from topic where top_id=@tid

Deltopic 30
-----------------------------------------------------------
--return values  & paramters
alter proc sumdata @x int=200,@y int=100
as
	select @x+@y

sumdata 3,8  ---> passing parameters by position
sumdata @y=10,@x=7 --->passing parameters by name
sumdata 5
sumdata
-----------------------------------------------------
alter proc getstbyadd @add varchar(30)
as
	select st_id,st_fname
	from Student
	where St_Address=@add

--calling
declare @t table(x int,y varchar(20))
	insert into @t
	execute getstbyadd 'alex'
select * from @t
select count(*) from @t

insert into tab5
execute getstbyadd 'alex'
------------------------------------------
--return one value    scalar function
create proc getdata @id int
as
	declare @age int
		select @age=st_age from Student
		where st_id=@id
	return @age

declare @x int
	execute @x=getdata 5
select @x

alter proc getdata @id int ,@age int output
as
		select @age=st_age from Student
		where st_id=@id
	
declare @x int
	execute getdata 5,@x output
select @x

alter proc getdata @id int ,@age int output,@name varchar(20) output
with encryption
as
		select @age=st_age,@name=st_fname from Student
		where st_id=@id
	
declare @x int,@y varchar(20)
	execute getdata 1,@x output,@y output
select @x,@y

sp_helptext 'getdata'

--===================================================================
alter proc getdata @z int output,@name varchar(20) output
as
		select @z=st_age,@name=st_fname from Student
		where st_id=@z
	
declare @x int=1,@y varchar(20)
	execute getdata @x output,@y output
select @x,@y
===================================================
--3 types of SP
---->user defined SP
getstbyadd   sumdata  deltopic  getdata

---->builtin SP
SP_helptext   sp_bindrule  sp_helpconstraint ----->

---->triggers
--special type of SP
--can't call
--can't take parameters
--implict code
--automatic firing according according action
--triggers tables [insert update delete]

create trigger tr_1
on student
after insert
as
	select 'welcome to ITI'

insert into student(st_id,st_fname)
values(33,'ahmed')

create trigger tr_2
on student
for update
as
	select getdate(),suser_name(),db_name(),host_name()

update student
	set st_age+=1

create trigger tr_3
on student
instead of delete
as
	select 'not allowed'

delete from student where st_id=30

create trigger tr_4
on department
instead of insert,update,delete
as
	select 'not allowed for user = '+suser_name()

select * from department
update department set dept_name='hr'
where dept_id=10

alter table department disable trigger tr_4
alter table department enable trigger tr_4

---------------------------------------------
create trigger tr_5
on course
after update
as
	if update(crs_name)
		select 'welcome to my company'
	else
		select getdate()
	
update course
	set crs_duration=10
where crs_id=100
----------------------------------------------
create trigger tr_7
on course
after update
as
	select * from inserted
	select * from deleted

update course
	set crs_name='js',crs_duration=100,top_id=1
where crs_id=300

update course
	set crs_name='cloud',crs_duration=20,top_id=2
where crs_id=400

create trigger t_8
on course
instead of delete
as
	select 'not allowed to delete course name = '+(select crs_name from deleted)

delete from course where crs_id=1000

700,web services ,100,1     --course ===> deleted

create trigger s1
on student
instead of insert
as
	if format(getdate(),'dddd')='friday'
		select 'not allowed'
	else	
		insert into student
		select * from inserted

create trigger s2
on student
after insert
as
	if format(getdate(),'dddd')='friday'
		begin
			select 'not allowed'
	        delete from student where st_id=(select st_id from inserted)
		end
------------------------------------------
create table history_audit
(
 _user varchar(100),
 _date date,
 _olddata int,
 _newdata int,
 _actionNote varchar(100)
)

create trigger tr_10
on topic
instead of update
as
	if update(top_id)
		begin
			declare @old int,@new int
				select @old =top_id from deleted
				select @new = top_id from inserted
			insert into history_audit
			values(suser_name(),getdate(),@old,@new,'update table topic')
		end

alter trigger tr_11
on topic
instead of delete
as
	insert into history_audit
	values(suser_name(),getdate(),(select top_id from deleted),NULL,'delete topic')
--------------------------------------------------------
CDC  ---> testing
-------------------------------------------------------
--output  Runtime trigger

delete from instructor
	output deleted.salary
where ins_id=99

update instructor
	set salary=7000
output suser_name(),getdate(),deleted.salary,inserted.salary,' update instructor' into history_audit
where ins_id=99

-------------------------------------------------------
--SP
--Triggers
--Sequence
--Jobs
--types of backups
--high availablity

backup database sales 
to disk=''

backup database sales 
to disk=''
with differential

backup log sales 
to disk=''

--high availability
----failover clustering
----always on
----peer to peer replication
----db mirroring
----ship transaction log




















































	
































-----------------------------------------------------------------




























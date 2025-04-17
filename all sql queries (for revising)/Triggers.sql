
-Triggers

create table actions
(
username nvarchar(50),
actiondate datetime
)
	
create trigger t1
on student
for insert
as
insert into actions values(suser_name(),getdate())

insert into student(st_id,st_fname) values (400,'rami')

SELECT suser_name()
--delete from student where st_id=44

select * from actions
---------------------------------------------------

create trigger t2
	on student
	for insert
	as
	  if datename (dw,getdate()) = 'sunday'
		begin
		  select 'error'
		  rollback tran
end

begin tran t1
insert into student(st_id,st_fname) 
values (450,'rami')
commit

---------------------------------------------------
drop trigger t2

alter table student
[disable,enable] trigger t1

-------------------------------------
--triggers and truncate statment
-------------------------------------
--triggers cannt take parameters
------------------------------------
--if update(specific columns
-----------------------
--DDL triggers
CREATE TRIGGER safety 
ON DATABASE 
FOR Create_TABLE, ALTER_TABLE 
AS 
   PRINT 'You must disable Trigger "safety" to drop or alter tables!' 
   ROLLBACK
;
 
--------------------------------------------------

alter trigger t4
on student
for delete,insert,update
	as 
	select * from deleted
	select * from inserted

insert into student(st_id,st_fname) values (89,'rami')
delete from student where st_id=89

update student set st_fname='ahmed' where st_id=89

--------------------------------------------------

create trigger t5
on student
instead of delete
	as 
	select 'not allowed'

insert into student(st_id,st_fname) values (89,'rami')
delete from student where st_id=89

update student set st_fname='ahmed' where st_id=89

--A trigger is a mechanism that is invoked when a particular action occurs on a particulartable.
-- Each trigger has three general parts:
--1)A name(max 128 character)
--2)The action(DML,DDL)(The trigger action is the type of Transact-SQL statement that activates the trigger.)
--3)The execution (contains a stored procedure or a batch.)
--we have 2 forms of trigger(DML Triggers and DDl Triggers)
--we will learn how to create ,modefiy and delete trigger
--///////Creating a DML Trigger\\\\\\
--what is the difference between after and instead of trigger?(compare)
--AFTER triggers fire after the triggering action occurs.
--INSTEAD OF triggers are executed instead of the corresponding triggering action.
--These three statements can be written in any possible combination.
--The DELETE statement is not allowed if the IF UPDATE option is used.
--Database Engine allows u to create multiple triggers for each table and for each action (INSERT, UPDATE,and DELETE).
-- By default, there is no defined order in which multiple triggers for a given modification action are executed. (You can define the order by using the first and last triggers)
--AFTER triggers can be created only on tables
--INSTEAD OF triggers can be created on both tables and views

--Application Areas for DML Triggers
--AFTER Triggers
--fire after the triggering action has been processed.
--You can specify an AFTER trigger by using either the AFTER or FOR reserved keyword.
--AFTER triggers can be created only on base tables.
--AFTER triggers can be used to perform the following actions, among others:
--1)Create an audit trail of activities in one or more tables of the database(tracking changes)
--2)Implement business rules 
--3)Enforce referential integrity

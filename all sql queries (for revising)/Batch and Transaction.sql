--------------------------------------------------------------------
--Batch, transaction and script
--Batch
--a series of one or more statements submitted and executed at the same time and don't depend on each others.

update student set sname='ahmed' where sid=5    
insert into student values(66,'toto')		

--script set of patches separated with go statment
--for displine

select * from Student where St_Id=66
--Transaction
--a series of one or more data statements that executed as a unit or are aborted as a unit
--A transaction is a logical unit of work
--	Defined from business rules
--	Typically includes at least one data modification
--	Maintains DB consistency.
--What is:
--	Commit
--	Rolled back
--	Save point	savepoint allows for partial rollbacks


--Examples

--commit and rollback example	

use ITI	
		            	--determine which db to use
begin tran t1
declare @r int
update student set St_Fname='ahmed' where St_Id=5    --there is no errors
insert into student(St_Id,St_Fname) values(66,'ali')		--error so rollback
set @r=@@error   --look to the last statment only
if @r = 0
	begin
	commit tran
    select 'true'
	end
else
	begin
	rollback tran
	select 'false'
	end
------------------------------------------------------------------

--try and catch

create table parent
(
pid int primary key not null
)

create table child
(
cid int references parent(pid)
)

insert into parent values(1)
insert into parent values(2)
insert into parent values(3)
insert into parent values(4)

begin transaction
insert into child values(1)
insert into child values(5)
insert into child values(2)
COMMIT


select * from child
truncate table child


begin tran
insert into child values(1)
insert into child values(3)
insert into child values(2)
commit tran 

begin tran
insert into child values(1)
insert into child values(5)
insert into child values(2)
rollback tran --rollback all statments if there is error


begin tran
insert into child values(1)
insert into child values(2)
insert into child values(5)
if @@error!=0
	rollback tran
else 
	commit

select * from parent
select * from child

delete from child

TRUNCATE TABLE CHILD
SELECT * FROM CHILD

--ACID


begin try
	begin tran
		insert into child values(1)
		insert into child values(5)
		insert into child values(2)
	commit tran
	
end try
begin catch
	rollback
end catch

--save point

delete from child

declare @test int
begin try
	begin tran mytran
		insert into child values(1)
		insert into child values(2)
		insert into child values(3)
		set @test=1
	save tran save1	
		insert into child values(2)
		insert into child values(3)
		insert into child values(4)
		set @test=2
	save tran save2
		insert into child values(3)
		insert into child values(4)
		insert into child values(5)
		
	commit tran
	print 'transaction commited'
end try
begin catch
	if @test is null 
		rollback tran mytran
	else 
	if @test =1
		rollback tran save1
	else 
	if @test =2
	rollback tran save2
end catch

select * from child
delete from child

--nested transaction
--Using try/catch
begin try
	select 1/0
end try
begin catch
	print 'Error'
	select ERROR_MESSAGE() 'Error Message'
	,ERROR_NUMBER() 'Error Number'
	,ERROR_LINE () 'Error Line Number'
	,ERROR_SEVERITY () 'Error Severity Level'
	,ERROR_PROCEDURE() 'Error Procedure'
	,ERROR_STATE () 'Error State'
end catch
--------------------------------------------------------------------
use ITI
begin try
	insert into Student(st_id) values(100) 
end try
begin catch
	--select 'error student id already exist'
	RAISERROR (N'This is message %s %d.', -- Message text.
           10, -- SeverityLevel,
           1, -- State,
           N'number', -- First argument.
           1)-- Second argument.
           with log--in case of fatal error to log the event; 

end catch					
--------------------------------------------------------------------
declare @msgnum int,
@severity int
,@msgtext nvarchar(30)
go
sp_addmessage @msgnum = 50005,
              @severity = 10,
              @msgtext = N'<<%7.3s>>';--7char displayed,take 1st 3char from msg
GO
RAISERROR (50005, -- Message id.
           10, -- Severity,
           1, -- State,
           N'abcde'); -- First argument supplies the string.
-- The message text returned is: <<    abc>>.
GO
sp_dropmessage @msgnum = 50005;
GO

select * from sys.messages
where message_id=50005

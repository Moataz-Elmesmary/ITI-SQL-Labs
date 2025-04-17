create trigger t1
on database
for drop_table 
as
rollback

drop trigger t1

drop table table_1


create trigger t3
on database
for ddl_database_level_events 
as
begin
declare @x xml=eventdata()
select @x
end

--------------------output----------------------
--<EVENT_INSTANCE>
--  <EventType>DROP_TABLE</EventType>
--  <PostTime>2011-10-09T11:27:23.833</PostTime>
--  <SPID>53</SPID>
--  <ServerName>RAMI-PC</ServerName>
--  <LoginName>Rami-PC\Rami</LoginName>
--  <UserName>dbo</UserName>
--  <DatabaseName>DB2</DatabaseName>
--  <SchemaName>dbo</SchemaName>
--  <ObjectName>table_1</ObjectName>
--  <ObjectType>TABLE</ObjectType>
--  <TSQLCommand>
--    <SetOptions ANSI_NULLS="ON" ANSI_NULL_DEFAULT="ON" ANSI_PADDING="ON" QUOTED_IDENTIFIER="ON" ENCRYPTED="FALSE" />
--    <CommandText>drop table table_1</CommandText>
--  </TSQLCommand>
--</EVENT_INSTANCE>

--if i wants to save some info in a table
----1
create table audit
(
event_name varchar(50),
txt varchar(50),
username varchar(50),
event_date datetime
)
----2
alter trigger t3
on database
for ddl_database_level_events 
as
declare @x xml=eventdata()
insert into audit
values(
	@x.value('(/event_instance/eventtype)[1]','varchar(50)'),
	@x.value('(/event_instance/TSQLCommand)[1]','varchar(50)'),
	@x.value('(/event_instance/LoginName)[1]','varchar(50)'),
	getdate()
)


create table test(id int)
drop table test
go
select * from audit



--server tiggers
---------------
create trigger t3
on all server
for ddl_login_events
as
print cast(eventdata() as varchar(2000))



create login test1 with password='P@$$w0rd'




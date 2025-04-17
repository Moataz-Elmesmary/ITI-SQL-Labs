---------------------------------------------------------------------
--1) shareable tables
----shared by all users per server
use tempdb
create table share_table
(
sid int 
)
--droping
drop table share_table
Restart server
-----------------------------------------------------------------------------------------
--2)global temp tables
------shared by all users per server

create table ##share_table
(
sid int 
)
--droping
drop table ##share_table

-----------------------------
--3)session based (local)
--until session ends
--use any database
create table #session
(
sid int
)
insert into #session values(1)
select * from #session
--droping
drop table #session
--Disconnecting server "end session"
--------------------------------------------------------------

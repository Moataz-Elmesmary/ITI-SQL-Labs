--Snapshot
--read only DB
--used for reporting only
--capture DB in the time of taking snapshot
--i can take more than of snapshot for the same DB in different times
--used only with NTFS formate only
--Copy on write Concept


--DB Snapshots
--Use Database Snapshots to: "testing reporting and handling errors"
--1) Maintain historical data for report generation
--2) Mirror data to free up resources
--3) Safeguard against administrative error
--4) Safeguard against user error
--5) Manage a test database


use AdventureWorks
create database AdventureWorks_Snap_01
on
(
name='AdventureWorks_Data',-- DB data file name
filename='d:\db\adventure.ss'
)
as snapshot of AdventureWorks--database attach name

--Create snapshot for database tha t has more on data file
CREATE DATABASE MyNewDB_snapshot01 ON
    ( NAME = df1, FILENAME = 'C:\df1_01.ss'),
    ( NAME = df2, FILENAME = 'C:\df2_01.ss'),
    ( NAME = df3, FILENAME = 'C:\df3_01.ss'),
    ( NAME = df4, FILENAME = 'C:\df4_01.ss')
AS SNAPSHOT OF MyNewDB;

--test snapshot
use AdventureWorks;
select BirthDate from  HumanResources.Employee
where EmployeeID=1

use AdventureWorks_Snap_01;
select BirthDate from  HumanResources.Employee
where EmployeeID=1

use AdventureWorks;
update HumanResources.Employee
set BirthDate='1988-10-10'
where EmployeeID =1	

-- We can't Update or edit snapshot, it's read only database.
use AdventureWorks_Snap_01;
update HumanResources.Employee
set BirthDate='1988-10-10'
where EmployeeID =1				
					
--Reverting (restoring) from snapshot
-- Cannot revert when db is corrupted or deleted
use master;
restore database AdventureWorks 
from database_snapshot='AdventureWorks_Snap_01'	--snapshot name in object explorer

--Drop db snapshot
drop database AdventureWorks_Snapshot_01	

--Snapshots Vs. Backup:
--1)Snapshot can used to retrieve data directly, 
--without need to restore the main database 
--(Can used while the source database exist in the same time)
--, while backups can’t.
--2)Reverting snapshot does not work in an offline or corrupted
-- database. While backup does.
-------------------------------------------------------------

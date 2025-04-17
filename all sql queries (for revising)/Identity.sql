-------------------------------------------------------------------------------------------------------
------------------------------------Advanced Queries--------------------------------------------------
--identity column with insert	
--only one identity column in the table not allowed for mutiple identities
CREATE TABLE dbo.T1 ( column_1 int, column_2 VARCHAR(30),
					column_3 int IDENTITY primary key);
GO

SELECT * FROM T1

INSERT T1 VALUES (1,'Row #1');
INSERT T1 (column_2) VALUES ('Row #2');
GO
SET IDENTITY_INSERT T1 ON;
SET IDENTITY_Insert T1 off;
GO
INSERT INTO T1 (column_3,column_1,column_2)  VALUES 
(34,1, 'Explicit identity value');
GO
SELECT column_1, column_2,column_3
FROM T1;

drop table T1

--Identity limitations
----The IDENTITY column of a table contains a unique, system-generated ID number for each row in the table
----Adaptive Server stores in memory blocks of potential ID numbers for each table
----It stores the last-used value and the block’s maximum value
--Tables with infrequent inserts may show large (numeric) gaps in the IDENTITY column
----If a table insert fails, the assigned ID value is lost
----If the server shuts down abnormally, the as-yet-unused values of the current block are lost
--You can set block size for a given table at table creation time using with identity_gap.  
--For a table that will have relatively few inserts, set a low block size to limit 
--potential gaps in the IDENTITY column 

--SHOW IDENTITY COLUMN    
select AddressID from Person.Address
select Address.$IDENTITY from person.Address


--@@identity 
----returns the last identity value produced by the current 
----connection regardless of the insert was explicitly or implicitly

--Scope_identity()
----returns the last identity value that u explicitly created
----by the current connection

--IDENT_Current('table_Name') 
----returns the last actual identityvalue in table,regardless
---- of the connection 


USE tempdb
go

CREATE TABLE MyCurrent
(id INT IDENTITY(1,1) PRIMARY KEY ,NAME VARCHAR(50))


CREATE TABLE MyTrigger
(id INT IDENTITY(100,5) PRIMARY KEY ,NAME VARCHAR(50))

CREATE TRIGGER t1
ON myCurrent
AFTER INSERT
as

INSERT INTO mytrigger VALUES('omar')



INSERT INTO mycurrent VALUES('ahmed')



SELECT @@IDENTITY

SELECT SCOPE_IDENTITY()

SELECT IDENT_CURRENT('MyCurrent')


CREATE UNIQUE INDEX i1 ON mycurrent(name)

INSERT INTO mycurrent VALUES('ahmed') --fail

SELECT @@IDENTITY

SELECT SCOPE_IDENTITY()

SELECT IDENT_CURRENT('MyCurrent')


INSERT INTO mycurrent VALUES('ahmed1')

SELECT @@IDENTITY

SELECT SCOPE_IDENTITY()

SELECT IDENT_CURRENT('MyCurrent')

--note use the same 4 statments in new connection and see what is the results

--how to reset identity
--1)using truncate statment
--2)use insert_identity on then off
--3)use dbcc checkident

dbcc checkident(tableNAME,RESEED,1)

DELETE FROM mycurrent

INSERT INTO mycurrent VALUES('ahmed22')

SELECT SCOPE_IDENTITY()


truncate table mycurrent

INSERT INTO mycurrent VALUES('ahmed24')

SELECT SCOPE_IDENTITY()
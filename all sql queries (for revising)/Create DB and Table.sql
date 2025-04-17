--Sparse Columns
----Sparse columns are another addition to the SQL Server 2008 tool belt. They offer a good trade-off for many applications: taking no space if they are empty and more space if they have data. In other words they optimize storage for NULL values.
----Sparse columns are just like ordinary columns with a few limitations. They are defined with the SPARSE keyword and there is no difference on how they are used in data manipulation statements.

--Here are the details:

--Pros:
--• Storing NULL in a sparse column takes up no space at all
--• Up to 30,000 columns
--• To any external application the column will behave the same
--• Sparse columns fit well with filtered indexes to index on non-NULL values

--Cons:
--• If a sparse column has data it takes 4 more bytes than a normal column
--• Not all data types can be sparse: TEXT, NTEXT, IMAGE, TIMESTAMP, user-defined data types, GEOMETRY, GEOGRAPHY, and VARBINARY(MAX) with the FILESTREAM attribute
--• Computed columns cannot be sparse
--• Cannot have default values

CREATE TABLE Survey (
      survey_nbr INT NOT NULL PRIMARY KEY,
      survey_desc VARCHAR(30),
      survey_info1 VARCHAR(30) SPARSE NULL)
      
--Database creation
CREATE DATABASE sample;

--attach Database
--Attach by Code
--u can attach data file only if u wants
USE master
GO
CREATE DATABASE [adventureWorks2012]
ON
(FILENAME=N'd:\adventureworks.mdf'),
(FILENAME=N'd:\adventureworks.ldf')
FOR ATTACH

--creates a database with explicit specifications for
--database and transaction log files.
--Because the PRIMARY option is omitted
--the first file is assumed as the primary file
--If the MAXSIZE option is not specified
--or is set to UNLIMITED, the file will grow until the disk is full
--if ON exists all files of db must be specified
CREATE DATABASE projects
ON 
(NAME=projects_dat,
FILENAME = 'f:\dbs\pro.mdf')
LOG ON
(NAME=projects_log,
FILENAME ='f:\dbs\pro.ldf')


CREATE DATABASE projects
ON (NAME=projects_dat,
FILENAME = 'f:\dbs\projects2.mdf',
SIZE = 10,
MAXSIZE = 100,
FILEGROWTH = 5)
LOG ON
(NAME=projects_log,
FILENAME = 'd:\db\projects2.ldf',
SIZE = 40,
MAXSIZE = 100,
FILEGROWTH = 10);

drop database projects

				/** MetaData Fn (scalar fn.) **/
select DB_ID()

SELECT DB_NAME() AS 'database'    
--select name of the current Database

exec sys.sp_databases
									------------------
--Returns one row for each column of an object that contains columns
--(for example, a table or a view)a row of each column in that table

select * 
from sys.tables 

--columns of the same table will have the same obj_id
select * 
from sys.columns 

select * 
from sys.columns c, sys.tables t 
where  c.object_id=t.object_id
       and t.name='student'

select * 
from sys.schemas

			------------------	
--Retrieve Info about all objects
sp_help

--Retrieving Info about all dbs
sp_helpdb

--Retrieving Info about a specific db
sp_helpdb iti

--To retrieve info. about a specific Table (schema,columns,keys,indexes)
sp_help student

--To retrieve info. about a specific DataType
sp_help nvarchar
/*Type_name:nvarchar		Storage_type:nvarchar
    Length: 8000					Prec :4000
    Scale:NULL					Nullable:  yes
    Default_name:none		Rule_name:  none
    Collation:SQL_Latin1_General_CP1_Cl_AS 
*/
						
--Retrieving MetaDate about a DB file "data file"
select * from sys.database_files
where name='AdventureWorks_Data'				
													

select file_id( N'iti2')  --Returns the file ID for the given
							   --logical file name in the current database.

select FILE_NAME(1)			   --Returns the logical file name
							   --for the given file ID.

select FILEGROUP_ID('primary') --Returns the filegroup ID for
							   -- a specified filegroup name.

select FILEGROUP_NAME(1)	   --Returns the filegroup name
							   --for the specified filegroup ID.
									------------------------				------------------
--To check the value of a specific db property
SELECT DATABASEPROPERTY
('iti', 'IsAutoShrink')

								------------------
--Retrieving Info about the db size, unallocated space
--data size, index size, free "unused" space


--retrieve info about all DBs in server
--Returns one row for each file of a database
--ay 7aga sys. 3bara 3an views

select * 
from sys.database_files
									------------------
use master
select * from sys.databases


								------------------
									------------------------	
--You can query the sys.filegroups catalog view 
--to view the files in the newly created database:
USE MyNewDB
GO
SELECT fg.name as file_group,
df.name as file_logical_name,
df.physical_name as physical_file_name
FROM sys.filegroups fg
join sys.database_files df
on fg.data_space_id = df.data_space_id	
				------------------------------
--getting the schemas from specified db
SELECT name,
SCHEMA_NAME(schema_id) as schemaName,
USER_NAME(principal_id) as principal
FROM AdventureWorks.sys.schemas	
				--------------------------------
--To retrieve data about tables in a specific schema
SELECT TABLE_NAME
FROM AdventureWorks.INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Purchasing'
ORDER BY TABLE_NAME	
				-------------------------------
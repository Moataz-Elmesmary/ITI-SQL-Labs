-------------------------------------------------------------
-------------------------------------------------------------
--Create logins
----Windows authentication
USE [master]
GO
CREATE LOGIN [HANY-PC\Hany] FROM WINDOWS 
WITH DEFAULT_DATABASE=[ITI]
GO

----SQL Authentication
USE [master]
GO
CREATE LOGIN [test] WITH PASSWORD=N'iti', DEFAULT_DATABASE=[ITI], 
CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
--Create user
USE [ITI]
GO
CREATE USER [Test_iti_db] FOR LOGIN [test]
GO

sp_who		--return the login name who is connected right now
-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
--Create Schema with specific owner
--specify the benefits os the schema
CREATE SCHEMA schema_name 
AUTHORIZATION owner_name; --owner is one of the users

--example
create schema sch1
authorization ahmed

alter schema sch1 transfer pivoting

drop schema sch1 --cann't drop because it has objects inside it
-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------
--permissions by code
--Grant & deny
/* http://msdn.microsoft.com/en-us/library/ms178640.aspx
GRANT permission [ ,...n ] } 
    ON LOGIN ::SQL_Server_login
        TO <server_principal> [ ,...n ]
    [ WITH GRANT OPTION ]
    [ AS SQL_Server_login ]
    
--Arguments 
--permission 
Specifies a permission that can be granted on a SQLServer login
For a list of the permissions,see the Remarks section later in 
this topic.

--LOGIN :: SQL_Server_login
Specifies the SQL Server login on which the permission is being
granted. The scope qualifier (::) is required.

--TO <server_principal> 
Specifies the SQL Server login to which the permission is being
granted.

--SQL_Server_login 
Specifies the name of a SQL Server login.

--SQL_Server_login_from_Windows_login 
Specifies the name of a SQL Server login created from a Windows login.

--SQL_Server_login_from_certificate 
Specifies the name of a SQL Server login mapped to certificate.

--SQL_Server_login_from_AsymKey 
Specifies the name of a SQL Server login mapped to 
an asymmetric key.

--WITH GRANT OPTION
Indicates that the principal will also be given the ability
to grant the specified permission to other principals.

--AS SQL_Server_login
Specifies the SQL Server login from which the principal executing this query derives its right to grant the permission.
*/

--SQL server permissions
grant select on dbo.Course 
to [Hany-PC\Hany];

grant update on dbo.Course
to [Hany-PC\Hany] with grant option;

deny select on dbo.Course
to [Hany-PC\Hany];

revoke select on dbo.Course
to [Hany-PC\Hany];

--system info tables for security issues
select *
from sys.database_permissions

select *
from sys.database_principals     --Returns one row for each security
								 --principal in the database
								 --(DB roles+...??)

select *
from sys.database_role_members   --Returns one row for each member 
								 --of each database role

select name from sysusers

Select * from sys.server_principals
Select * from sys.database_principals

Create user Ali without login
Alter login Ahmed disable

Select * from sys.fun_my_permissions(null,’Server’)

Select * from sys.fun_my_permissions(null,’Database’)
Grant select on object::table_name to iti_users 

Create role r1
Sp_addrolemember ‘r1’,’ahmed’
Grant insert into object::table_name to r1
Set user ‘ahmed’
Insert into table_name values (1,‘SD’)

Select * from sys.schema
Create user X from Lohin X
Create user Y from Login Y with default_Schema=’Alex’

Select * from sys.database_principle where name in (‘X’,’Y’)
Alter user X with default_Schema=’Alex’
Sp_helpsrvrole
Sp_srvrolepermission ‘sysadmin’
Sp_addsrvrolemember ‘ahmed’,’sysadmin’
Sp_dropsrvrollmember  ‘ahmed’,’sysadmin’
Sp_helprole
Sp_rolepermission ‘sysadmin’
Sp_addrolemember ‘ahmed’,’dbowner’
Sp_droprollmember  ‘ahmed’,’dbowner’
--change owner
Alter authorization on database::DB1 to ‘ahmed’

--partitioning
--partition function
--Patition function specify in it (col_data_type,range)
create partition function pfn(int)
as range left
for values (10,20,30)
--exists in Storage=>Partition Functions
---------------------------------------
drop partition scheme pschema	--execute this first before trying to drop the partition function
--Partition scheme
create partition scheme pschema
as partition pfn
to (fg1,fg2,fg3,fg4)
--exists in Storage=>Partition Schemes
---------------------------------------
create table t
(
fullName nvarchar(30),
age int
)on pschema(age)
------------------------------
insert into t values
('Farida',12)
,('Adham',9)
,('Mohab',21)
,('Darin',33)
,('Logy',25)

------------------------------
select * ,$partition.pfn(age)
from t

-------------------------------------
select * 
from sys.partitions
where OBJECT_NAME(OBJECT_ID )='t'
-------------------------------------------------



select * ,filegroup_name($partition.pfun(salary))
from emp

------------------------------------
	ALTER TABLE 
	SWITCH PARTITION 4 TO FactInternetSales_Partitioned PARTITION 4


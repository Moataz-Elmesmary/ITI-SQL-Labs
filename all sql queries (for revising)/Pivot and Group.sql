--rollup and cube

use test

create table sales
(
ProductID int,
SalesmanName varchar(10),
Quantity int
)
truncate table sales

insert into sales
values  (1,'ahmed',10),
		(1,'khalid',20),
		(1,'ali',45),
		(2,'ahmed',15),
		(2,'khalid',30),
		(2,'ali',20),
		(3,'ahmed',30),
		(4,'ali',80),
		(1,'ahmed',25),
		(1,'khalid',10),
		(1,'ali',100),
		(2,'ahmed',55),
		(2,'khalid',40),
		(2,'ali',70),
		(3,'ahmed',30),
		(4,'ali',90),
		(3,'khalid',30),
		(4,'khalid',90)
		
select ProductID,SalesmanName,quantity
from sales

select isnull(Name,'my total'),qty
from (
	select SalesmanName as Name,sum(quantity) as Qty
	from sales
	group by rollup(SalesmanName)
	) as newta
	ble

select isnull(x,0),Quantities
from (
	select ProductID as X,sum(quantity) as "Quantities"
	from sales
	group by rollup(ProductID)
	) as newtable

select ProductID as X,sum(quantity) as "Quantities"
	from sales
	group by rollup(ProductID)

select SalesmanName as Name,sum(quantity) as Qty
	from sales
	group by rollup(SalesmanName)
		
--order by ProductID,SalesmanName
select SalesmanName,sum(quantity) as "Quantities"
from sales
group by rollup(SalesmanName)


select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by ProductID,SalesmanName

select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by rollup(ProductID,SalesmanName)

select SalesmanName,ProductID,sum(quantity) as "Quantities"
from sales
group by rollup(SalesmanName,ProductID)

select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by cube(ProductID,SalesmanName)

--order by ProductID,SalesmanName


select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by cube(ProductID,SalesmanName)
--order by ProductID,SalesmanName

--grouping sets
select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by grouping sets(ProductID,SalesmanName)
order by SalesmanName

----Pivot and Unpivot OLAP
--if u have the result of the previouse query
select ProductID,SalesmanName,sum(quantity) as "Quantities"
from sales
group by SalesmanName,ProductID

SELECT * 
FROM sales 
PIVOT (SUM(Quantity) FOR SalesmanName IN ([Ahmed],[Khalid])) as PVT

select * from newtable


--how to get the table
SELECT * FROM newtable 
UNPIVOT (qty FOR salesname IN ([Ahmed],[Khalid],[Ali])) UNPVT



execute('SELECT * FROM sales 
PIVOT(SUM(Quantity) FOR SalesmanName IN (p1))')

PVT


alter proc p1
as
select distinct(salesmanname)
from sales

p1



--Scalar Function
--string getname(int id)
alter function getname(@id int)
returns varchar(22)
	begin
		declare @name varchar(22)
		select @name=st_fname from Student
		where st_id=@id
		return @name
	end

drop function dbo.getname

select dbo.getname(3)
--------------------------------------

--inline function
alter function getinst(@did int)
returns table
as
return
(
 select ins_name,salary*12 as total,dept_id
 from Instructor
 where dept_id=@did
)


select F.*,dept_name 
from getinst(20) F inner join Department d
	on d.Dept_Id=f.dept_id


select * into newtable
from getinst(20)

------------------------
--multistatment
create function getstS(@format varchar(10))
returns @t table
			(
			 id int,
			 name varchar(20)
			)
as
	begin
		if @format='first'
			insert into @t
			select st_id,st_fname from student

		else if @format='last'
			insert into @t
			select st_id,st_Lname from student
		else if @format='full'
			insert into @t
			select st_id,st_fname+' '+st_lname from student
		RETURN 
	end


SELECT * from getsts('first')


select ins_name from getinst(30)
union all
select st_fname from student





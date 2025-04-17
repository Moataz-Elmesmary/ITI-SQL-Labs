--new functions in SQL 2012
--1) logical Fun
--IIF
SELECT Ins_Name,IIF(Salary>3000,'High','Low')
from instructor

SELECT Ins_Name,sal=
CASE
WHEN Salary>3000 then 'High'
ELSE 'Low'
END
FROM Instructor

--choose
--syntax is -> choose(@index,[Array of parameters.....])
declare @x int=3
SELECT CHOOSE(@x,'A','B',
'C','D') AS Chooseee

declare @x int=3



SELECT CHOOSE(st_id,'One',
'Two','Three','Four','Five',
'Six','Seven','Eight',
'Nine','Ten') as ID,st_fname 
FROM student
where st_id<=10

DECLARE @x INT=3
SELECT CHOOSE(@x,'sat','sun','mon','tues','wed','thur','fri') AS MyDay

--choose instead of cace
DECLARE @x INT=3
SELECT MyDay=
	    CASE @x
		WHEN 1 THEN 'Sat'
		WHEN 1 THEN 'sun'
		---------
		---------
		end


--2) String Fun
--Concat
--used to do implicit convert
--convert all to string and treat null as emty
--Concat 
-- + operator and concat function do the same
select st_fname+' '+st_lname
from student

select concat(st_fname,' ',st_lname)
from student

--no conversion needed and No Null Problem
select concat(st_fname,' ',st_age)
from student

select st_fname+' '+st_age
from student

select isnull(st_fname,0)+' '+convert(varchar(10),st_age)
from student

--old solution is using +,convert,isnull
SELECT CONCAT('happy',' birthday ',1,'/',10,'/',NULL)

--Format
--Instead of using the messy CONVERT or CAST functions, you can use FORMAT instead:
SELECT FORMAT(getdate(),'')
SELECT FORMAT(getdate(),'dd MM yy')
SELECT FORMAT(getdate(),'dddd MMMM yyyy')
SELECT FORMAT(getdate(),'ddd MMM yyyy')
SELECT FORMAT(getdate(),'dddd  dd MMMM yyyy')
SELECT FORMAT(getdate(),'dddd  dd MMMM yyyy hh mm ss')
SELECT FORMAT(getdate(),'dddd  dd MMMM yyyy HH mm ss')
SELECT FORMAT(getdate(),'MM-dd-yyyy hh:mm:ss tt')
SELECT FORMAT(getdate(),'dddd MMMM d, yyyy HH:mm')

SELECT Dept_name,
FORMAT(Manager_hiredate,'dddd dd MMMM yyyy') AS FormattedDate
FROM department

select @@language
SET LANGUAGE 'English'

DECLARE @old_language VARCHAR(50)=@@language
DECLARE @new_Language VARCHAR(50)='Japanese' --or Dutch 

SELECT FORMAT(getdate(),'dddd')

SET LANGUAGE @new_language
SELECT FORMAT(getdate(),'dddd')

SET LANGUAGE @old_language


--3) Math Fun
--Log
SELECT LOG10(10)


--5) Date Fun
--EOMonth

--Date
SELECT EOMONTH(GETDATE())
SELECT EOMONTH(GETDATE(),-2)

SELECT FORMAT( EOMONTH(getdate()),'dddd')
SELECT DATEPART(Day,EOMONTH(GETDATE()))

--DateFromparts
--TimeFormaters
--DateFromparts
--DATEFROMPARTS


--over and its new functions called windowing lookup functions

CREATE TABLE Mysales
(productid INT, price int,Sale_date DATE)

INSERT INTO mysales 
VALUES(1,100,'1/1/2013'),
	  (2,120,'1/1/2013'),
	  (3,150,'1/1/2013'),
	  (1,90,'1/4/2013'),
	  (2,200,'1/4/2013'),
	  (3,50,'1/4/2013'),
	  (4,80,'1/4/2013'),
	  (1,300,'1/3/2013'),
	  (2,310,'1/3/2013'),
	  (3,340,'1/3/2013'),
	  (4,500,'1/3/2013')

TRUNCATE TABLE mysales

SELECT productid,price,
	   Prod_prev=lAG(price) OVER(ORDER BY price),
	   Prod_Next=LEAD(price) OVER(ORDER BY price )
FROM mysales

SELECT productid,price,
       Prod_prev=lAG(price) OVER(PARTITION BY productid ORDER BY price),
	   Prod_Next=LEAD(price) OVER(PARTITION BY productid ORDER BY price )
FROM mysales

SELECT productid,price,
	   lowest=FIRST_VALUE(price) OVER(PARTITION BY productid ORDER BY price ),
	   Highest=LAST_VALUE(price) OVER(PARTITION BY productid ORDER BY price ROWS BETWEEN unbounded preceding AND unbounded following),
	   Prod_prev=lAG(price) OVER(PARTITION BY productid ORDER BY price),
	   Prod_Next=LEAD(price) OVER(PARTITION BY productid ORDER BY price )
FROM mysales

--lag and lead parameters
SELECT productid,price,
	   Prod_prev=lAG(price) OVER(PARTITION BY productid ORDER BY price),
	   Prod_prev_diff=price-isnull(lAG(price) OVER(PARTITION BY productid ORDER BY price),0)
FROM mysales


SELECT productid,price,
	   Prod_prev=lAG(price) OVER(PARTITION BY productid ORDER BY price),
	   Prod_prev_diff=isnull(price,0)-isnull(lAG(price) OVER(PARTITION BY productid ORDER BY price),0),
	   Prod_Next=LEAD(price) OVER(PARTITION BY productid ORDER BY price ),
	   Prod_Next_diff=isnull(price,0)-isnull(LEAD(price) OVER(PARTITION BY productid ORDER BY price),0)
FROM mysales

SELECT productid,price,
	   lowest=FIRST_VALUE(price) OVER(ORDER BY price),
	   Highest=LAST_VALUE(price) OVER(ORDER BY price ROWS BETWEEN unbounded preceding AND unbounded following),
	   Prod_prev=lAG(price) OVER(ORDER BY price),
	   Prod_Next=LEAD(price) OVER(ORDER BY price )
FROM mysales
---Advanced

DECLARE @date DATETIME=DATETIMEFROMPARTS(2011,10,20,1,30,0,0)
SELECT FORMAT(@date,'')

--4) Conversion Fun
--Try_Convert
--There are now several functions which try to parse data from one type to another
--, and return Null if the conversion fails

--try_Convert
--try_convert is like convert but it returns null if conversion failed
SELECT CONVERT(money,'text')
SELECT CONVERT(MONEY,'22.0')

SELECT try_CONVERT(money,'text','') AS x
SELECT try_CONVERT(money,'22.0','') AS y

--Parse
--Try_Parse

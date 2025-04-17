use test
create table dept
(
did int primary key,
name text
)

create table emp
(
eid int  not null,
ename nvarchar(50),
esal int,
constraint c1
check (esal>100)
,
eadd nvarchar(50) default 'cairo'
,
constraint c2
check (eadd in ('cairo','alex'))
,
overtime int,
constraint c4
check (overtime between 100 and 1000)
, constraint c3
primary key(eid)
,
did int,

constraint c5
foreign key(did)
references dept(did)
)

alter table emp
add constraint c55
unique (ename)

alter table emp
drop constraint c55

sp_helpconstraint emp

--Create Default--
------------------------------
create default dcity as 'tanta'

sp_bindefault dcity,'student.st_address'

insert into student(id,sname) values(667,'khalid') --city will entered as defaut 'tanta'
--go to table to see reflection

drop default dcity  --cann't drop because it is bound to a column

sp_unbindefault 'student.st_address'
--then drop default
----------------------------------
--Create Rule--
--------------------------
--as check constraint

create rule rage as @age>10 --@salary is a variable refers to the bounded column

--rules override each others 
sp_bindrule rage,'student.st_age'
--only one rule per column

insert into student(id,salary) values(865,40)--salary<40 reflect with rule

drop rule rage  --cann't drop because it is bound to a column	

sp_unbindrule "student.st_age"
--then drop rule
---------------------------------------------------------------------------------------
--Craete Datatype-
--user defined datatypes

sp_addtype new_dtype,'nvarchar(50)'
--change sname datatype to be
-- see table modification wizerd
alter table student
alter column st_fname new_dtype

sp_droptype new_dtype
------------------------------------------
Anther method

--creates an alias type based on the system-supplied varchar data type
CREATE TYPE SSN
FROM varchar(11) NOT NULL ;

CREATE TYPE ShortDescription
FROM nvarchar(10) NOT NULL ;

--binding rule+default+datatype--
------------------------------------------

sp_bindefault dcity,new_dtype

insert into student(id) values(44)

sp_bindrule rsalary,new_dtype

--if data type is bound on column before bound rule 
sp_bindrule rsalary,new_dtype ,'futureonly'


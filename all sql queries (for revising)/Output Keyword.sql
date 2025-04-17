----DML with output
--only one trip to the serve
--dealing with virtual tables "deleted and inserted"

--insert with output
--two Trips
insert into Student
values(777,'hossam','ahmed','tanta',26,10,1)

SELECT * FROM Student WHERE St_Id=777


--one trip
insert into Student
output inserted.*
values(999,'hossam','ahmed','tanta',26,10,1)

create table studenttest
(ID int,
Dates Datetime)

--keep tracking of the inserted value
insert into Student
output inserted.st_id,getdate() into studenttest
values(1004,'hossam','ahmed','tanta',26,10,1)

select * from studenttest


--update with output
update Department
set Dept_Location = 'cairo'
output deleted.*,inserted.*
where Dept_Name='SD'

--delete and output
delete from student
output deleted.*
where st_id=14

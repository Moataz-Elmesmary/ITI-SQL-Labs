--Sequence
--Create Sequence Object 
Create SEQUENCE MySequence
START WITH 1
INCREMENT BY 1
MinValue 1
MaxValue 5
CYCLE; --default

alter SEQUENCE MySequence
ReSTART WITH 1 --changed from start to restart
INCREMENT BY 1
CYCLE; --default  

drop SEQUENCE MySequence 

-- Create Temp Table
create TABLE person1
(ID int,
FullName nvarchar(100) NOT NULL);

create TABLE person2
(ID int,
FullName nvarchar(100) NOT NULL);

drop table person1
drop table person2

truncate table person1
truncate table person2
-- Insert Some Data 
INSERT into person1
VALUES (NEXT VALUE FOR MySequence, 'ahmed')

INSERT into person2
VALUES (NEXT VALUE FOR MySequence, 'ahmed1')


select * from person1
select * from person2

select name,minimum_value,maximum_value,current_value,is_cycling
from sys.sequences
where name='Mysequence'

update person1 
set id=NEXT VALUE FOR MySequence
where id=2

--advantages of sequence than identity
--1)not need to use insert statment to be increased because it is used with update
--2)cycle
--3)shared between tables
--4)there is no (insent_identity on and off) not needed
--note if u have sequence object (s1) and u want it to be default value of a column (id)
ALTER TABLE tb1
ADD DEFAULT NEXT VALUE for s1 FOR id


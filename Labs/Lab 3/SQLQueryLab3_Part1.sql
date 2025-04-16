Select * From Departments
SELECT * FROM Dependent
Select * from Employee
SELECT * FROM Project
SELECT * FROM WORKS_FOR

-- 1. Display the Department id, name and id and the name of its manager.
select d.Dname ,d.Dnum ,e.SSN 
,e.Fname+' '+e.Lname as Name

from Departments d INNER JOIN Employee e
	on d.MGRSSN = e.SSN

-- 2. Display the name of the departments and the name of the projects under its control.
select d.Dname ,p.Pname

from Departments d join Project p 
	on d.Dnum = p.Dnum

-- 3. Display the full data about all the dependence associated with the name of the employee they depend on him/her.
select d.*, e.Fname+' '+Lname as name
from Dependent d left outer join Employee e 
	on d.ESSN = e.SSN

-- 4. Display the Id, name and location of the projects in Cairo or Alex city.
select Pnumber , Pname , Plocation
from Project
where city in ('Cairo','Alex')

-- 5. Display the Projects full data of the projects with a name starts with "a" letter.
select * 
from Project
where Pname LIKE 'a%'

-- 6. display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
select * 
from Employee
where Dno = 30 AND Salary Between 1000 AND 2000 -- where City LIKE 'Cairo' OR City LIKE 'Alex'

-- 7. Retrieve the names of all employees in department 10 who works more than or equal 10 hours per week on "AL Rabwah" project.
select Fname +' '+Lname as name 
from Employee e join Works_for w
	on e.SSN = w.ESSn
JOIN Project p
	on w.Pno = p.Pnumber
where Dno = 10 and w.Hours >= 10 AND p.Pname = 'Al Rabwah'

-- 8. Find the names of the employees who directly supervised with Kamel Mohamed.
select a.Fname +' '+a.Lname as name 
from Employee a , Employee b
where a.Superssn = b.SSN
and b.Fname +' '+b.Lname ='Kamel Mohamed'

-- 9. Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
select Fname +' '+Lname as name, Pname 

from Employee join Works_for 
	on Employee.SSN = Works_for.ESSn 
join Project 
	on Project.Pnumber = Works_for.Pno 
order by Pname


-- 10. For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.
select p.Pnumber, d.Dname, e.Lname, e.Address, e.Bdate
from Project p join Departments d 
	on p.Dnum = d.Dnum
join Employee e ON d.MGRSSN = e.SSN
where p.City = 'Cairo'

-- 11. Display All Data of the managers
select e.*
from Employee e join Departments d ON e.SSN = d.MGRSSN

-- 12. Display All Employees data and the data of their dependents even if they have no dependents
select e.* , d.*
from Employee e left join Dependent d 
	on e.SSN = d.ESSN;

-- 13. Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
insert into Employee
values ( 'Kholod', 'Sadek', 102672, '2004-03-11', '1st cairo', 'F', 3000, 112233, 30)

-- 14. Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, but don’t enter any value for salary or supervisor number to him.
insert into Employee (Fname, Lname, SSN, Bdate, Address, Sex, Dno)
values ( 'ahmed' , 'ali' , 101110 , '2000-11-11' , '2st alex' , 'F' , 30 )

-- 15. Upgrade your salary by 20 % of its last value.
update Employee
set Salary = Salary *1.2
where SSN = 102672;
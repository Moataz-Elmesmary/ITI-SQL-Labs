
select s.st_id as sid,st_fname as sname,grade,crs_name as Cname into grades
from Student s,Stud_Course sc,Course c
where s.St_Id=sc.St_Id and c.Crs_Id=sc.Crs_Id

select * from grades


SELECT sname,grade,
	   Prod_prev=lAG(sname) OVER(ORDER BY grade),
	   Prod_Next=LEAD(sname) OVER(ORDER BY grade)
FROM grades

SELECT sname,grade,cname,
	   Prod_prev=lAG(grade) OVER(partition by Cname ORDER BY grade),
	   Prod_Next=LEAD(grade) OVER(partition by Cname ORDER BY grade)
FROM grades

SELECT sname,grade,
	   First=FIRST_VALUE(grade) OVER(ORDER BY grade),
	   last=LAST_VALUE(grade) OVER(ORDER BY grade Rows BETWEEN unbounded preceding AND unbounded following)
FROM grades

SELECT sname,grade,Cname,
	    FIRST_VALUE(grade) OVER(partition by Cname ORDER BY grade),
	   LAST_VALUE(grade) OVER(partition by Cname ORDER BY grade Rows BETWEEN unbounded preceding AND unbounded following)

FROM grades

SELECT sname,grade,
	   Prod_prev=lAG(grade) OVER(ORDER BY grade),
	   Prod_Next=LEAD(grade) OVER(ORDER BY grade),
	   First=FIRST_VALUE(grade) OVER(ORDER BY grade),
	   last=LAST_VALUE(grade) OVER(ORDER BY grade Rows BETWEEN unbounded preceding AND unbounded following)
FROM grades

SELECT sname,grade,Cname,
	   Prod_prev=lAG(Sname) OVER(partition by Cname ORDER BY grade),
	   Prod_Next=LEAD(Sname) OVER(partition by Cname ORDER BY grade),
	   First=FIRST_VALUE(Sname) OVER(partition by Cname ORDER BY grade),
	   last=LAST_VALUE(Sname) OVER(partition by Cname ORDER BY grade Rows BETWEEN unbounded preceding AND unbounded following)
FROM grades

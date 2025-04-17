
--offset and fetch is called server side pageing 
--Fetch and Offset or Page Data 
--like data paging in data grid
SELECT *
FROM student
ORDER BY st_age
OFFSET 5 ROWS
FETCH NEXT 5 ROWS ONLY;

--in SQL 2008
SELECT *
FROM (
SELECT *,ROW_NUMBER() OVER(ORDER BY st_age) AS age
FROM student) AS TempTable
WHERE age > 5 and age <= 10


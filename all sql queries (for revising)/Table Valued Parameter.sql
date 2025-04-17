

--Table Valued Parameter  (new feature 2008)
--is used with function and Stored procedure to pass a table as a single parameter to Fun or SP
--i can use it to pass data from SP to anther
--it is a like schema or user defined types
--can be indexed
--it is readonly so it can't be treated output parameter in SP
--variables that is created from Type TVP is saved in Tempdb
--when using TVP with ado.net -> use SQLDbType.Sturctured
--when using TVP with Ado i send a table in dataset as one parameter to SP so no more round trips
--no alter statment to TVP u shoud drop it and recreat
CREATE TYPE TVP AS TABLE
(id int,
name varchar(50)
)
--i will find it in types folder

--i can declare a variable of type TVP
DECLARE @x AS TVP

INSERT INTO @x 
VALUES(1,'A'),(1,'B'),(1,'C')

SELECT * FROM @x AS x




CREATE FUNCTION f1 (@tvp1 AS TVP readonly)
RETURNs int
AS
begin
DECLARE @c INT
SELECT @c=COUNT(*) FROM @tvp1
RETURN @c
end






DECLARE @x AS TVP

INSERT INTO @x 
select st_id,st_fname from student

SELECT dbo.f1(@x)



CREATE PROC p1 (@tvp1 AS TVP  readonly)
AS
SELECT * FROM @tvp1 


DECLARE @x AS TVP
INSERT INTO @x VALUES(1,'A'),(1,'B'),(1,'C')
EXEC p1 @x
EXEC p1 --run without errors



CREATE PROC p1 (@tvp1 AS TVP  readonly)
AS
SELECT * FROM @tvp1 














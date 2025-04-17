-------------------------------------------------------
/*
The first index on an XML column is the 
"primary XML index". Using it, three types of 
secondary XML indexes can be created on the 
XML column to speed up common classes of queries
*/
--CREATE PRIMARY XML INDEX idx_xCol 
--on docs (xCol)

----------------------------------------------------------
SELECT pk, xCol
FROM   docs
WHERE  xCol.exist ('/book[@genre = "security"]') = 1
/*
secondary XML index of type PATH is helpful for this workload
*/
------------------------------------------------------------
CREATE XML INDEX idx_xCol_Path 
on docs (xCol)
USING XML INDEX idx_xCol 
FOR PATH
--------------------------------------------------------------------
CREATE XML INDEX idx_xCol_Property 
on docs (xCol)
USING XML INDEX idx_xCol 
FOR PROPERTY
--------------------------------------------------------------------
SELECT xCol
FROM   docs
WHERE  
xCol.exist ('//book/@ISBN[. = "0-7356-1588-2"]') = 1
/*
a partial path is specified using //, so that the lookup based 
on the value of ISBN could use the VALUE index
*/
-------------------------------------------------------------------
CREATE XML INDEX idx_xCol_Value 
on docs (xCol)
USING XML INDEX idx_xCol 
FOR VALUE
-----------------------------------------------------------------------
CREATE FUNCTION udf_get_book_ISBN (@xData xml)
RETURNS varchar(20)
WITH SCHEMABINDING
BEGIN
   DECLARE @ISBN  varchar(20)
   SELECT @ISBN 
		 = @xData.value('/book[1]/@ISBN', 'varchar(20)')
   RETURN @ISBN 
END
----------------------------------------------------------------------
ALTER TABLE docs
ADD   ISBN --calculated column name
AS dbo.udf_get_book_ISBN(xCol)
----------------------------------------------------------------------
select * from docs
----------------------------------------------------------------------
SELECT pk, xCol
FROM   docs
WHERE  xCol.exist ('/book[@ISBN = "0-7356-1588-2"]') = 1


SELECT pk, xCol
FROM   docs
WHERE  ISBN = '0-7356-1588-2'
--using the new column
----------------------------------------------------------------------
INSERT INTO docs 
VALUES 
(2,'<book genre="testing" publicationdate="2002" ISBN="0-7356-1588-1">
   <title>Writing  Code</title>
   <author>
      <first-name>M</first-name>
      <last-name>H</last-name>
   </author>
   <author>
      <first-name>A</first-name>
      <last-name>B</last-name>
   </author>
   <price>40.99</price>
</book>')
-----------------------------------------------------------------------
select * from docs

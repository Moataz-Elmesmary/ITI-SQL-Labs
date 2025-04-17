write method 
--used only with varcharmax
--If u have a big text in a column and u want to update part of it u can use write method
--Notes:
----Offset and length may be variables
----Offset is the start point and it is Zero-based
----If offset is NULL means append to existing Column
----Length is the length from the offset to be replaced
----If length is NULL means removes all data from offset to the end of the Column value
Update Course
Set course_DESC.Write('SQL intro',@offset,@length)
Where course_Name='SQL Server'

Update Course
Set crs_DESC.Write('ahmed',1,1)
Where crs_Name='SQL Server'
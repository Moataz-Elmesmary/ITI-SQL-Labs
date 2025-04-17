
--bulk insert 
----1)try to use impot\export wizard to export data of sales 
----table to be delimited file and don't put columns names 
----in the first row of the file
----"Skipping headers isnot supported by BULK INSERT statement"
----2)in full recovery this statment is saved accourding 
----number f records but in bulk-logged this statment is 
----saved as one statment "performance with"
bulk insert sales
from 'D:\DB\sales.txt'
with (fieldterminator=',')
------------------------------
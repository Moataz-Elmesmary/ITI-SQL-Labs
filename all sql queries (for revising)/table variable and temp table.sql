
--temp tables & table variables
--table variables don't listen to db transactions and Triggers
USE tempdb
go

CREATE TABLE test1 (id int)
go

DECLARE @test2 TABLE(id int)


BEGIN TRANSACTION
	INSERT INTO test1 VALUES(1)
	INSERT INTO @test2 VALUES(2)
ROLLBACK
	
	SELECT * FROM test1

	SELECT * FROM @test2
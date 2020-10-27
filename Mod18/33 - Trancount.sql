-- Create a table to use during the tests
drop table tb_TransactionTest
create table tb_TransactionTest (value int)
GO
-- TEST_01. Using 2 transactions and a rollback on the 
-- inner transaction
BEGIN TRANSACTION -- outer transaction
    PRINT @@TRANCOUNT
    INSERT INTO tb_TransactionTest VALUES (1)
    BEGIN TRANSACTION -- inner transaction
        PRINT @@TRANCOUNT
        INSERT INTO tb_TransactionTest VALUES (2)
    ROLLBACK -- roll back the inner transaction
    PRINT @@TRANCOUNT
    INSERT INTO tb_TransactionTest VALUES (3)
-- We get an error here because there is no transaction
-- to commit.
COMMIT -- commit the outer transaction
PRINT @@TRANCOUNT
SELECT * FROM tb_TransactionTest
GO
-- TEST_02. Using 2 transactions and a rollback on the 
-- outer transaction
BEGIN TRANSACTION -- outer transaction
    PRINT @@TRANCOUNT
    INSERT INTO tb_TransactionTest VALUES (1)
    BEGIN TRANSACTION -- inner transaction
        PRINT @@TRANCOUNT
        INSERT INTO tb_TransactionTest VALUES (2)
    COMMIT -- commit the inner transaction
    PRINT @@TRANCOUNT
    INSERT INTO tb_TransactionTest VALUES (3)
ROLLBACK -- roll back the outer transaction
PRINT @@TRANCOUNT
SELECT * FROM tb_TransactionTest
GO

-- TEST_03. Using @@TRANCOUNT to avoid an error when we
-- used a ROLLBACK. 
-- Clean up from last time
BEGIN TRANSACTION -- outer transaction
    PRINT @@TRANCOUNT
    INSERT INTO tb_TransactionTest VALUES (1)
    BEGIN TRANSACTION -- inner transaction
        PRINT @@TRANCOUNT
        INSERT INTO tb_TransactionTest VALUES (2)
    ROLLBACK --roll back the inner transaction
    PRINT @@TRANCOUNT
    INSERT INTO tb_TransactionTest VALUES (3)
    IF @@TRANCOUNT > 0
        -- No error this time
        COMMIT -- commit the outer transaction
PRINT @@TRANCOUNT
SELECT * FROM tb_TransactionTest
GO
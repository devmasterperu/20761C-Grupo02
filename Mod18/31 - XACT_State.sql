SET XACT_ABORT ON;
BEGIN TRY
	BEGIN TRAN;
	DECLARE @i AS INT = CAST('25.10' AS INT);
	-- normally there would be work here that warrants a transaction
	print XACT_STATE()
	COMMIT TRAN;
	print XACT_STATE()
END TRY
BEGIN CATCH
	print XACT_STATE()
	PRINT
	CASE XACT_STATE()
		WHEN 0 THEN 'No open transaction.'
		WHEN 1 THEN 'Transaction is open and committable.'
		WHEN -1 THEN 'Transaction is doomed.'
	END;

	IF @@TRANCOUNT > 0
	print '@@TRANCOUNT'
	ROLLBACK TRAN;
END CATCH;
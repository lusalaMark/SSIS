IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='f_CustomerLastTransactionDate') BEGIN
   EXEC('CREATE function [dbo].[f_CustomerLastTransactionDate] as')
END
GO


alter function [dbo].[f_CustomerLastTransactionDate] 
(	
	@CustomerID Varchar(MAX)
)
RETURNS date 

AS


BEGIN 
DECLARE @LasTrxDate date

SELECT @LasTrxDate = MAX(CreatedDate) FROM vfin_JournalEntries WHERE CustomerAccountId IN (SELECT id FROM dbo.vfin_CustomerAccounts WHERE CustomerId = @CustomerID)

RETURN @LasTrxDate

END



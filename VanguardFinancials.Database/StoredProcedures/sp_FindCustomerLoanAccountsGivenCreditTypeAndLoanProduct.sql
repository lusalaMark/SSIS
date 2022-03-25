USE [VanguardFinancialsDB_CS]
GO

/****** Object:  StoredProcedure [dbo].[sp_FindCustomerLoanAccountsGivenCreditTypeAndLoanProduct]    Script Date: 12/19/2016 12:09:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Centrino
-- Create date: 20.06.2014
-- Description:	FindCustomerLoanAccountsGivenCreditTypeAndLoanProduct
-- =============================================
CREATE PROCEDURE [dbo].[sp_FindCustomerLoanAccountsGivenCreditTypeAndLoanProduct] 
	-- Add the parameters for the stored procedure here
	@CreditTypeID uniqueidentifier, 
	@LoanProductID uniqueidentifier 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT dbo.vfin_CustomerAccounts.*
FROM     dbo.vfin_CustomerCreditTypes INNER JOIN
                  dbo.vfin_Customers ON dbo.vfin_CustomerCreditTypes.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                  dbo.vfin_CustomerAccounts ON dbo.vfin_Customers.Id = dbo.vfin_CustomerAccounts.CustomerId
WHERE  (dbo.vfin_CustomerCreditTypes.CreditTypeId = @CreditTypeID) AND (dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = @LoanProductID)
END



GO



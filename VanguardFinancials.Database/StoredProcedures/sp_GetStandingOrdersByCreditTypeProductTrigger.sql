USE [VanguardFinancialsDB_CS]
GO

/****** Object:  StoredProcedure [dbo].[sp_GetStandingOrdersByCreditTypeProductTrigger]    Script Date: 12/19/2016 4:18:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Centrino
-- Create date: 04.07.2014
-- Description:	GetStandingOrdersByEmployerAndTrigger
-- =============================================
--sp_GetStandingOrdersByCreditTypeAndTrigger '87aa5e3a-98b9-44aa-a07a-cc6bc2b6fe18',0
CREATE PROCEDURE [dbo].[sp_GetStandingOrdersByCreditTypeProductTrigger] 
	-- Add the parameters for the stored procedure here
	@CreditTypeID UniqueIdentifier , 
	@ProductID UniqueIdentifier , 
	@Trigger int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT dbo.vfin_StandingOrders.*
FROM     dbo.vfin_CustomerCreditTypes INNER JOIN
                  dbo.vfin_Customers ON dbo.vfin_CustomerCreditTypes.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                  dbo.vfin_CustomerAccounts ON dbo.vfin_Customers.Id = dbo.vfin_CustomerAccounts.CustomerId INNER JOIN
                  dbo.vfin_StandingOrders ON dbo.vfin_CustomerAccounts.Id = dbo.vfin_StandingOrders.BeneficiaryCustomerAccountId
WHERE  (dbo.vfin_CustomerCreditTypes.CreditTypeId = @CreditTypeID) AND (dbo.vfin_StandingOrders.[Trigger] = @Trigger) AND 
                  (dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = @ProductID)

END




GO



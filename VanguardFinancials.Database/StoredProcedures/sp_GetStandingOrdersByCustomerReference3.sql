USE [VanguardFinancialsDB_IGS]
GO

/****** Object:  StoredProcedure [dbo].[sp_GetStandingOrdersByCustomerReference3]    Script Date: 7/20/2017 5:36:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Centrino
-- Create date: 20.07.2017
-- Description:	sp_GetStandingOrdersByCustomerReference3
-- =============================================
--sp_GetStandingOrdersByCustomerReference3 '00298648',2
CREATE PROCEDURE [dbo].[sp_GetStandingOrdersByCustomerReference3] 
	-- Add the parameters for the stored procedure here
	@pReference3 varchar(100) = '',
	@Trigger int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT       dbo.vfin_StandingOrders.*
	FROM            dbo.vfin_StandingOrders INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_StandingOrders.BeneficiaryCustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id 
	WHERE CONTAINS(dbo.vfin_Customers.Reference3, @pReference3) and dbo.vfin_StandingOrders.[Trigger]=@Trigger

END




GO



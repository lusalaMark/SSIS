IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_FailedStandingOrders') BEGIN
   EXEC('CREATE PROC [dbo].[sp_FailedStandingOrders] as')
END
GO

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
---sp_FailedStandingOrders '05/01/2015','05/17/2015'
alter PROCEDURE sp_FailedStandingOrders
	@StartDate DateTime,
	@EndDate DateTime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	SELECT        dbo.vfin_StandingOrderHistories.ExpectedPrincipal, dbo.vfin_StandingOrderHistories.ExpectedInterest, dbo.vfin_StandingOrderHistories.ActualPrincipal, dbo.vfin_StandingOrderHistories.ActualInterest, 
							 dbo.vfin_StandingOrderHistories.Charge_FixedAmount, dbo.vw_CustomerAccounts.Reference1, dbo.vw_CustomerAccounts.Reference2, dbo.vw_CustomerAccounts.Reference3, 
							 dbo.vw_CustomerAccounts.FullName, DATENAME(m, str(dbo.vfin_StandingOrderHistories.Month) + '/1/2011') as Month, Products_1.Description
	FROM            dbo.vfin_StandingOrderHistories INNER JOIN
							 dbo.vw_CustomerAccounts ON dbo.vfin_StandingOrderHistories.BeneficiaryCustomerAccountId = dbo.vw_CustomerAccounts.Id INNER JOIN
							 dbo.Products(0) AS Products_1 ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = Products_1.id
	WHERE         (dbo.vfin_StandingOrderHistories.ActualPrincipal = 0) and CreatedDate between @StartDate and @EndDate

END
GO

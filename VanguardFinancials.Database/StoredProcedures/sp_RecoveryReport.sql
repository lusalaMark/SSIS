IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_RecoveryReport') BEGIN
   EXEC('CREATE PROC [dbo].[sp_RecoveryReport] as')
END


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
alter PROCEDURE sp_RecoveryReport 
	-- Add the parameters for the stored procedure here
	@StartDate DateTime,
	@EndDate DateTime

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

    -- Insert statements for procedure here
	
	SELECT        dbo.vw_CustomerAccounts.Reference1, dbo.vw_CustomerAccounts.Reference2, dbo.vw_CustomerAccounts.Reference3, dbo.vw_CustomerAccounts.FullName, 
	CASE 
	when dbo.vfin_StandingOrderHistories.[Trigger]=0 then 'Payout'
	when dbo.vfin_StandingOrderHistories.[Trigger]=1 then 'Checkoff'
	when dbo.vfin_StandingOrderHistories.[Trigger]=2 then 'Scheduled'
	end as [Trigger], 
							 dbo.vfin_StandingOrderHistories.ExpectedPrincipal, dbo.vfin_StandingOrderHistories.ExpectedInterest, dbo.vfin_StandingOrderHistories.ActualPrincipal, dbo.vfin_StandingOrderHistories.ActualInterest, 
							 (dbo.vfin_StandingOrderHistories.ExpectedPrincipal+dbo.vfin_StandingOrderHistories.ExpectedInterest)-(dbo.vfin_StandingOrderHistories.ActualPrincipal+ dbo.vfin_StandingOrderHistories.ActualInterest) as Arrears,
							 Products_1.Description
	FROM            dbo.vfin_StandingOrderHistories INNER JOIN
							 dbo.vw_CustomerAccounts ON dbo.vfin_StandingOrderHistories.BeneficiaryCustomerAccountId = dbo.vw_CustomerAccounts.Id INNER JOIN
							 dbo.Products(0) AS Products_1 ON dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId = Products_1.id
	WHERE        (dbo.vfin_StandingOrderHistories.CreatedDate Between @StartDate and @EndDate )
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_CashWithdrawalAuthorization') BEGIN
   EXEC('CREATE PROC [dbo].[sp_CashWithdrawalAuthorization] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_CashWithdrawalAuthorization]    Script Date: 9/13/2014 3:38:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 20.06.2014
-- Description:	CashWithdrawalAuthorizations
-- =============================================
---sp_CashWithdrawalAuthorization '06/19/2014','06/20/2014'
ALTER PROCEDURE [dbo].[sp_CashWithdrawalAuthorization] 
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
	SELECT        TOP (100) PERCENT  dbo.vw_CustomerAccounts.FullAccount, dbo.vw_CustomerAccounts.FullName, 
							 dbo.vfin_CashWithdrawalRequests.Amount, 
							 CASE  dbo.vfin_CashWithdrawalRequests.Status
							 WHEN 1 THEN 'Pending'
							 WHEN 2 THEN 'Authorized'
							 WHEN 4 THEN 'Rejected'
							 WHEN 8 THEN 'Paid'
							 END as Status, dbo.vfin_CashWithdrawalRequests.AuthorizedBy, 
							 dbo.vfin_CashWithdrawalRequests.AuthorizationRemarks, dbo.vfin_CashWithdrawalRequests.AuthorizedDate, dbo.vfin_CashWithdrawalRequests.PaidBy, 
							 dbo.vfin_CashWithdrawalRequests.PaidDate, dbo.vfin_CashWithdrawalRequests.CreatedBy, dbo.vfin_CashWithdrawalRequests.CreatedDate, 
							 dbo.vfin_CashWithdrawalRequests.Remarks, dbo.vfin_CashWithdrawalRequests.MaturityDate, dbo.vw_CustomerAccounts.Reference1
	FROM            dbo.vfin_CashWithdrawalRequests INNER JOIN
							 dbo.vw_CustomerAccounts ON dbo.vfin_CashWithdrawalRequests.CustomerAccountId = dbo.vw_CustomerAccounts.Id
	WHERE vfin_CashWithdrawalRequests.CreatedDate BETWEEN @StartDate and @EndDate
	ORDER BY dbo.vfin_CashWithdrawalRequests.CreatedDate
END


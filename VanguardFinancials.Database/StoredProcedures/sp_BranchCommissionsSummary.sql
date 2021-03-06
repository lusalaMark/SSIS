USE [VanguardFinancialsDB_KWETU]
GO
/****** Object:  StoredProcedure [dbo].[sp_BranchCommissionsSummary]    Script Date: 28-May-15 2:24:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec sp_BranchCommissionsSummary '1', '03/24/2015','06/29/2015'
ALTER PROCEDURE [dbo].[sp_BranchCommissionsSummary]
	-- Add the parameters for the stored procedure here
	@BranchCode varchar (50),
	@StartDate Date,
	@EndDate Date
AS
BEGIN
		set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT        TOP (100) PERCENT dbo.vfin_Branches.Description, dbo.vfin_ChartOfAccounts.AccountName, SUM(dbo.vfin_JournalEntries.Amount) AS Amount 
FROM            dbo.vfin_Branches INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_Branches.Id = dbo.vfin_Journals.BranchId INNER JOIN
                         dbo.vfin_JournalEntries ON dbo.vfin_Journals.Id = dbo.vfin_JournalEntries.JournalId INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id
WHERE        (dbo.vfin_ChartOfAccounts.AccountType = '4000000') and dbo.vfin_Branches.Code=@BranchCode and dbo.vfin_Journals.ValueDate between @StartDate and @EndDate
GROUP BY dbo.vfin_Branches.Description, dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_Branches.Code
ORDER BY dbo.vfin_Branches.Code

END

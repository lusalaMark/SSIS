USE [VanguardFinancialsDB_GDS]
GO
/****** Object:  StoredProcedure [dbo].[sp_LoanRecoverySummary]    Script Date: 02-Sep-15 12:04:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
---sp_LoanRecoverySummary '04/01/2015','09/01/2015'

ALTER PROCEDURE [dbo].[sp_LoanRecoverySummary]
	@StartDate datetime,
	@EndDate Datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT        TOP (100) PERCENT dbo.vfin_Journals.PrimaryDescription, dbo.vfin_Journals.SecondaryDescription, SUM(dbo.vfin_JournalEntries.Amount) AS Amount, dbo.vfin_Journals.ModuleNavigationItemCode, 
                         dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_Journals.TransactionCode
FROM            dbo.vfin_Journals INNER JOIN
                         dbo.vfin_JournalEntries ON dbo.vfin_Journals.Id = dbo.vfin_JournalEntries.JournalId INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id INNER JOIN
                         dbo.vfin_LoanProducts ON dbo.vfin_ChartOfAccounts.Id = dbo.vfin_LoanProducts.ChartOfAccountId
WHERE        (dbo.vfin_Journals.TransactionCode = '8192') and  dbo.vfin_Journals.CreatedDate BETWEEN @StartDate and @EndDate
GROUP BY dbo.vfin_Journals.PrimaryDescription, dbo.vfin_Journals.SecondaryDescription, dbo.vfin_Journals.ModuleNavigationItemCode, dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, 
                         dbo.vfin_Journals.TransactionCode
HAVING        (SUM(dbo.vfin_JournalEntries.Amount) > 0)  order by  dbo.vfin_ChartOfAccounts.AccountCode

END


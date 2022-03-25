IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_TrialBalance') BEGIN
   EXEC('CREATE PROC [dbo].[sp_TrialBalance] as')
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_TrialBalance] 
(
	@StartDate DateTime,
	@EndDate DateTime,
	@PostingPeriod varchar(100),
	@pBranch varchar(MAX)
)
AS

	SELECT        CASE [AccountType] WHEN 1000000 THEN 'Assets' WHEN 2000000 THEN 'Liabilities' WHEN 3000000 THEN 'Equity' WHEN 4000000 THEN 'Income' WHEN 5000000
                          THEN 'Expenses' END AS AccountTypeCode, 
                         CASE [AccountType] WHEN 1000000 THEN 'C' WHEN 2000000 THEN 'D' WHEN 3000000 THEN 'E' WHEN 4000000 THEN 'A' WHEN 5000000 THEN 'B' END AS SortOrder,
                         dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, 
                         ISNULL(CASE WHEN SUM(dbo.vfin_JournalEntries.Amount) > 0 THEN SUM(dbo.vfin_JournalEntries.Amount) ELSE 0 END, 0) AS Credit, 
                         ISNULL(CASE WHEN SUM(dbo.vfin_JournalEntries.Amount) < 0 THEN SUM(dbo.vfin_JournalEntries.Amount) * - 1 ELSE 0 END, 0) AS Debit, 
                         dbo.vfin_ChartOfAccounts.AccountType, 
                          dbo.vfin_PostingPeriods.Description AS PostingPeriod
     FROM            dbo.vfin_JournalEntries INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_Journals.BranchId = dbo.vfin_Branches.Id INNER JOIN
                         dbo.vfin_CostCenters ON dbo.vfin_ChartOfAccounts.CostCenterId = dbo.vfin_CostCenters.Id INNER JOIN
                         dbo.vfin_PostingPeriods ON dbo.vfin_Journals.PostingPeriodId = dbo.vfin_PostingPeriods.Id
 WHERE dbo.vfin_PostingPeriods.Id=@PostingPeriod AND dbo.vfin_JournalEntries.CreatedDate 
						BETWEEN @StartDate AND @EndDate
						AND vfin_Branches.Description IN (@pBranch)
GROUP BY dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_ChartOfAccounts.AccountType,
                        dbo.vfin_PostingPeriods.Id, dbo.vfin_PostingPeriods.Description
HAVING        (SUM(dbo.vfin_JournalEntries.Amount) <> 0)

GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_ConsolidatedTrialBalance') BEGIN
   EXEC('CREATE PROC [dbo].[sp_ConsolidatedTrialBalance] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ConsolidatedTrialBalance]    Script Date: 9/13/2014 3:48:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 14.06.2014
-- Description:	ConsolidatedTrialBalance
-- =============================================
ALTER PROCEDURE [dbo].[sp_ConsolidatedTrialBalance] 
	-- Add the parameters for the stored procedure here
	@EndDate DateTime 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

SELECT        TOP (100) 
                         PERCENT CASE [AccountType] WHEN 1000000 THEN 'Assets' WHEN 2000000 THEN 'Liabilities' WHEN 3000000 THEN 'Equity' WHEN 4000000 THEN 'Income' WHEN
                          5000000 THEN 'Expenses' END AS AccountTypeCode, 
                         CASE [AccountType] WHEN 1000000 THEN 'C' WHEN 2000000 THEN 'D' WHEN 3000000 THEN 'E' WHEN 4000000 THEN 'A' WHEN 5000000 THEN 'B' END AS SortOrder,
                          dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, ISNULL(CASE WHEN SUM(dbo.vfin_JournalEntries.Amount) 
                         > 0 THEN SUM(dbo.vfin_JournalEntries.Amount) ELSE 0 END, 0) AS Credit, ISNULL(CASE WHEN SUM(dbo.vfin_JournalEntries.Amount) 
                         < 0 THEN SUM(dbo.vfin_JournalEntries.Amount) * - 1 ELSE 0 END, 0) AS Debit, dbo.vfin_ChartOfAccounts.AccountType
FROM            dbo.vfin_JournalEntries INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_Journals.BranchId = dbo.vfin_Branches.Id
WHERE        (dbo.vfin_Journals.valuedate <= @EndDate)
GROUP BY dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_ChartOfAccounts.AccountType
HAVING        (SUM(dbo.vfin_JournalEntries.Amount) <> 0)
ORDER BY SortOrder, dbo.vfin_ChartOfAccounts.AccountCode
END


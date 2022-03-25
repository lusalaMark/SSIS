IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='f_MonthlyBudget') BEGIN
   EXEC('CREATE function [dbo].[f_MonthlyBudget] as')
END
GO

/****** Object:  UserDefinedFunction [dbo].[f_MonthlyBudget]    Script Date: 9/14/2014 7:08:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--select * from vfin_postingperiods

--select * from dbo.f_MonthlyBudget('01/30/2015','2F015C30-7201-C686-7872-08D1AD41F57B')
ALTER function [dbo].[f_MonthlyBudget] 
(	
	@EndDate DateTime,
	@PostingPeriod varchar(MAX)
)
RETURNS TABLE 
AS 
RETURN 
(
SELECT        dbo.vfin_ChartOfAccounts.Id, dbo.vfin_ChartOfAccounts.AccountType, dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, 
                         dbo.vfin_BudgetEntries.Amount as TotalBudget, dbo.vfin_BudgetEntries.Amount / 12 AS MonthlyBudget,(dbo.vfin_BudgetEntries.Amount / 12 )*Month(@EndDate) as BudgetTodate,
                         CASE [AccountType] WHEN 1000000 THEN 'Assets' WHEN 2000000 THEN 'Liabilities' WHEN 3000000 THEN 'Equity' WHEN 4000000 THEN 'Income' WHEN 5000000
                          THEN 'Expenses' END AS [AccountTypeCode], dbo.vfin_PostingPeriods.Description AS PostingPeriod, SUM(dbo.vfin_JournalEntries.Amount) AS ActualAmount,
						  CASE [AccountType]  WHEN 4000000 then (dbo.vfin_BudgetEntries.Amount / 12 )*Month(@EndDate)-SUM(dbo.vfin_JournalEntries.Amount)   WHEN 5000000
                          THEN SUM(dbo.vfin_JournalEntries.Amount)+(dbo.vfin_BudgetEntries.Amount / 12 )*Month(@EndDate)  END as Variance
FROM            dbo.vfin_Journals INNER JOIN
                         dbo.vfin_Budgets INNER JOIN
                         dbo.vfin_BudgetEntries ON dbo.vfin_Budgets.Id = dbo.vfin_BudgetEntries.BudgetId INNER JOIN
                         dbo.vfin_PostingPeriods ON dbo.vfin_Budgets.PostingPeriodId = dbo.vfin_PostingPeriods.Id ON 
                         dbo.vfin_Journals.PostingPeriodId = dbo.vfin_PostingPeriods.Id INNER JOIN
                         dbo.vfin_JournalEntries ON dbo.vfin_Journals.Id = dbo.vfin_JournalEntries.JournalId RIGHT OUTER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id AND 
                         dbo.vfin_BudgetEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id
WHERE        (dbo.vfin_Budgets.PostingPeriodId IN (@PostingPeriod) and dbo.vfin_Journals.ValueDate<=@EndDate) AND (dbo.vfin_ChartOfAccounts.AccountType IN (4000000, 5000000))
group by  dbo.vfin_ChartOfAccounts.Id, dbo.vfin_ChartOfAccounts.AccountType, dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName,
 dbo.vfin_BudgetEntries.Amount,dbo.vfin_PostingPeriods.Description

)



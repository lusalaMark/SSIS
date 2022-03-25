IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_IncomeStatementwithBudget') BEGIN
   EXEC('CREATE PROC [dbo].[sp_IncomeStatementwithBudget] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_IncomeStatementwithBudget]    Script Date: 9/13/2014 8:52:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---select * from vfin_PostingPeriods
---sp_IncomeStatementwithBudget '04/30/2014','28C1F651-CFFE-C466-553E-08D0FC697DC8'
ALTER PROCEDURE [dbo].[sp_IncomeStatementwithBudget] 
(
	@EndDate DateTime,
	@PostingPeriod varchar(100)
)
as
Declare
	@StartDate as Datetime=DATEADD(yy, DATEDIFF(yy,0,@EndDate), 0)
SELECT        dbo.vfin_ChartOfAccounts.AccountType, dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, 
                         dbo.vfin_BudgetEntries.Amount AS TotalBudget, dbo.vfin_PostingPeriods.Description AS PostingPeriod
FROM            dbo.vfin_ChartOfAccounts LEFT OUTER JOIN
                         dbo.vfin_Budgets INNER JOIN
                         dbo.vfin_BudgetEntries ON dbo.vfin_Budgets.Id = dbo.vfin_BudgetEntries.BudgetId INNER JOIN
                         dbo.vfin_PostingPeriods ON dbo.vfin_Budgets.PostingPeriodId = dbo.vfin_PostingPeriods.Id ON 
                         dbo.vfin_ChartOfAccounts.Id = dbo.vfin_BudgetEntries.ChartOfAccountId
WHERE  dbo.vfin_Budgets.PostingPeriodId in (@PostingPeriod)
AND dbo.vfin_ChartOfAccounts.AccountType IN (4000000,5000000)







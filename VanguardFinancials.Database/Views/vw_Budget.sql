IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_Budget') BEGIN
   EXEC('CREATE view [dbo].[vw_Budget] as  select top 1 * from vfin_customers')
END
GO

/*................................................................*/
GO

/****** Object:  View [dbo].[vw_Budget]    Script Date: 9/14/2014 6:05:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter view [dbo].[vw_Budget]
AS
SELECT        dbo.vfin_PostingPeriods.Description AS PostingPeriod, dbo.vfin_Budgets.TotalValue, dbo.vfin_Budgets.Description AS BudgetDescription, 
                         dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_BudgetEntries.Amount, dbo.vfin_BudgetEntries.CreatedDate, 
                         dbo.vfin_PostingPeriods.ClosedBy, dbo.vfin_PostingPeriods.ClosedDate, dbo.vfin_Budgets.PostingPeriodId, dbo.vfin_BudgetEntries.ChartOfAccountId
FROM            dbo.vfin_BudgetEntries INNER JOIN
                         dbo.vfin_Budgets ON dbo.vfin_BudgetEntries.BudgetId = dbo.vfin_Budgets.Id INNER JOIN
                         dbo.vfin_PostingPeriods ON dbo.vfin_Budgets.PostingPeriodId = dbo.vfin_PostingPeriods.Id INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_BudgetEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id




GO




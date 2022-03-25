IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_BudgetReport') BEGIN
   EXEC('CREATE PROC [dbo].[sp_BudgetReport] as')
END
GO


ALTER Procedure [dbo].[sp_BudgetReport] 
(
	@EndDate DateTime,
	@PostingPeriod varchar(MAX) ---,
---	@BranchID Varchar(Max)
)
as
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

	Declare 	@LocalEndDate DateTime=@EndDate,
				@LocalPostingPeriod varchar(MAX)=@PostingPeriod,
				@LocalStartDate DateTime
---				@LocalBranchID varchar(Max)=@BranchID;
				set @LocalStartDate=(select top 1 Duration_StartDate from vfin_PostingPeriods where id=@LocalPostingPeriod);
WITH Budgetcte(AccountType,AccountCode,AccountName,TotalBudget,MonthlyBudget,BudgetTodate,AccountTypeCode,ActualAmount)
as
(
SELECT        TOP (100) PERCENT dbo.vfin_ChartOfAccounts.AccountType, dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, SUM(dbo.vfin_BudgetEntries.Amount) AS TotalBudget, 
                         SUM(dbo.vfin_BudgetEntries.Amount) / 12 AS MonthlyBudget, SUM(dbo.vfin_BudgetEntries.Amount) / 12 * MONTH(@LocalEndDate) AS BudgetTodate, 
                         CASE [AccountType] WHEN 1000000 THEN 'Assets' WHEN 2000000 THEN 'Liabilities' WHEN 3000000 THEN 'Equity' WHEN 4000000 THEN 'Income' WHEN 5000000 THEN 'Expenses' END AS AccountTypeCode,
						 isnull((SELECT        sum(dbo.vfin_JournalEntries.Amount)
							FROM            dbo.vfin_Journals INNER JOIN
							 dbo.vfin_JournalEntries ON dbo.vfin_Journals.Id = dbo.vfin_JournalEntries.JournalId 
							 where dbo.vfin_JournalEntries.ChartOfAccountId=dbo.vfin_BudgetEntries.ChartOfAccountId
							---and dbo.vfin_Journals.PostingPeriodId=@LocalPostingPeriod ---- and dbo.vfin_Journals.BranchId=@LocalBranchID
							and  dbo.vfin_Journals.ValueDate<= @LocalEndDate							
						 ),0) as ActualAmount
	
FROM            dbo.vfin_Budgets INNER JOIN
                         dbo.vfin_BudgetEntries ON dbo.vfin_Budgets.Id = dbo.vfin_BudgetEntries.BudgetId INNER JOIN
                         dbo.vfin_PostingPeriods ON dbo.vfin_Budgets.PostingPeriodId = dbo.vfin_PostingPeriods.Id INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_BudgetEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id
WHERE        (dbo.vfin_PostingPeriods.Id = @LocalPostingPeriod)
GROUP BY dbo.vfin_ChartOfAccounts.AccountType,dbo.vfin_BudgetEntries.ChartOfAccountId, dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName
)
select * into #temp1 from Budgetcte 

insert into #temp1 (AccountType,AccountCode,AccountName,TotalBudget,MonthlyBudget,BudgetTodate,AccountTypeCode,ActualAmount)
select AccountType,AccountCode,AccountName,0 as TotalBudget,0 as MonthlyBudget,0 as BudgetTodate, 
CASE [AccountType] WHEN 1000000 THEN 'Assets' WHEN 2000000 THEN 'Liabilities' WHEN 3000000 THEN 'Equity' WHEN 4000000 THEN 'Income' WHEN 5000000 THEN 'Expenses' END AS AccountTypeCode,
							isnull((SELECT sum(dbo.vfin_JournalEntries.Amount)
							FROM            dbo.vfin_Journals INNER JOIN
							 dbo.vfin_JournalEntries ON dbo.vfin_Journals.Id = dbo.vfin_JournalEntries.JournalId 
							 where dbo.vfin_JournalEntries.ChartOfAccountId=dbo.vfin_ChartOfAccounts.Id
							----and dbo.vfin_Journals.PostingPeriodId=@LocalPostingPeriod --and dbo.vfin_Journals.BranchId=@LocalBranchID
							and  dbo.vfin_Journals.ValueDate <= @LocalEndDate							
						 ),0) as ActualAmount 
from vfin_ChartOfAccounts where id not in (
SELECT        dbo.vfin_BudgetEntries.ChartOfAccountId
FROM            dbo.vfin_Budgets INNER JOIN
                         dbo.vfin_BudgetEntries ON dbo.vfin_Budgets.Id = dbo.vfin_BudgetEntries.BudgetId where PostingPeriodId=@LocalPostingPeriod
) and AccountType in (4000000,5000000)
select *,BudgetTodate-ActualAmount as Variance  into #temp2 from #temp1 
select * from #temp2 where TotalBudget+MonthlyBudget+BudgetTodate+ActualAmount<>0  order by AccountCode
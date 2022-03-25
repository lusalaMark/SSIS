IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_IncomeStatementWithBudgetSummaries') BEGIN
   EXEC('CREATE PROC [dbo].[sp_IncomeStatementWithBudgetSummaries] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_IncomeStatementWithBudgetSummaries]    Script Date: 9/13/2014 8:54:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

---select * from vfin_PostingPeriods

---sp_IncomeStatementWithBudgetSummaries '28C1F651-CFFE-C466-553E-08D0FC697DC8','04/30/2014'
ALTER PROCEDURE [dbo].[sp_IncomeStatementWithBudgetSummaries] 
	-- Add the parameters for the stored procedure here
	@PostingPeriod VARCHAR(MAX),
	@EndDate as Datetime
AS
DECLARE
	@StartDate as Datetime=DATEADD(yy, DATEDIFF(yy,0,@EndDate), 0)
set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

	SELECT        dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_ChartOfAccounts.AccountType, 
		isnull((
			SELECT        SUM(dbo.vfin_JournalEntries.Amount) 
			FROM            dbo.vfin_Journals INNER JOIN
									 dbo.vfin_JournalEntries ON dbo.vfin_Journals.Id = dbo.vfin_JournalEntries.JournalId
			where dbo.vfin_JournalEntries.ChartOfAccountId= dbo.vfin_ChartOfAccounts.ID 
			AND PostingPeriodId=@PostingPeriod						
			AND dbo.vfin_JournalEntries.CreatedDate BETWEEN @StartDate AND @EndDate
		),0) as ActualToDate,
		isnull(f_MonthlyBudget_1.TotalBudget,0) as TotalBudget, isnull(f_MonthlyBudget_1.MonthlyBudget,0) as MonthlyBudget, isnull(f_MonthlyBudget_1.MonthlyBudget,0)*month(@Enddate) as BudgetToDate
	INTO #TempTable
	FROM            dbo.vfin_ChartOfAccounts left JOIN
					dbo.f_MonthlyBudget(@PostingPeriod) AS f_MonthlyBudget_1 ON dbo.vfin_ChartOfAccounts.Id = f_MonthlyBudget_1.ID
	WHERE dbo.vfin_ChartOfAccounts.AccountType in (4000000,5000000)

	SELECT AccountCode,AccountName,AccountType,
	CASE  AccountType 
	WHEN 4000000 THEN ActualToDate
	WHEN 5000000 THEN ActualToDate *-1
	END as ActualToDate
	,TotalBudget,MonthlyBudget,BudgetToDate,
	BudgetToDate-(
	CASE  AccountType 
	WHEN 4000000 THEN ActualToDate
	WHEN 5000000 THEN ActualToDate *-1
	END) as BudgetBalance into #tempTable2 from #TempTable  
insert into #tempTable2 (AccountCode,AccountName,AccountType,ActualToDate,TotalBudget,MonthlyBudget,BudgetToDate,BudgetBalance)
select 6000000,'Net',6000000,
(select sum(ActualToDate) from #tempTable2 where AccountType='4000000')-(select sum(ActualToDate) from #tempTable2 where AccountType='5000000') ActualToDate,
(select sum(TotalBudget) from #tempTable2 where AccountType='4000000')-(select sum(TotalBudget) from #tempTable2 where AccountType='5000000') TotalBudget,
(select sum(MonthlyBudget) from #TempTable2 where AccountType='4000000')-(select sum(MonthlyBudget) from #tempTable2 where AccountType='5000000') MonthlyBudget,
(select sum(BudgetToDate) from #TempTable2 where AccountType='4000000')-(select sum(BudgetToDate) from #tempTable2 where AccountType='5000000') BudgetToDate,
(select sum(BudgetBalance) from #TempTable2 where AccountType='4000000')-(select sum(BudgetBalance) from #tempTable2 where AccountType='5000000') BudgetBalance
 select *,			CASE [AccountType]
				WHEN 6000000 THEN 'Net'
				WHEN 4000000 THEN 'Income'
				WHEN 5000000 THEN 'Expenses'
			END AccountTypeDesc
 from #tempTable2 where ActualToDate+TotalBudget+MonthlyBudget+BudgetToDate<>0

END





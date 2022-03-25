IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_IncomeStatement') BEGIN
   EXEC('CREATE PROC [dbo].[sp_IncomeStatement] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_IncomeStatement]    Script Date: 9/13/2014 8:50:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---select DATEADD(yy,-1,getdate())
--SELECT * FROM vfin_PostingPeriods
----[IncomeStatement] '01/01/2014','04/30/2014','28C1F651-CFFE-C466-553E-08D0FC697DC8','994C97A8-F41E-C404-F153-08D0FC664E26,C0EE0C7F-D43B-C6B9-2928-08D110065E53','42B501FD-7955-C621-D498-08D10727EE06,8FD01125-34DE-C30F-B592-08D10727F55A'
--select * from vfin_CostCenters
---select * from vfin_Branches
ALTER PROCEDURE [dbo].[sp_IncomeStatement] 
(
	@EndDate DateTime,
	@PostingPeriod varchar(100),
	@Branch varchar(MAX),
	@CostCenter varchar(MAX)
)
AS
Declare 
	@StartDate as Datetime=DATEADD(yy, DATEDIFF(yy,0,@EndDate), 0)

set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

SELECT        CASE [AccountType] WHEN 1000000 THEN 'Assets' WHEN 2000000 THEN 'Liabilities' WHEN 3000000 THEN 'Equity' WHEN 4000000 THEN 'Income' WHEN 5000000
                          THEN 'Expenses' END AS AccountTypeCode, 
                         CASE [AccountType] WHEN 1000000 THEN 'C' WHEN 2000000 THEN 'D' WHEN 3000000 THEN 'E' WHEN 4000000 THEN 'A' WHEN 5000000 THEN 'B' END AS SortOrder,
                          dbo.vfin_Branches.Code, dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, 
                         SUM(dbo.vfin_JournalEntries.Amount) AS Balance, 
                        isnull((select sum(amount) from dbo.vfin_JournalEntries where CreatedDate BETWEEN DATEADD(yy,-1,@StartDate) AND DATEADD(yy,-1,@EndDate) and ChartOfAccountId=dbo.vfin_ChartOfAccounts.Id),0) as PreviousYearSamePeriod,
						 dbo.vfin_ChartOfAccounts.AccountType, dbo.vfin_Branches.Description AS Branch, dbo.vfin_CostCenters.Description AS CostCenter, 
                          dbo.vfin_PostingPeriods.Description AS PostingPeriod
INTO #temp
FROM            dbo.vfin_JournalEntries INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_Journals.BranchId = dbo.vfin_Branches.Id INNER JOIN
                         dbo.vfin_CostCenters ON dbo.vfin_ChartOfAccounts.CostCenterId = dbo.vfin_CostCenters.Id INNER JOIN
                         dbo.vfin_PostingPeriods ON dbo.vfin_Journals.PostingPeriodId = dbo.vfin_PostingPeriods.Id
WHERE dbo.vfin_JournalEntries.CreatedDate BETWEEN @StartDate AND @EndDate 
and dbo.vfin_PostingPeriods.Id=@PostingPeriod 
AND dbo.vfin_ChartOfAccounts.AccountType IN (4000000,5000000)
AND dbo.vfin_Branches.id in (@Branch)
AND dbo.vfin_CostCenters.Id in (@CostCenter)
GROUP BY dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_ChartOfAccounts.AccountType, dbo.vfin_Branches.Description, 
                         dbo.vfin_Branches.Code, dbo.vfin_CostCenters.Description, dbo.vfin_PostingPeriods.Id, dbo.vfin_PostingPeriods.Description,dbo.vfin_ChartOfAccounts.Id
---HAVING        (SUM(dbo.vfin_JournalEntries.Amount) <> 0)

insert into #temp (AccountTypeCode,AccountType,SortOrder,AccountCode,AccountName,Balance,PreviousYearSamePeriod,code)
select 'NetIncome','6000000','C','6000000','Net Income',(select sum(balance) from #temp),isnull((select sum(PreviousYearSamePeriod) from #temp),0),99

select * from #temp where isnull(PreviousYearSamePeriod,0)+isnull(balance,0)<>0 order by AccountCode





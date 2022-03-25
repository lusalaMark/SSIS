IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_IncomeExpenditureByBranch') BEGIN
   EXEC('CREATE PROC [dbo].[sp_IncomeExpenditureByBranch] as')
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 14.06.2014
-- Description:	ConsolidatedTrialBalance
-- =============================================
---SELECT * FROM vfin_PostingPeriods
---SELECT * FROM vfin_Branches
---[sp_IncomeExpenditureByBranch] '10/01/2014','10/03/2014','2F015C30-7201-C686-7872-08D1AD41F57B','8B8B1B74-141C-CF68-05C2-08D19D7D7330'
ALTER PROCEDURE [dbo].[sp_IncomeExpenditureByBranch] 
	-- Add the parameters for the stored procedure here
	@StartDate DateTime , 
	@EndDate DateTime,
	@PostingPeriod varchar(100),
	@BranchID varchar(100), 
	@CostCenterId varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

with CTEIncomeExpenditure (AccountTypeCode,SortOrder,AccountCode,AccountName,Credit,Debit,AccountType,PostingPeriod)
as
(
SELECT        CASE [AccountType] WHEN 1000000 THEN 'Assets' WHEN 2000000 THEN 'Liabilities' WHEN 3000000 THEN 'Equity' WHEN 4000000 THEN 'Income' WHEN 5000000
                          THEN 'Expenses' END AS AccountTypeCode, 
                         CASE [AccountType] WHEN 1000000 THEN 'C' WHEN 2000000 THEN 'D' WHEN 3000000 THEN 'E' WHEN 4000000 THEN 'A' WHEN 5000000 THEN 'B' END AS SortOrder,
                          dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, ISNULL(CASE WHEN SUM(dbo.vfin_JournalEntries.Amount) 
                         > 0 THEN SUM(dbo.vfin_JournalEntries.Amount) ELSE 0 END, 0) AS Credit, ISNULL(CASE WHEN SUM(dbo.vfin_JournalEntries.Amount) 
                         < 0 THEN SUM(dbo.vfin_JournalEntries.Amount) * - 1 ELSE 0 END, 0) AS Debit, dbo.vfin_ChartOfAccounts.AccountType, 
                         dbo.vfin_PostingPeriods.Description AS PostingPeriod
FROM            dbo.vfin_JournalEntries INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_Journals.BranchId = dbo.vfin_Branches.Id LEFT OUTER JOIN
                         dbo.vfin_PostingPeriods ON dbo.vfin_Journals.PostingPeriodId = dbo.vfin_PostingPeriods.Id
WHERE dbo.vfin_JournalEntries.CreatedDate 
BETWEEN @StartDate AND @EndDate 
AND dbo.vfin_PostingPeriods.Id=@PostingPeriod 
AND AccountType in (5000000,4000000) 
AND BranchId=@BranchID
AND CostCenterId=@CostCenterId 
	
GROUP BY dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_ChartOfAccounts.AccountType, dbo.vfin_PostingPeriods.Id, 
                         dbo.vfin_PostingPeriods.Description
HAVING        (SUM(dbo.vfin_JournalEntries.Amount) <> 0) 
),
cte (AccountTypeCode,SortOrder,AccountCode,AccountName,Credit,Debit,AccountType,PostingPeriod)
as
(
select AccountTypeCode,SortOrder,AccountCode,AccountName,Credit,Debit,AccountType,PostingPeriod from CTEIncomeExpenditure
UNION ALL
select TOP 1 '5000000','B',(SELECT AccountCode FROM vfin_ChartOfAccounts WHERE ID IN (SELECT ChartOfAccountId FROM vfin_SystemGeneralLedgerAccountMappings WHERE SystemGeneralLedgerAccountCode='48831')),(SELECT AccountName FROM vfin_ChartOfAccounts WHERE ID IN (SELECT ChartOfAccountId FROM vfin_SystemGeneralLedgerAccountMappings WHERE SystemGeneralLedgerAccountCode='48831')),
CASE 
WHEN (select SUM(DEBIT-CREDIT) from CTEIncomeExpenditure)>=0 THEN (select SUM(DEBIT-CREDIT) from CTEIncomeExpenditure)
ELSE 0 END,
CASE 
WHEN (select SUM(DEBIT-CREDIT) from CTEIncomeExpenditure)<0 THEN (select SUM(DEBIT-CREDIT) from CTEIncomeExpenditure)*-1
ELSE 0 END
,(SELECT AccountType FROM vfin_ChartOfAccounts WHERE ID IN (SELECT ChartOfAccountId FROM vfin_SystemGeneralLedgerAccountMappings WHERE SystemGeneralLedgerAccountCode='48831')),PostingPeriod from CTEIncomeExpenditure

)
select * FROM cte
order by AccountType ,AccountCode
END





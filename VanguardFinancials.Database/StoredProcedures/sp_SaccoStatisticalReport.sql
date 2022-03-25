IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_SaccoStatisticalReport') BEGIN
   EXEC('CREATE PROC [dbo].[sp_SaccoStatisticalReport] as')
END
GO

ALTER PROCEDURE [dbo].[sp_SaccoStatisticalReport]
	(
		@StartDate Datetime,
		@EndDate Datetime
	)
AS
BEGIN

SET NOCOUNT ON;

CREATE TABLE #Dashboard
(
[Description] VARCHAR(50),
Value	decimal(18,2)
)

/**SACCO Members*/
INSERT INTO #Dashboard
SELECT 'SACCO Members',COUNT(*) FROM dbo.vfin_Customers WHERE CAST(CreatedDate as DATE) BETWEEN @StartDate and @EndDate

/**Closed Accounts*/
INSERT INTO #Dashboard
SELECT 'Closed Accounts', count(*) from vfin_CustomerAccountS where Status = 3 and CAST(CreatedDate as DATE) BETWEEN @StartDate and @EndDate

/**Active Male Members*/
INSERT INTO #Dashboard
SELECT 'Active Male Members',COUNT(*) FROM dbo.vfin_Customers WHERE Individual_Gender = '57008' AND CAST(CreatedDate as DATE) BETWEEN @StartDate and @EndDate

/**Active Female Members*/
INSERT INTO #Dashboard
SELECT 'Active Female Members',COUNT(*) FROM dbo.vfin_Customers WHERE Individual_Gender = '57009' And CAST(CreatedDate as DATE) BETWEEN @StartDate and @EndDate

/**Unclassified Members*/
INSERT INTO #Dashboard
SELECT 'Unclassified Members',COUNT(*) FROM dbo.vfin_Customers WHERE Individual_Gender NOT IN ('57009', '57008') And CAST(CreatedDate as DATE) BETWEEN @StartDate and @EndDate

/**Active Members*/
INSERT INTO #Dashboard
SELECT 'Active Members',COUNT(*) FROM dbo.vfin_Customers WHERE dbo.f_CustomerLastTransactionDate(id) >= DATEADD(MM,-3,GETDATE()) And CAST(CreatedDate as DATE) BETWEEN @StartDate and @EndDate

/**Dormant Members*/
INSERT INTO #Dashboard
SELECT 'Dormant Members',COUNT(*) FROM dbo.vfin_Customers WHERE dbo.f_CustomerLastTransactionDate(id) < DATEADD(MM,-3,GETDATE()) AND CAST(CreatedDate as DATE) BETWEEN @StartDate and @EndDate


/**Total Loan Balances*/
INSERT INTO #Dashboard
SELECT 'Total Loan Balances', SUM(ISNULL(dbo.vfin_JournalEntries.Amount, 0)) AS Balance 
FROM dbo.vfin_JournalEntries INNER JOIN
dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id 
inner join vfin_LoanProducts on vfin_LoanProducts.ChartOfAccountId = vfin_ChartOfAccounts.Id
WHERE CAST(dbo.vfin_JournalEntries.CreatedDate as DATE) BETWEEN @StartDate and @EndDate
--WHERE dbo.vfin_ChartOfAccounts.AccountCode like '10500%'


-- Blank line
--INSERT INTO #Dashboard
--Select '',''

/**All Investments*/
INSERT INTO #Dashboard
SELECT dbo.vfin_ChartOfAccounts.AccountName, SUM(ISNULL(dbo.vfin_JournalEntries.Amount, 0)) AS Balance 
FROM dbo.vfin_JournalEntries INNER JOIN
dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id 
inner join vfin_InvestmentProducts on vfin_InvestmentProducts.ChartOfAccountId = vfin_ChartOfAccounts.Id
--WHERE dbo.vfin_JournalEntries.ChartOfAccountId = '7BD83577-DB07-CAAD-50B7-08D10FCB3DEC' 
WHERE CAST(dbo.vfin_JournalEntries.CreatedDate as DATE) BETWEEN @StartDate and @EndDate                       
GROUP BY dbo.vfin_ChartOfAccounts.AccountName

-- Blank line
--INSERT INTO #Dashboard
--Select '',''

-- All Loan Products
INSERT INTO #Dashboard
SELECT dbo.vfin_ChartOfAccounts.AccountName, SUM(ISNULL(dbo.vfin_JournalEntries.Amount, 0)) AS Balance 
FROM dbo.vfin_JournalEntries INNER JOIN
dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id 
inner join vfin_LoanProducts on vfin_LoanProducts.ChartOfAccountId = vfin_ChartOfAccounts.Id
--WHERE dbo.vfin_JournalEntries.ChartOfAccountId = '7BD83577-DB07-CAAD-50B7-08D10FCB3DEC'   
WHERE CAST(dbo.vfin_JournalEntries.CreatedDate as DATE) BETWEEN @StartDate and @EndDate                     
GROUP BY dbo.vfin_ChartOfAccounts.AccountName

SELECT [Description], CASE WHEN [Value] < 0 THEN abs(Value)
ELSE VALUE END AS VALUE FROM #Dashboard

END


GO
--EXEC sp_SaccoStatisticalReport '01 dec 2014' ,'20 mar 2015'
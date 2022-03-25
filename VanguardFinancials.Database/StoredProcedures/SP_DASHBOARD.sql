IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SP_DASHBOARD') BEGIN
   EXEC('CREATE PROC [dbo].[SP_DASHBOARD] as')
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DASHBOARD]    Script Date: 9/13/2014 4:05:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_DASHBOARD]
AS

BEGIN

SET NOCOUNT ON;

CREATE TABLE #Dashboard
(
[Description] VARCHAR(50),
Value	VARCHAR(15)
)

/**SACCO Members*/
INSERT INTO #Dashboard
SELECT 'SACCO Members',COUNT(*) FROM dbo.vfin_Customers

/**Closed Accounts*/
INSERT INTO #Dashboard
SELECT 'Closed Accounts', '-' 

/**Active Male Members*/
INSERT INTO #Dashboard
SELECT 'Active Male Members',COUNT(*) FROM dbo.vfin_Customers WHERE Individual_Gender = '57008'

/**Active Female Members*/
INSERT INTO #Dashboard
SELECT 'Active Female Members',COUNT(*) FROM dbo.vfin_Customers WHERE Individual_Gender = '57009'

/**Unclassified Members*/
INSERT INTO #Dashboard
SELECT 'Unclassified Members',COUNT(*) FROM dbo.vfin_Customers WHERE Individual_Gender NOT IN ('57009', '57008')

/**Active Members*/
INSERT INTO #Dashboard
SELECT 'Active Members',COUNT(*) FROM dbo.vfin_Customers WHERE dbo.f_CustomerLastTransactionDate(id) >= DATEADD(MM,-3,GETDATE())

/**Dormant Members*/
INSERT INTO #Dashboard
SELECT 'Dormant Members',COUNT(*) FROM dbo.vfin_Customers WHERE dbo.f_CustomerLastTransactionDate(id) < DATEADD(MM,-3,GETDATE())

/**Share Capital*/
INSERT INTO #Dashboard
SELECT dbo.vfin_ChartOfAccounts.AccountName, SUM(ISNULL(dbo.vfin_JournalEntries.Amount, 0)) AS Balance 
FROM dbo.vfin_JournalEntries INNER JOIN dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id 
WHERE dbo.vfin_JournalEntries.ChartOfAccountId = '7BD83577-DB07-CAAD-50B7-08D10FCB3DEC'                        
GROUP BY dbo.vfin_ChartOfAccounts.AccountName

SELECT * FROM #Dashboard

END

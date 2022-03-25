IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_CustomerAccountsBalances') BEGIN
   EXEC('CREATE VIEW [dbo].[vw_CustomerAccountsBalances] as  select top 1 * from vfin_customers')
END
GO

/****** Object:  View [dbo].[vw_CustomerAccountsBalances]    Script Date: 9/14/2014 6:22:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[vw_CustomerAccountsBalances]
AS
SELECT        TOP (100) PERCENT REPLACE(STR(dbo.vfin_Branches.Code, 3), SPACE(1), '0') + '-' + REPLACE(STR(dbo.vfin_Customers.SerialNumber, 6), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_ProductCode, 3), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductCode, 3), SPACE(1), '0') AS FullAccount, 
                         CASE [Individual_Salutation] WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818' THEN 'Prof' WHEN '48819'
                          THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN 'Ms' ELSE 'UnKnown' END
                          + ' ' + dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName AS FullName, dbo.vfin_ChartOfAccounts.AccountCode, 
                         dbo.vfin_ChartOfAccounts.AccountName, Products_1.Description,
                             (SELECT        SUM(Amount) AS Expr1
                               FROM            dbo.vfin_JournalEntries
                               WHERE        (CustomerAccountId = dbo.vfin_CustomerAccounts.Id) AND (CONVERT(varchar(50), ChartOfAccountId) = Products_1.ChartOfAccountId)) 
                         AS AccountBalance,
                             (SELECT        SUM(Amount) AS Expr1
                               FROM            dbo.vfin_JournalEntries AS vfin_JournalEntries_1
                               WHERE        (CustomerAccountId = dbo.vfin_CustomerAccounts.Id) AND (CONVERT(varchar(50), ChartOfAccountId) = Products_1.InterestReceivable) AND 
                                                         (Products_1.InterestReceivable <> null)) AS InterestBalance
FROM            dbo.vfin_CustomerAccounts INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_CustomerAccounts.BranchId = dbo.vfin_Branches.Id INNER JOIN
                         dbo.Products(1) AS Products_1 ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = Products_1.id INNER JOIN
                         dbo.vfin_ChartOfAccounts ON Products_1.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id



GO



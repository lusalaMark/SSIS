IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_CustomerTransactionAuthRequests') BEGIN
   EXEC('CREATE VIEW [dbo].[vw_CustomerTransactionAuthRequests] as  select top 1 * from vfin_customers')
END
GO

/****** Object:  View [dbo].[vw_CustomerTransactionAuthRequests]    Script Date: 9/14/2014 6:23:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[vw_CustomerTransactionAuthRequests]
AS
SELECT        REPLACE(STR(dbo.vfin_Branches.Code, 3), SPACE(1), '0') + '-' + REPLACE(STR(dbo.vfin_Customers.SerialNumber, 6), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_ProductCode, 3), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductCode, 3), SPACE(1), '0') AS FullAccount, 
                         CASE [Individual_Salutation] WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818' THEN 'Prof' WHEN '48819'
                          THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN 'Ms' ELSE 'UnKnown' END
                          + ' ' + dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName AS FullName, 
                         CASE dbo.vfin_CashWithdrawalRequests.Type WHEN 1 THEN 'Withdrawal Within Limits' WHEN 2 THEN 'Withdrawal Above Maximum Allowed' WHEN 4 THEN 'Withdrawal Below Minimum Balance' ELSE
                          'UnKnown' END AS Type,
                         dbo.vfin_CashWithdrawalRequests.Amount, dbo.vfin_CashWithdrawalRequests.AuthorizedBy, 
                         dbo.vfin_CashWithdrawalRequests.AuthorizationRemarks, dbo.vfin_CashWithdrawalRequests.AuthorizedDate, 
                         dbo.vfin_CashWithdrawalRequests.PaidBy, dbo.vfin_CashWithdrawalRequests.PaidDate, dbo.vfin_CashWithdrawalRequests.CreatedBy, 
                         dbo.vfin_CashWithdrawalRequests.CreatedDate
FROM            dbo.vfin_CashWithdrawalRequests INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_CashWithdrawalRequests.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_CustomerAccounts.BranchId = dbo.vfin_Branches.Id




GO



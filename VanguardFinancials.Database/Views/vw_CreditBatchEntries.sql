IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_CreditBatchEntries') BEGIN
   EXEC('CREATE view [dbo].[vw_CreditBatchEntries] as  select top 1 * from vfin_customers')
END
GO
/****** Object:  View [dbo].[vw_CreditBatchEntries]    Script Date: 9/14/2014 6:08:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[vw_CreditBatchEntries]
WITH SCHEMABINDING 
AS

SELECT        REPLACE(STR(dbo.vfin_Branches.Code, 3), SPACE(1), '0') + '-' + REPLACE(STR(dbo.vfin_Customers.SerialNumber, 5), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_ProductCode, 3), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductCode, 3), SPACE(1), '0') AS FullAccountNumber, 
                         CASE dbo.vfin_Customers.Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818' THEN
                          'Prof' WHEN '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN 'Ms'
                          ELSE 'UnKnown' END + ' ' + dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName AS FullName, dbo.vfin_CreditBatchEntries.Principal, 
                         dbo.vfin_CreditBatchEntries.Interest, dbo.vfin_CreditBatchEntries.CreatedDate AS CreditBatchEntriesDate, dbo.vfin_CreditTypes.Description AS CreditType, 
                         dbo.vfin_ChartOfAccounts.AccountCode AS GLAccountCode, dbo.vfin_ChartOfAccounts.AccountName AS GLAccountName, dbo.vfin_CreditBatches.BatchNumber, 
                         CASE dbo.vfin_CreditBatches.Type WHEN '56026' THEN 'Payout' WHEN '56027' THEN 'Check-off' ELSE 'Unknown' END AS CreditBatchType, 
                         dbo.vfin_CreditBatches.Reference, dbo.vfin_CreditBatches.TotalValue, 
                         CASE dbo.vfin_CreditBatches.Status WHEN 1 THEN 'Pending' WHEN 2 THEN 'Posted' WHEN 4 THEN 'Suspended' END AS BatchStatus, 
                         dbo.vfin_CreditBatches.AuthorizedBy, dbo.vfin_CreditBatches.AuthorizationRemarks, dbo.vfin_CreditBatches.AuthorizedDate, dbo.vfin_CreditBatches.CreatedBy, 
                         dbo.vfin_CreditBatches.CreatedDate, dbo.vfin_Commissions.Description AS CommissionType
FROM            dbo.vfin_CreditBatchEntries INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_CreditBatchEntries.CustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_CustomerAccounts.BranchId = dbo.vfin_Branches.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_CreditBatches ON dbo.vfin_CreditBatchEntries.CreditBatchId = dbo.vfin_CreditBatches.Id AND 
                         dbo.vfin_Branches.Id = dbo.vfin_CreditBatches.BranchId INNER JOIN
                         dbo.vfin_CreditTypes ON dbo.vfin_CreditBatches.CreditTypeId = dbo.vfin_CreditTypes.Id INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_CreditTypes.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id LEFT JOIN
                         dbo.vfin_CreditTypeCommissions ON dbo.vfin_CreditTypes.Id = dbo.vfin_CreditTypeCommissions.CreditTypeId LEFT JOIN
                         dbo.vfin_Commissions ON dbo.vfin_CreditTypeCommissions.CommissionId = dbo.vfin_Commissions.Id




GO



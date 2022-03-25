IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_Overdeductions') BEGIN
   EXEC('CREATE VIEW [dbo].[vw_Overdeductions] as  select top 1 * from vfin_customers')
END
GO

/****** Object:  View [dbo].[vw_Overdeductions]    Script Date: 9/14/2014 6:44:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER view [dbo].[vw_Overdeductions]
AS
SELECT        REPLACE(STR(dbo.vfin_Branches.Code, 3), SPACE(1), '0') + '-' + REPLACE(STR(dbo.vfin_Customers.SerialNumber, 6), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_ProductCode, 3), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductCode, 3), SPACE(1), '0') AS FullAccountNumber, 
                         CASE dbo.vfin_Customers.Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818' THEN
                          'Prof' WHEN '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN 'Ms'
                          ELSE 'UnKnown' END + ' ' + dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName AS FullName, REPLACE(STR(vfin_Branches_1.Code, 3), SPACE(1), 
                         '0') + '-' + REPLACE(STR(vfin_Customers_1.SerialNumber, 6), SPACE(1), '0') 
                         + '-' + REPLACE(STR(vfin_CustomerAccounts_1.CustomerAccountType_ProductCode, 3), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductCode, 3), SPACE(1), '0') AS CredutAccountNumber, 
                         CASE vfin_Customers_1.Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818' THEN 'Prof'
                          WHEN '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN 'Ms' ELSE
                          'UnKnown' END + ' ' + vfin_Customers_1.Individual_FirstName + ' ' + vfin_Customers_1.Individual_LastName AS CreditName, Products_1.Description AS DebitProductType, 
                         dbo.vfin_OverDeductionBatchEntries.Principal, dbo.vfin_OverDeductionBatchEntries.Interest, dbo.vfin_OverDeductionBatches.BatchNumber, 
                         dbo.vfin_OverDeductionBatches.Reference, dbo.vfin_OverDeductionBatches.TotalValue, 
						 case dbo.vfin_OverDeductionBatches.Status
						 when 1 then 'Pending'
						 when 2 then 'Posted'
						 when 4 then 'Suspended'
						 else
						 'UnKnown'
						 end as Status, 
                         
						 dbo.vfin_OverDeductionBatches.AuthorizedBy, dbo.vfin_OverDeductionBatches.AuthorizationRemarks, dbo.vfin_OverDeductionBatches.AuthorizedDate, 
                         dbo.vfin_OverDeductionBatches.CreatedBy, dbo.vfin_OverDeductionBatches.CreatedDate, Products_2.Description AS CreditProduct
FROM            dbo.vfin_OverDeductionBatchEntries INNER JOIN
                         dbo.vfin_OverDeductionBatches ON dbo.vfin_OverDeductionBatchEntries.OverDeductionBatchId = dbo.vfin_OverDeductionBatches.Id INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_OverDeductionBatchEntries.DebitCustomerAccountId = dbo.vfin_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_CustomerAccounts.BranchId = dbo.vfin_Branches.Id INNER JOIN
                         dbo.Products(0) AS Products_1 ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = Products_1.id INNER JOIN
                         dbo.vfin_CustomerAccounts AS vfin_CustomerAccounts_1 ON 
                         dbo.vfin_OverDeductionBatchEntries.CreditCustomerAccountId = vfin_CustomerAccounts_1.Id INNER JOIN
                         dbo.vfin_Customers AS vfin_Customers_1 ON vfin_CustomerAccounts_1.CustomerId = vfin_Customers_1.Id INNER JOIN
                         dbo.vfin_Branches AS vfin_Branches_1 ON vfin_CustomerAccounts_1.BranchId = vfin_Branches_1.Id INNER JOIN
                         dbo.Products(0) AS Products_2 ON vfin_CustomerAccounts_1.CustomerAccountType_TargetProductId = Products_2.id






GO



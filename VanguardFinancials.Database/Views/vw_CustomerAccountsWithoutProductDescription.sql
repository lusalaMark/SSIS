IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_CustomerAccountsWithoutProductDescription') BEGIN
   EXEC('CREATE VIEW [dbo].[vw_CustomerAccountsWithoutProductDescription] as select top 1 * from vfin_customers')
END
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[vw_CustomerAccountsWithoutProductDescription]    Script Date: 10/9/2014 3:10:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[vw_CustomerAccountsWithoutProductDescription]
WITH SCHEMABINDING
AS
SELECT        REPLACE(STR(dbo.vfin_Branches.Code, 3), SPACE(1), '0') + '-' + REPLACE(STR(dbo.vfin_Customers.SerialNumber, 6), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_ProductCode, 3), SPACE(1), '0') 
                         + '-' + REPLACE(STR(dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductCode, 3), SPACE(1), '0') AS FullAccount, 
                         CASE [Individual_Salutation] WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818' THEN 'Prof' WHEN
                          '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN 'Ms' ELSE ''
                          END + ' ' + rtrim(ltrim(isnull(dbo.vfin_Customers.Individual_FirstName,''))) + ' ' + ltrim(ltrim(isnull(dbo.vfin_Customers.Individual_LastName,''))) + ' ' + ltrim(rtrim(isnull(dbo.vfin_Customers.NonIndividual_Description,''))) AS FullName, dbo.vfin_CustomerAccounts.Id, 
                         dbo.vfin_CustomerAccounts.CustomerId, dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId, 
                         dbo.vfin_CustomerAccounts.CustomerAccountType_ProductCode, dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductCode, 
                         dbo.vfin_Customers.Reference1, dbo.vfin_CustomerAccounts.BranchId, dbo.vfin_Customers.Reference2, dbo.vfin_Customers.Individual_PayrollNumbers, 
                         dbo.vfin_Customers.Reference3, dbo.vfin_CustomerAccounts.Remarks, dbo.vfin_Customers.NonIndividual_RegistrationNumber, dbo.vfin_Customers.StationId, 
                         dbo.vfin_Customers.SerialNumber
FROM            dbo.vfin_CustomerAccounts INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_CustomerAccounts.BranchId = dbo.vfin_Branches.Id


GO



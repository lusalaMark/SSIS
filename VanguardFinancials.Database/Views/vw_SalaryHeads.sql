IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_SalaryHeads') BEGIN
   EXEC('CREATE view [dbo].[vw_SalaryHeads] as  select top 1 * from vfin_customers')
END
GO

/****** Object:  View [dbo].[vw_SalaryHeads]    Script Date: 9/14/2014 6:50:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[vw_SalaryHeads]
AS
SELECT        dbo.vfin_SalaryHeads.Description, dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, 
                         CASE dbo.vfin_SalaryHeads.Category WHEN 1 THEN 'Earning' WHEN 2 THEN 'Deduction' END AS Category, dbo.vfin_SalaryHeads.Category AS Category1
FROM            dbo.vfin_SalaryHeads INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_SalaryHeads.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id



GO



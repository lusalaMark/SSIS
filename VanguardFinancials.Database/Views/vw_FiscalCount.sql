IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_FiscalCount') BEGIN
   EXEC('CREATE VIEW [dbo].[vw_FiscalCount] as  select top 1 * from vfin_customers')
END
GO

/****** Object:  View [dbo].[vw_FiscalCount]    Script Date: 9/14/2014 6:31:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER view [dbo].[vw_FiscalCount]
WITH SCHEMABINDING
AS
SELECT        dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_FiscalCounts.SecondaryDescription, dbo.vfin_FiscalCounts.Reference, 
                         dbo.vfin_FiscalCounts.Denomination_OneThousandValue, dbo.vfin_FiscalCounts.Denomination_FiveHundredValue, 
                         dbo.vfin_FiscalCounts.Denomination_TwoHundredValue, dbo.vfin_FiscalCounts.Denomination_OneHundredValue, dbo.vfin_FiscalCounts.Denomination_FiftyValue, 
                         dbo.vfin_FiscalCounts.Denomination_FourtyValue, dbo.vfin_FiscalCounts.Denomination_TwentyValue, dbo.vfin_FiscalCounts.Denomination_TenValue, 
                         dbo.vfin_FiscalCounts.Denomination_FiveValue, dbo.vfin_FiscalCounts.Denomination_OneValue, dbo.vfin_FiscalCounts.Denomination_FiftyCentValue, 
                         dbo.vfin_FiscalCounts.CreatedBy, dbo.vfin_FiscalCounts.CreatedDate
FROM            dbo.vfin_FiscalCounts INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_FiscalCounts.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id





GO



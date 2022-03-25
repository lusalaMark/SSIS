IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_SalaryGroups') BEGIN
   EXEC('CREATE view [dbo].[vw_SalaryGroups] as  select top 1 * from vfin_customers')
END
GO

/****** Object:  View [dbo].[vw_SalaryGroups]    Script Date: 9/14/2014 6:48:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER view [dbo].[vw_SalaryGroups]
AS
SELECT        dbo.vfin_SalaryGroups.Description, dbo.vfin_SalaryGroupEntries.Charge_Percentage, dbo.vfin_SalaryGroupEntries.Charge_FixedAmount, 
                         dbo.vfin_SalaryHeads.Description AS SalaryHead, 
                         CASE dbo.vfin_SalaryGroupEntries.RoundingType WHEN 1 THEN 'To Even' WHEN 2 THEN 'Away From Zero' WHEN 4 THEN 'No Rounding' END AS RoundingType
FROM            dbo.vfin_SalaryGroups INNER JOIN
                         dbo.vfin_SalaryGroupEntries ON dbo.vfin_SalaryGroups.Id = dbo.vfin_SalaryGroupEntries.SalaryGroupId INNER JOIN
                         dbo.vfin_SalaryHeads ON dbo.vfin_SalaryGroupEntries.SalaryHeadId = dbo.vfin_SalaryHeads.Id




GO



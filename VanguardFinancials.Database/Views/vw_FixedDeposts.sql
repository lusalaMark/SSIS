IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_FixedDeposts') BEGIN
   EXEC('CREATE VIEW [dbo].[vw_FixedDeposts] as  select top 1 * from vfin_customers')
END
GO

/****** Object:  View [dbo].[vw_FixedDeposts]    Script Date: 9/14/2014 6:33:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER view [dbo].[vw_FixedDeposts]
AS
SELECT        dbo.vw_CustomerAccounts.FullAccount, dbo.vw_CustomerAccounts.FullName, dbo.vfin_FixedDeposits.Value, dbo.vfin_FixedDeposits.Term, 
                         dbo.vfin_FixedDeposits.Rate, dbo.vfin_FixedDeposits.Remarks, dbo.vfin_FixedDeposits.ExpectedInterest, dbo.vfin_FixedDeposits.MaturityDate, 
                         dbo.vfin_FixedDeposits.TotalExpected, dbo.vfin_FixedDeposits.PaidBy, dbo.vfin_FixedDeposits.PaidDate, dbo.vfin_FixedDeposits.CreatedBy, 
                         dbo.vfin_FixedDeposits.CreatedDate, 
                         CASE dbo.vfin_FixedDeposits.Status WHEN 1 THEN 'Running' WHEN 2 THEN 'Paid' WHEN 4 THEN 'Revoked' END AS Status
FROM            dbo.vfin_FixedDeposits INNER JOIN
                         dbo.vw_CustomerAccounts ON dbo.vfin_FixedDeposits.CustomerAccountId = dbo.vw_CustomerAccounts.Id





GO



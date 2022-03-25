IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_KBABankListing') BEGIN
   EXEC('CREATE VIEW [dbo].[vw_KBABankListing] as  select top 1 * from vfin_customers')
END
GO
/****** Object:  View [dbo].[vw_KBABankListing]    Script Date: 9/14/2014 6:34:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[vw_KBABankListing]
AS
SELECT        REPLACE(STR(dbo.vfin_Banks.Code, 2), SPACE(1), '0') AS BankCode, dbo.vfin_Banks.Description, REPLACE(STR(dbo.vfin_BankBranches.Code, 3), SPACE(1), '0') 
                         AS BankBranchCode, dbo.vfin_BankBranches.Description AS BankBranch
FROM            dbo.vfin_Banks INNER JOIN
                         dbo.vfin_BankBranches ON dbo.vfin_Banks.Id = dbo.vfin_BankBranches.BankId




GO



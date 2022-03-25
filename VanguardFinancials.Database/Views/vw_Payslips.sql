IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_Payslips') BEGIN
   EXEC('CREATE view [dbo].[vw_Payslips] as  select top 1 * from vfin_customers')
END
GO

/****** Object:  View [dbo].[vw_Payslips]    Script Date: 9/14/2014 6:45:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[vw_Payslips]
AS
SELECT        TOP (100) PERCENT dbo.vw_EmployeeRegister.FullName, dbo.vw_EmployeeRegister.IdentityCardNumber, dbo.vw_EmployeeRegister.MembershipNumber, 
                         dbo.vw_EmployeeRegister.PersonalFileNumber, dbo.vfin_SalaryCards.CardNumber, dbo.vfin_SalaryPeriods.Month, 
                         dbo.vfin_SalaryGroups.Description AS JobGroups, dbo.vfin_SalaryPeriods.Status, dbo.vfin_SalaryPeriods.AuthorizedBy, 
                         dbo.vfin_SalaryPeriods.AuthorizationRemarks, dbo.vfin_SalaryPeriods.AuthorizedDate, dbo.vfin_SalaryPeriods.CreatedBy, dbo.vfin_SalaryPeriods.CreatedDate, 
                         dbo.vw_CustomerAccounts.FullAccount, dbo.vfin_PaySlipEntries.Description AS PayslipDescription, dbo.vfin_PaySlipEntries.Principal, 
                         dbo.vfin_PaySlipEntries.Interest, dbo.vfin_PaySlipEntries.CreatedDate AS PayslipDate, dbo.vfin_PaySlipEntries.SalaryHeadType, 
                         dbo.vfin_PaySlipEntries.SalaryHeadCategory
FROM            dbo.vfin_PaySlipEntries INNER JOIN
                         dbo.vfin_PaySlips ON dbo.vfin_PaySlipEntries.PaySlipId = dbo.vfin_PaySlips.Id INNER JOIN
                         dbo.vfin_SalaryPeriods ON dbo.vfin_PaySlips.SalaryPeriodId = dbo.vfin_SalaryPeriods.Id INNER JOIN
                         dbo.vfin_SalaryCards ON dbo.vfin_PaySlips.SalaryCardId = dbo.vfin_SalaryCards.Id INNER JOIN
                         dbo.vfin_SalaryGroups ON dbo.vfin_SalaryCards.SalaryGroupId = dbo.vfin_SalaryGroups.Id INNER JOIN
                         dbo.vfin_SalaryGroupEntries ON dbo.vfin_SalaryGroups.Id = dbo.vfin_SalaryGroupEntries.SalaryGroupId INNER JOIN
                         dbo.vfin_SalaryHeads ON dbo.vfin_SalaryGroupEntries.SalaryHeadId = dbo.vfin_SalaryHeads.Id INNER JOIN
                         dbo.vw_EmployeeRegister ON dbo.vfin_SalaryCards.EmployeeId = dbo.vw_EmployeeRegister.EmployeeID INNER JOIN
                         dbo.vw_CustomerAccounts ON dbo.vfin_PaySlipEntries.CustomerAccountId = dbo.vw_CustomerAccounts.Id
ORDER BY dbo.vfin_PaySlipEntries.SalaryHeadType, dbo.vfin_PaySlipEntries.SalaryHeadCategory




GO



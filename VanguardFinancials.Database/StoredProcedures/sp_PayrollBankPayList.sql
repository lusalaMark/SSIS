IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_PayrollBankPayList') BEGIN
   EXEC('CREATE PROC [dbo].[sp_PayrollBankPayList] as')
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--select * from vfin_PostingPeriods
---sp_PayrollBankPayList '0777363D-0845-C660-9E58-08D1336CB025',5
ALTER PROCEDURE [dbo].[sp_PayrollBankPayList]
	-- Add the parameters for the stored procedure here
	(
		@PostingPeriod varchar(100),
		@SalaryMonth int
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SELECT        REPLACE(STR(dbo.vfin_SalaryCards.CardNumber, 4), SPACE(1), '0') AS CardNumber, dbo.vw_EmployeeRegister.FullName, dbo.vw_EmployeeRegister.Gender, 
								 dbo.vw_EmployeeRegister.IdentityCardNumber, dbo.vw_EmployeeRegister.Nationality, dbo.vw_EmployeeRegister.MembershipNumber, 
								 dbo.vw_EmployeeRegister.EmploymentType,dbo.vw_EmployeeRegister.reference1, dbo.vw_EmployeeRegister.PersonalFileNumber, dbo.vw_EmployeeRegister.DateOfBirth,
								  SUM(CASE WHEN dbo.vfin_PaySlipEntries.SalaryHeadCategory = 1 THEN dbo.vfin_PaySlipEntries.Principal ELSE (dbo.vfin_PaySlipEntries.Principal + dbo.vfin_PaySlipEntries.Interest)
								  * - 1 END) AS NetPay
		FROM            dbo.vfin_PaySlips INNER JOIN
								 dbo.vfin_PaySlipEntries ON dbo.vfin_PaySlips.Id = dbo.vfin_PaySlipEntries.PaySlipId INNER JOIN
								 dbo.vfin_SalaryCards ON dbo.vfin_PaySlips.SalaryCardId = dbo.vfin_SalaryCards.Id INNER JOIN
								 dbo.vfin_SalaryPeriods ON dbo.vfin_PaySlips.SalaryPeriodId = dbo.vfin_SalaryPeriods.Id INNER JOIN
								 dbo.vfin_SalaryGroups ON dbo.vfin_SalaryCards.SalaryGroupId = dbo.vfin_SalaryGroups.Id INNER JOIN
								 dbo.vfin_PostingPeriods ON dbo.vfin_SalaryPeriods.PostingPeriodId = dbo.vfin_PostingPeriods.Id INNER JOIN
								 dbo.vw_EmployeeRegister ON dbo.vfin_SalaryCards.EmployeeId = dbo.vw_EmployeeRegister.EmployeeID
		WHERE			dbo.vfin_PostingPeriods.id=@PostingPeriod and dbo.vfin_SalaryPeriods.Month=@SalaryMonth

		GROUP BY dbo.vfin_SalaryPeriods.Month, dbo.vfin_SalaryCards.CardNumber, dbo.vw_EmployeeRegister.FullName, dbo.vw_EmployeeRegister.Gender, 
								 dbo.vw_EmployeeRegister.IdentityCardNumber, dbo.vw_EmployeeRegister.Nationality, dbo.vw_EmployeeRegister.MembershipNumber, 
								 dbo.vw_EmployeeRegister.EmploymentType, dbo.vw_EmployeeRegister.PersonalFileNumber, dbo.vw_EmployeeRegister.DateOfBirth,dbo.vw_EmployeeRegister.reference1
								 order by dbo.vw_EmployeeRegister.PersonalFileNumber

END

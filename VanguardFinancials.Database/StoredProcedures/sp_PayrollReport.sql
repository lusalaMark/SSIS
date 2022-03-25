IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_PayrollReport') BEGIN
   EXEC('CREATE PROC [dbo].[sp_PayrollReport] as')
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
ALTER PROCEDURE [dbo].[sp_PayrollReport] 
	-- Add the parameters for the stored procedure here
	(
		@PostingPeriodID VARCHAR(100),
		@SalaryMonth int,
		@SalaryHeadID VARCHAR(100)
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT        dbo.vw_EmployeeRegister.FullName, dbo.vw_EmployeeRegister.Gender, dbo.vw_EmployeeRegister.MaritalStatus, dbo.vw_EmployeeRegister.IdentityCardNumber, 
							 dbo.vw_EmployeeRegister.Nationality, dbo.vw_EmployeeRegister.MembershipNumber, dbo.vw_EmployeeRegister.EmploymentType, 
							 dbo.vw_EmployeeRegister.PersonalFileNumber, dbo.vw_EmployeeRegister.DateOfBirth, dbo.vw_EmployeeRegister.Designation, 
							 dbo.vw_EmployeeRegister.PersonalIdentificationNumber, dbo.vw_EmployeeRegister.NationalSocialSecurityFundNumber, 
							 dbo.vw_EmployeeRegister.NationalHospitalInsuranceFundNumber, dbo.vw_EmployeeRegister.BloodGroup, REPLACE(STR(dbo.vfin_SalaryCards.CardNumber, 4), 
								 SPACE(1), '0') AS CardNumber,dbo.vfin_PostingPeriods.Description AS PostingPeriod, dbo.vfin_SalaryPeriods.Month AS SalaryMonth, dbo.vfin_PaySlipEntries.Description, 
							 dbo.vfin_PaySlipEntries.Principal, dbo.vfin_PaySlipEntries.Interest,dbo.vfin_PaySlipEntries.SalaryHeadCategory
	FROM            dbo.vfin_PaySlipEntries INNER JOIN
							 dbo.vfin_PaySlips ON dbo.vfin_PaySlipEntries.PaySlipId = dbo.vfin_PaySlips.Id INNER JOIN
							 dbo.vfin_SalaryPeriods ON dbo.vfin_PaySlips.SalaryPeriodId = dbo.vfin_SalaryPeriods.Id INNER JOIN
							 dbo.vfin_PostingPeriods ON dbo.vfin_SalaryPeriods.PostingPeriodId = dbo.vfin_PostingPeriods.Id INNER JOIN
							 dbo.vfin_SalaryCards ON dbo.vfin_PaySlips.SalaryCardId = dbo.vfin_SalaryCards.Id INNER JOIN
							 dbo.vw_EmployeeRegister ON dbo.vfin_SalaryCards.EmployeeId = dbo.vw_EmployeeRegister.EmployeeID 
	WHERE dbo.vfin_PostingPeriods.Id=@PostingPeriodID and dbo.vfin_SalaryPeriods.Month=@SalaryMonth and dbo.vfin_PaySlipEntries.Description=@SalaryHeadID
	ORDER BY dbo.vw_EmployeeRegister.PersonalFileNumber
END

GO

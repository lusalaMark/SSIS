IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_payslips') BEGIN
   EXEC('CREATE PROC [dbo].[sp_payslips] as')
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
---sp_payslips 'CB716133-38CB-CEA8-CF3F-08D1F352E534',1
ALTER PROCEDURE [dbo].[sp_payslips]
	-- Add the parameters for the stored procedure here
	(
		@PostingPeriod varchar(100),
		@SalaryMonth int
	)
AS
BEGIN
	Declare @EndDate Datetime
	
	---set @EndDate=(select EndDate from 
	---GetMonthList((select Duration_StartDate from vfin_PostingPeriods where id=@PostingPeriod),1) where MonthNumber=@SalaryMonth)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here

WITH DirectReports
(PostingPeriod, SalaryMonth, CardNumber, FullName, Gender, IdentityCardNumber, Nationality,MembershipNumber, EmploymentType, 
PersonalFileNumber, DateOfBirth, Designation,PersonalIdentificationNumber,NationalSocialSecurityFundNumber, 
NationalHospitalInsuranceFundNumber,BloodGroup, SalaryGroup, SalaryPeriodStatus,Description, HeadCategoryDescription, SalaryMonthName, 
SalaryHeadCategory,Amount, CreatedDate,SalaryHeadType, Balance
)
AS 
(
		SELECT        dbo.vfin_PostingPeriods.Description AS PostingPeriod, dbo.vfin_SalaryPeriods.Month AS SalaryMonth, REPLACE(STR(dbo.vfin_SalaryCards.CardNumber, 4), 
								 SPACE(1), '0') AS CardNumber, dbo.vw_EmployeeRegister.FullName, dbo.vw_EmployeeRegister.Gender, dbo.vw_EmployeeRegister.IdentityCardNumber, 
								 dbo.vw_EmployeeRegister.Nationality, dbo.vw_EmployeeRegister.MembershipNumber, dbo.vw_EmployeeRegister.EmploymentType, 
								 dbo.vw_EmployeeRegister.PersonalFileNumber, dbo.vw_EmployeeRegister.DateOfBirth, dbo.vw_EmployeeRegister.Designation, 
								 dbo.vw_EmployeeRegister.PersonalIdentificationNumber, dbo.vw_EmployeeRegister.NationalSocialSecurityFundNumber, 
								 dbo.vw_EmployeeRegister.NationalHospitalInsuranceFundNumber, dbo.vw_EmployeeRegister.BloodGroup, dbo.vfin_SalaryGroups.Description AS SalaryGroup, 
								 CASE dbo.vfin_SalaryPeriods.Status WHEN 1 THEN 'Open' WHEN 2 THEN 'Closed' WHEN 3 THEN 'Suspended' END AS SalaryPeriodStatus, 
								 dbo.vfin_PaySlipEntries.Description, 
								 CASE dbo.vfin_PaySlipEntries.SalaryHeadCategory WHEN 1 THEN 'EARNINGS' WHEN 2 THEN 'DEDUCTIONS' END AS HeadCategoryDescription,(select DATENAME(MONTH, '2012-' + CAST(number as varchar(2)) + '-1') 
								FROM master..spt_values
								WHERE Type = 'P' and number between 1 and 12
								and number=dbo.vfin_SalaryPeriods.Month) as SalaryMonthName, 
								 dbo.vfin_PaySlipEntries.SalaryHeadCategory, dbo.vfin_PaySlipEntries.Principal, dbo.vfin_SalaryPeriods.CreatedDate,dbo.vfin_PaySlipEntries.SalaryHeadType,
								case dbo.vfin_PaySlipEntries.SalaryHeadCategory
								WHEN 1 THEN 0
								else
									isnull((
									SELECT        SUM(dbo.vfin_JournalEntries.Amount) AS Expr1
									FROM            dbo.vfin_JournalEntries INNER JOIN
															 dbo.Products(0) AS Products_1 ON dbo.vfin_JournalEntries.ChartOfAccountId = Products_1.ChartOfAccountId INNER JOIN
															 dbo.vfin_CustomerAccounts ON dbo.vfin_JournalEntries.CustomerAccountId = dbo.vfin_CustomerAccounts.Id AND 
															 Products_1.id = dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId
						 															 WHERE        (dbo.vfin_JournalEntries.CustomerAccountId = dbo.vfin_PaySlipEntries.CustomerAccountId) AND 
															 (dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_PaySlipEntries.ChartOfAccountId) AND 
															 (dbo.vfin_JournalEntries.CreatedDate <= dbo.vfin_PaySlipEntries.CreatedDate) 
																		),0)
								end as Balance
		FROM            dbo.vfin_PaySlips INNER JOIN
								 dbo.vfin_PaySlipEntries ON dbo.vfin_PaySlips.Id = dbo.vfin_PaySlipEntries.PaySlipId INNER JOIN
								 dbo.vfin_SalaryCards ON dbo.vfin_PaySlips.SalaryCardId = dbo.vfin_SalaryCards.Id INNER JOIN
								 dbo.vfin_SalaryPeriods ON dbo.vfin_PaySlips.SalaryPeriodId = dbo.vfin_SalaryPeriods.Id INNER JOIN
								 dbo.vfin_SalaryGroups ON dbo.vfin_SalaryCards.SalaryGroupId = dbo.vfin_SalaryGroups.Id INNER JOIN
								 dbo.vfin_PostingPeriods ON dbo.vfin_SalaryPeriods.PostingPeriodId = dbo.vfin_PostingPeriods.Id INNER JOIN
								 dbo.vw_EmployeeRegister ON dbo.vfin_SalaryCards.EmployeeId = dbo.vw_EmployeeRegister.EmployeeID INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_PaySlipEntries.CustomerAccountId = dbo.vfin_CustomerAccounts.Id
		WHERE			dbo.vfin_PostingPeriods.id=@PostingPeriod and dbo.vfin_SalaryPeriods.Month=@SalaryMonth



		union all
		SELECT        dbo.vfin_PostingPeriods.Description AS PostingPeriod, dbo.vfin_SalaryPeriods.Month AS SalaryMonth, REPLACE(STR(dbo.vfin_SalaryCards.CardNumber, 4), 
								 SPACE(1), '0') AS CardNumber, dbo.vw_EmployeeRegister.FullName, dbo.vw_EmployeeRegister.Gender, dbo.vw_EmployeeRegister.IdentityCardNumber, 
								 dbo.vw_EmployeeRegister.Nationality, dbo.vw_EmployeeRegister.MembershipNumber, dbo.vw_EmployeeRegister.EmploymentType, 
								 dbo.vw_EmployeeRegister.PersonalFileNumber, dbo.vw_EmployeeRegister.DateOfBirth, dbo.vw_EmployeeRegister.Designation, 
								 dbo.vw_EmployeeRegister.PersonalIdentificationNumber, dbo.vw_EmployeeRegister.NationalSocialSecurityFundNumber, 
								 dbo.vw_EmployeeRegister.NationalHospitalInsuranceFundNumber, dbo.vw_EmployeeRegister.BloodGroup, dbo.vfin_SalaryGroups.Description AS SalaryGroup, 
								 CASE dbo.vfin_SalaryPeriods.Status WHEN 1 THEN 'Open' WHEN 2 THEN 'Closed' WHEN 3 THEN 'Suspended' END AS SalaryPeriodStatus, 
								 ltrim(rtrim(dbo.vfin_PaySlipEntries.Description)) +' Interest', 
								 CASE dbo.vfin_PaySlipEntries.SalaryHeadCategory WHEN 1 THEN 'EARNINGS' WHEN 2 THEN 'DEDUCTIONS' END AS HeadCategoryDescription,(select DATENAME(MONTH, '2012-' + CAST(number as varchar(2)) + '-1') 
								FROM master..spt_values
								WHERE Type = 'P' and number between 1 and 12
								and number=dbo.vfin_SalaryPeriods.Month) as SalaryMonthName, 
								 dbo.vfin_PaySlipEntries.SalaryHeadCategory, dbo.vfin_PaySlipEntries.Interest, dbo.vfin_SalaryPeriods.CreatedDate,dbo.vfin_PaySlipEntries.SalaryHeadType,
									0 as Balance
		FROM            dbo.vfin_PaySlips INNER JOIN
								 dbo.vfin_PaySlipEntries ON dbo.vfin_PaySlips.Id = dbo.vfin_PaySlipEntries.PaySlipId INNER JOIN
								 dbo.vfin_SalaryCards ON dbo.vfin_PaySlips.SalaryCardId = dbo.vfin_SalaryCards.Id INNER JOIN
								 dbo.vfin_SalaryPeriods ON dbo.vfin_PaySlips.SalaryPeriodId = dbo.vfin_SalaryPeriods.Id INNER JOIN
								 dbo.vfin_SalaryGroups ON dbo.vfin_SalaryCards.SalaryGroupId = dbo.vfin_SalaryGroups.Id INNER JOIN
								 dbo.vfin_PostingPeriods ON dbo.vfin_SalaryPeriods.PostingPeriodId = dbo.vfin_PostingPeriods.Id INNER JOIN
								 dbo.vw_EmployeeRegister ON dbo.vfin_SalaryCards.EmployeeId = dbo.vw_EmployeeRegister.EmployeeID INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_PaySlipEntries.CustomerAccountId = dbo.vfin_CustomerAccounts.Id
		WHERE			dbo.vfin_PostingPeriods.id=@PostingPeriod and dbo.vfin_SalaryPeriods.Month=@SalaryMonth and  dbo.vfin_PaySlipEntries.Interest>0

)
select PostingPeriod, SalaryMonth, CardNumber, FullName, Gender, IdentityCardNumber, Nationality,MembershipNumber, EmploymentType, 
PersonalFileNumber, DateOfBirth, Designation,PersonalIdentificationNumber,NationalSocialSecurityFundNumber, 
NationalHospitalInsuranceFundNumber,BloodGroup, SalaryGroup, SalaryPeriodStatus,Description, HeadCategoryDescription, SalaryMonthName, 
SalaryHeadCategory,Amount, CreatedDate,SalaryHeadType, Balance
from DirectReports ORDER BY PersonalFileNumber,SalaryHeadCategory,SalaryHeadType,CreatedDate,Description


END


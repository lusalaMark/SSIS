IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_EmployeeRegisterByGroups') BEGIN
   EXEC('CREATE PROC [dbo].[sp_EmployeeRegisterByGroups] as')
END

GO
/****** Object:  StoredProcedure [dbo].[sp_EmployeeRegisterByGroups]    Script Date: 9/13/2014 4:26:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_EmployeeRegisterByGroups]
	-- Ad
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT        dbo.vfin_SalaryGroups.Description AS SalaryGroup, dbo.vfin_SalaryCards.CardNumber, dbo.vw_EmployeeRegister.FullName, dbo.vw_EmployeeRegister.Gender, 
                         dbo.vw_EmployeeRegister.IdentityCardNumber, dbo.vw_EmployeeRegister.MembershipNumber, dbo.vw_EmployeeRegister.EmploymentType, 
                         dbo.vw_EmployeeRegister.PersonalFileNumber, dbo.vw_EmployeeRegister.Designation, dbo.vw_EmployeeRegister.PersonalIdentificationNumber, 
                         dbo.vw_EmployeeRegister.NationalSocialSecurityFundNumber, dbo.vw_EmployeeRegister.NationalHospitalInsuranceFundNumber
	FROM            dbo.vfin_SalaryCards INNER JOIN
                         dbo.vw_EmployeeRegister ON dbo.vfin_SalaryCards.EmployeeId = dbo.vw_EmployeeRegister.EmployeeID INNER JOIN
                         dbo.vfin_SalaryGroups ON dbo.vfin_SalaryCards.SalaryGroupId = dbo.vfin_SalaryGroups.Id
END



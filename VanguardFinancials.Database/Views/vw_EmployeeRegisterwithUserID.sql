IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_EmployeeRegisterwithUserID') BEGIN
   EXEC('CREATE VIEW [dbo].[vw_EmployeeRegisterwithUserID] as select top 1 * from vfin_Companies')
END
GO
GO

/****** Object:  View [dbo].[vw_EmployeeRegisterwithUserID]    Script Date: 9/14/2014 6:29:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vw_EmployeeRegisterwithUserID]
AS
SELECT        dbo.GetProfilePropertyValue('EmployeeId', dbo.aspnet_Profile.PropertyNames, dbo.aspnet_Profile.PropertyValuesString) AS ID, 
                         dbo.vw_EmployeeRegister.FullName, dbo.vw_EmployeeRegister.Gender, dbo.vw_EmployeeRegister.MaritalStatus, dbo.vw_EmployeeRegister.IdentityCardNumber, 
                         dbo.vw_EmployeeRegister.Nationality, dbo.vw_EmployeeRegister.MembershipNumber, dbo.vw_EmployeeRegister.EmploymentType, 
                         dbo.vw_EmployeeRegister.PersonalFileNumber, dbo.vw_EmployeeRegister.DateOfBirth, dbo.vw_EmployeeRegister.Designation, 
                         dbo.vw_EmployeeRegister.NationalSocialSecurityFundNumber, dbo.vw_EmployeeRegister.PersonalIdentificationNumber, 
                         dbo.vw_EmployeeRegister.NationalHospitalInsuranceFundNumber, dbo.vw_EmployeeRegister.BloodGroup, dbo.vw_EmployeeRegister.Remarks, 
                         dbo.vw_EmployeeRegister.CreatedDate, dbo.vw_EmployeeRegister.Reference1, dbo.aspnet_Profile.UserId, dbo.aspnet_Users.UserName
FROM            dbo.aspnet_Profile INNER JOIN
                         dbo.vw_EmployeeRegister ON dbo.GetProfilePropertyValue('EmployeeId', dbo.aspnet_Profile.PropertyNames, dbo.aspnet_Profile.PropertyValuesString) 
                         = dbo.vw_EmployeeRegister.EmployeeID INNER JOIN
                         dbo.aspnet_Users ON dbo.aspnet_Profile.UserId = dbo.aspnet_Users.UserId
WHERE        (dbo.aspnet_Profile.UserId IN
                             (SELECT        UserId
                               FROM            dbo.aspnet_Users AS aspnet_Users_1))

GO



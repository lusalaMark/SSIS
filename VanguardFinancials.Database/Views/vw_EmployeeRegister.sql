IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_EmployeeRegister') BEGIN
   EXEC('CREATE VIEW [dbo].[vw_EmployeeRegister] as  select top 1 * from vfin_customers')
END
GO
/****** Object:  View [dbo].[vw_EmployeeRegister]    Script Date: 9/14/2014 6:26:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter VIEW [dbo].[vw_EmployeeRegister]
WITH SCHEMABINDING 
AS
SELECT        CASE Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818' THEN 'Prof' WHEN
                          '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN 'Ms' ELSE 'UnKnown'
                          END + ' ' + dbo.vfin_Customers.Individual_FirstName + ' ' + dbo.vfin_Customers.Individual_LastName AS FullName, 
                         CASE vfin_Customers.Individual_Gender WHEN '57008' THEN 'Male' WHEN '57009' THEN 'Female' ELSE 'UnKnown' END AS Gender, 
                         CASE vfin_Customers.Individual_MaritalStatus WHEN '65262' THEN 'Married' WHEN '65263' THEN 'Single' WHEN '65264' THEN 'Divorced' WHEN '65265' THEN 'Separated'
                          ELSE 'UnKnown' END AS MaritalStatus, dbo.vfin_Customers.Individual_IdentityCardNumber AS IdentityCardNumber, 
                         CASE dbo.vfin_Customers.Individual_Nationality WHEN 1 THEN 'Kenya' WHEN 2 THEN 'Uganda' WHEN 3 THEN 'Tanzania' WHEN 4 THEN 'Rwanda' WHEN 4 THEN 'Burundi'
                          ELSE 'UnKnown' END AS Nationality, RIGHT('00000' + CAST(LTRIM(RTRIM(dbo.vfin_Customers.SerialNumber)) AS VARCHAR(6)), 5) AS MembershipNumber, 
                         CASE dbo.vfin_Employees.Type WHEN 1 THEN 'Full-Time' WHEN 2 THEN 'Part-Time' WHEN 4 THEN 'Contract' END AS EmploymentType, 
                         dbo.vfin_Customers.Individual_PayrollNumbers AS PersonalFileNumber, dbo.vfin_Customers.Individual_BirthDate AS DateOfBirth, 
                         dbo.vfin_Designations.Description AS Designation, dbo.vfin_Employees.PersonalIdentificationNumber, dbo.vfin_Employees.NationalSocialSecurityFundNumber, 
                         dbo.vfin_Employees.NationalHospitalInsuranceFundNumber, 
                         CASE [BloodGroup] WHEN 0 THEN 'Unknown' WHEN 1 THEN 'A-' WHEN 2 THEN 'A+' WHEN 0 THEN 'B-' WHEN 1 THEN 'B+' WHEN 2 THEN 'AB-' WHEN 0 THEN 'AB+'
                          WHEN 1 THEN 'O-' WHEN 2 THEN 'O+' END AS BloodGroup, dbo.vfin_Employees.Remarks, dbo.vfin_Employees.CreatedDate, dbo.vfin_Customers.Reference1, 
                         dbo.vfin_Employees.Id AS EmployeeID, dbo.vfin_Employees.CustomerId, dbo.vfin_Customers.Reference3, dbo.vfin_Customers.Reference2, 
                         dbo.vfin_Employees.BranchId, dbo.vfin_Branches.Description AS Branch
FROM            dbo.vfin_Employees INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_Employees.CustomerId = dbo.vfin_Customers.Id INNER JOIN
                         dbo.vfin_Branches ON dbo.vfin_Employees.BranchId = dbo.vfin_Branches.Id INNER JOIN
                         dbo.vfin_Designations ON dbo.vfin_Employees.DesignationId = dbo.vfin_Designations.Id

GO

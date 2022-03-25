IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_Customers') BEGIN
   EXEC('CREATE view [dbo].[vw_Customers] as select top 1 * from vfin_Companies')
END
GO

/****** Object:  View [dbo].[vw_Budget]    Script Date: 9/14/2014 6:05:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter view [dbo].[vw_Customers]
WITH SCHEMABINDING
AS
SELECT        CASE Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818'
                          THEN 'Prof' WHEN '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN
                          'Ms' ELSE 'UnKnown' END +' '+ Individual_FirstName+' '+Individual_LastName as FullName, 
                         CASE Individual_Gender WHEN '57008' THEN 'Male' WHEN '57009' THEN 'Female' ELSE 'UnKnown' END AS Gender, 
                         CASE Individual_MaritalStatus WHEN '65262' THEN 'Married' WHEN '65263' THEN 'Single' WHEN '65264' THEN 'Divorced' WHEN '65265' THEN 'Separated' ELSE 'UnKnown'
                          END AS MaritalStatus, Individual_IdentityCardNumber, 
                         CASE dbo.vfin_Customers.Individual_Nationality WHEN 1 THEN 'Kenya' WHEN 2 THEN 'Uganda' WHEN 3 THEN 'Tanzania' WHEN 4 THEN 'Rwanda' WHEN 4 THEN 'Burundi'
                          ELSE 'UnKnown' END AS Nationality, RIGHT('00000' + CAST(LTRIM(RTRIM(SerialNumber)) AS VARCHAR(5)), 5) AS MembershipNumber, Individual_PayrollNumbers, 
                         Individual_BirthDate, Address_AddressLine1, Address_AddressLine2, Address_Street, Address_PostalCode, Address_City, Address_Email, Address_LandLine, 
                         Address_MobileLine, RegistrationDate, CreatedDate, '' AS [Witness Person], Individual_EmploymentDate, Individual_EmploymentDesignation, 
                         REPLACE(STR(SerialNumber, 5), SPACE(1), '0') AS DelegateMembershipNumber, LTRIM(RTRIM(Individual_FirstName)) + ' ' + LTRIM(RTRIM(Individual_LastName)) 
                         AS DelegateName, Id, REPLACE(STR(SerialNumber, 6), SPACE(1), '0') AS SerialNumber, Reference1, Reference2, Reference3
FROM            dbo.vfin_Customers

GO




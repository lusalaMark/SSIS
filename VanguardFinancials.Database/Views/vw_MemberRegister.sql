IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='vw_MemberRegister') BEGIN
   EXEC('CREATE view [dbo].[vw_MemberRegister] as  select top 1 * from vfin_customers')
END
GO

/****** Object:  View [dbo].[vw_MemberRegister]    Script Date: 9/14/2014 6:43:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vw_MemberRegister]
WITH SCHEMABINDING
AS
SELECT        CASE vfin_Customers_2.Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818'
                          THEN 'Prof' WHEN '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN
                          'Ms' ELSE 'UnKnown' END AS Salutation, vfin_Customers_2.Individual_FirstName, vfin_Customers_2.Individual_LastName, 
                         CASE vfin_Customers_2.Individual_Gender WHEN '57008' THEN 'Male' WHEN '57009' THEN 'Female' ELSE 'UnKnown' END AS Gender, 
                         CASE vfin_Customers_2.Individual_MaritalStatus WHEN '65262' THEN 'Married' WHEN '65263' THEN 'Single' WHEN '65264' THEN 'Divorced' WHEN '65265' THEN 'Separated'
                          ELSE 'UnKnown' END AS MaritalStatus, vfin_Customers_2.Individual_IdentityCardNumber, 
                         CASE dbo.vfin_Customers.Individual_Nationality WHEN 1 THEN 'Kenya' WHEN 2 THEN 'Uganda' WHEN 3 THEN 'Tanzania' WHEN 4 THEN 'Rwanda' WHEN 4 THEN 'Burundi'
                          ELSE 'UnKnown' END AS Nationality, RIGHT('00000' + CAST(LTRIM(RTRIM(vfin_Customers_2.SerialNumber)) AS VARCHAR(5)), 5) AS MembershipNumber, 
                         vfin_Customers_2.Individual_PayrollNumbers, vfin_Customers_2.Individual_BirthDate, vfin_Customers_2.Address_AddressLine1, 
                         vfin_Customers_2.Address_AddressLine2, vfin_Customers_2.Address_Street, vfin_Customers_2.Address_PostalCode, vfin_Customers_2.Address_City, 
                         vfin_Customers_2.Address_Email, vfin_Customers_2.Address_LandLine, vfin_Customers_2.Address_MobileLine, vfin_Customers_2.RegistrationDate, 
                         vfin_Customers_2.CreatedDate, 
                         --CASE vfin_Customers_1.Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818'
                         -- THEN 'Prof' WHEN '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN
                         -- 'Ms' ELSE 'UnKnown' END + ' ' + vfin_Customers_1.Individual_FirstName + ' ' + vfin_Customers_1.Individual_LastName AS 
                         '' as [Witness Person], 
                         dbo.vfin_Stations.Description AS Station, dbo.vfin_Zones.Description AS Zone, dbo.vfin_Divisions.Description AS Division, 
                         dbo.vfin_Employers.Description AS Employer, vfin_Customers_2.Individual_EmploymentDate, vfin_Customers_2.Individual_EmploymentDesignation, 
                         REPLACE(STR(dbo.vfin_Customers.SerialNumber, 5), SPACE(1), '0') AS DelegateMembershipNumber, 
                         dbo.vfin_Customers.Individual_PayrollNumbers AS DelegatePersonalFileNumber, LTRIM(RTRIM(dbo.vfin_Customers.Individual_FirstName)) 
                         + ' ' + LTRIM(RTRIM(dbo.vfin_Customers.Individual_LastName)) AS DelegateName, vfin_Customers_2.Id, REPLACE(STR(vfin_Customers_2.SerialNumber, 6), 
                         SPACE(1), '0') AS SerialNumber, vfin_Customers_2.Reference1, vfin_Customers_2.Reference2, vfin_Customers_2.Reference3
FROM            dbo.vfin_Zones INNER JOIN
                         dbo.vfin_Stations ON dbo.vfin_Zones.Id = dbo.vfin_Stations.ZoneId INNER JOIN
                         dbo.vfin_Divisions ON dbo.vfin_Zones.DivisionId = dbo.vfin_Divisions.Id INNER JOIN
                         dbo.vfin_Employers ON dbo.vfin_Divisions.EmployerId = dbo.vfin_Employers.Id INNER JOIN
                         dbo.vfin_Delegates ON dbo.vfin_Zones.Id = dbo.vfin_Delegates.ZoneId INNER JOIN
                         dbo.vfin_Customers ON dbo.vfin_Delegates.CustomerId = dbo.vfin_Customers.Id RIGHT OUTER JOIN
                         dbo.vfin_Customers AS vfin_Customers_2 ON dbo.vfin_Stations.Id = vfin_Customers_2.StationId --LEFT OUTER JOIN
                         --dbo.vfin_Customers AS vfin_Customers_1 ON vfin_Customers_2.WitnessId = vfin_Customers_1.WitnessId


GO



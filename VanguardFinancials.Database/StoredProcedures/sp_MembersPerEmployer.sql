IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_MemberPerEmployer') BEGIN
   EXEC('CREATE PROC [dbo].[sp_MemberPerEmployer] as')
END

GO
/****** Object:  StoredProcedure [dbo].[sp_MemberPerEmployer]    Script Date: 10/15/2014 5:29:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 15.10.2014
-- Description:	Members Per Station
-- =============================================
---select * from  vfin_Stations order by Description
---sp_MemberPerStation '18CC31DB-4794-C873-296E-08D18A653DD8'
alter PROCEDURE [dbo].[sp_MemberPerEmployer]
	-- Add the parameters for the stored procedure here
	@EmployerID uniqueidentifier
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT        CASE vfin_Customers_2.Individual_Salutation WHEN '48814' THEN 'Mr' WHEN '48815' THEN 'Mrs' WHEN '48816' THEN 'Miss' WHEN '48817' THEN 'Dr' WHEN '48818'
                          THEN 'Prof' WHEN '48819' THEN 'Rev' WHEN '48820' THEN 'Eng' WHEN '48821' THEN 'Hon' WHEN '48822' THEN 'Cllr' WHEN '48823' THEN 'Sir' WHEN '48824' THEN
                          'Ms' ELSE 'UnKnown' END + ' ' + vfin_Customers_2.Individual_FirstName + ' ' + vfin_Customers_2.Individual_LastName AS FullName, 
                         CASE vfin_Customers_2.Individual_Gender WHEN '57008' THEN 'Male' WHEN '57009' THEN 'Female' ELSE 'UnKnown' END AS Gender, 
                         CASE vfin_Customers_2.Individual_MaritalStatus WHEN '65262' THEN 'Married' WHEN '65263' THEN 'Single' WHEN '65264' THEN 'Divorced' WHEN '65265' THEN 'Separated'
                          ELSE 'UnKnown' END AS MaritalStatus, vfin_Customers_2.Individual_IdentityCardNumber, vfin_Customers_2.Individual_PayrollNumbers, 
                         vfin_Customers_2.Individual_BirthDate, vfin_Customers_2.Address_AddressLine1, vfin_Customers_2.Address_AddressLine2, vfin_Customers_2.Address_Street, 
                         vfin_Customers_2.Address_PostalCode, vfin_Customers_2.Address_City, vfin_Customers_2.Address_Email, vfin_Customers_2.Address_LandLine, 
                         vfin_Customers_2.Address_MobileLine, vfin_Customers_2.RegistrationDate, vfin_Customers_2.CreatedDate, dbo.vfin_Stations.Description AS Station, 
                         vfin_Customers_2.Individual_EmploymentDate, vfin_Customers_2.Individual_EmploymentDesignation, REPLACE(STR(vfin_Customers_2.SerialNumber, 5), 
                         SPACE(1), '0') AS DelegateMembershipNumber, LTRIM(RTRIM(vfin_Customers_2.Individual_FirstName)) 
                         + ' ' + LTRIM(RTRIM(vfin_Customers_2.Individual_LastName)) AS DelegateName, vfin_Customers_2.Id, REPLACE(STR(vfin_Customers_2.SerialNumber, 6), 
                         SPACE(1), '0') AS SerialNumber, vfin_Customers_2.Reference1, vfin_Customers_2.Reference2, vfin_Customers_2.Reference3,dbo.vfin_Zones.Description as Zone, 
                         dbo.vfin_Employers.Description AS Employer
	FROM            dbo.vfin_Customers AS vfin_Customers_2 INNER JOIN
                         dbo.vfin_Stations ON vfin_Customers_2.StationId = dbo.vfin_Stations.Id INNER JOIN
                         dbo.vfin_Zones ON dbo.vfin_Stations.ZoneId = dbo.vfin_Zones.Id INNER JOIN
                         dbo.vfin_Divisions ON dbo.vfin_Zones.DivisionId = dbo.vfin_Divisions.Id INNER JOIN
                         dbo.vfin_Employers ON dbo.vfin_Divisions.EmployerId = dbo.vfin_Employers.Id  where dbo.vfin_Employers.Id=@EmployerID
END

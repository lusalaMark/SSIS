IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_MicroCreditSingleGroupsListing') BEGIN
   EXEC('CREATE PROC [dbo].[sp_MicroCreditSingleGroupsListing] as')
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Jeff>
-- Create date: <28/09/2014>
-- Description:	<Listing Micro-Credit Groups>
-- =============================================
---sp_MicroCreditSingleGroupsListing '52BFB977-F469-C187-0B63-08D1A69A5247'
alter PROCEDURE sp_MicroCreditSingleGroupsListing (@GroupID varchar(50))
AS
BEGIN
	SET NOCOUNT ON;
	SELECT       SerialNumber = REPLACE(STR(dbo.vfin_Customers.SerialNumber, 6), SPACE(1), '0')  , dbo.vfin_Customers.NonIndividual_Description as GroupName, dbo.vfin_Customers.NonIndividual_RegistrationNumber as RegistrationNumber, 
							 dbo.vfin_Customers.NonIndividual_PersonalIdentificationNumber as PersonalIdentificationNumber, dbo.vfin_Customers.NonIndividual_DateEstablished as DateEstablished,  
							 Case  dbo.vfin_MicroCreditGroups.Type
							 WHEN 1 THEN 'ROSCA'
							 WHEN 2 THEN 'ASCA'
							 WHEN 3 THEN 'Table Banking'
							 END AS MicroCreditGroupType ,dbo.vfin_Customers.Address_AddressLine1, 
							 dbo.vfin_Customers.Address_AddressLine2, dbo.vfin_Customers.Address_Street, dbo.vfin_Customers.Address_PostalCode, dbo.vfin_Customers.Address_City, 
							 dbo.vfin_Customers.Address_Email, dbo.vfin_Customers.Address_LandLine, dbo.vfin_Customers.Address_MobileLine, 
							 dbo.vw_EmployeeRegister.FullName AS MicroCreditOfficer, dbo.vfin_MicroCreditGroups.Id
	FROM            dbo.vfin_MicroCreditGroups INNER JOIN
							 dbo.vfin_Customers ON dbo.vfin_MicroCreditGroups.CustomerId = dbo.vfin_Customers.Id INNER JOIN
							 dbo.vfin_MicroCreditOfficers ON dbo.vfin_MicroCreditGroups.MicroCreditOfficerId = dbo.vfin_MicroCreditOfficers.Id INNER JOIN
							 dbo.vw_EmployeeRegister ON dbo.vfin_MicroCreditOfficers.EmployeeId = dbo.vw_EmployeeRegister.EmployeeID
	WHERE vfin_MicroCreditGroups.ID=@GroupID
END

GO

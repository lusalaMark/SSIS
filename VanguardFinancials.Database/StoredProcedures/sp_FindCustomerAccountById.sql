IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_FindCustomerAccountById') BEGIN
   EXEC('CREATE PROC [dbo].[sp_FindCustomerAccountById] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FindCustomerAccountById]    Script Date: 9/13/2014 7:52:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[sp_FindCustomerAccountById] 
	-- Add the parameters for the stored procedure here
	@pCustomerAccountId varchar(100) = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	Declare @pLocalCustomerAccountId varchar(100)=@pCustomerAccountId

    -- Insert statements for procedure here
SELECT        dbo.vfin_CustomerAccounts.Id, dbo.vfin_CustomerAccounts.CustomerId, dbo.vfin_CustomerAccounts.BranchId, dbo.vfin_Branches.Code as BranchCode,
                         dbo.vfin_CustomerAccounts.CustomerAccountType_ProductCode, dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId, 
                         dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductCode, dbo.vfin_CustomerAccounts.Remarks, dbo.vfin_CustomerAccounts.CreatedDate, 
                         dbo.vfin_CustomerAccounts.Status, dbo.vfin_CustomerAccounts.CreatedBy, Products_1.ChartOfAccountId, Products_1.InterestReceivable, 
                         CASE WHEN dbo.vfin_Employees.Id IS NOT NULL THEN 1 ELSE 0 END AS isEmployee, dbo.vfin_Customers.Individual_FirstName, 
                         dbo.vfin_Customers.Individual_LastName, dbo.vfin_Customers.Individual_IdentityCardNumber, dbo.vfin_Customers.Individual_PayrollNumbers, 
                         dbo.vfin_Customers.Individual_Salutation, dbo.vfin_Customers.Individual_Gender, dbo.vfin_Customers.Individual_MaritalStatus, 
                         dbo.vfin_Customers.Individual_Nationality, dbo.vfin_Customers.Individual_BirthDate, dbo.vfin_Customers.Individual_EmploymentDesignation, 
                         dbo.vfin_Customers.Individual_EmploymentTermsOfService, dbo.vfin_Customers.Individual_EmploymentDate, dbo.vfin_Customers.NonIndividual_Description, 
                         dbo.vfin_Customers.NonIndividual_RegistrationNumber, dbo.vfin_Customers.NonIndividual_PersonalIdentificationNumber, 
                         dbo.vfin_Customers.NonIndividual_DateEstablished, dbo.vfin_Customers.Address_AddressLine1, dbo.vfin_Customers.Address_AddressLine2, 
                         dbo.vfin_Customers.Address_Street, dbo.vfin_Customers.Address_PostalCode, dbo.vfin_Customers.Address_City, dbo.vfin_Customers.Address_Email, 
                         dbo.vfin_Customers.Address_LandLine, dbo.vfin_Customers.Address_MobileLine, dbo.vfin_Customers.StationId, dbo.vfin_Customers.Reference1, 
                         dbo.vfin_Customers.Reference2, dbo.vfin_Customers.Reference3, dbo.vfin_Customers.Remarks AS CustomerRemarks, 
                         dbo.vfin_Customers.IsLocked, dbo.vfin_Customers.RegistrationDate, dbo.vfin_Customers.CreatedBy AS CustomerCreatedBy, 
                         dbo.vfin_Customers.CreatedDate AS CustomerCreatedDate, dbo.vfin_Customers.PassportImageId, dbo.vfin_Customers.SignatureImageId, 
                         dbo.vfin_Customers.IdentityCardFrontSideImageId, dbo.vfin_Customers.IdentityCardBackSideImageId, dbo.vfin_Customers.SerialNumber, 
                         dbo.vfin_Customers.Type
FROM            dbo.vfin_CustomerAccounts 
						 INNER JOIN dbo.Products(0) AS Products_1 ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = Products_1.id 
						 INNER JOIN dbo.vfin_Customers ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Customers.Id 
						 INNER JOIN dbo.vfin_Branches ON dbo.vfin_CustomerAccounts.BranchId = dbo.vfin_Branches.Id 
						 LEFT OUTER JOIN dbo.vfin_Employees ON dbo.vfin_CustomerAccounts.CustomerId = dbo.vfin_Employees.CustomerId
WHERE vfin_CustomerAccounts.[Id] = @pLocalCustomerAccountId;
END


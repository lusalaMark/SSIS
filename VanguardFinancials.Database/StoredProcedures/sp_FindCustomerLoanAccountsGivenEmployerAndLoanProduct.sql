IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_FindCustomerLoanAccountsGivenEmployerAndLoanProduct') BEGIN
   EXEC('CREATE PROC [dbo].[sp_FindCustomerLoanAccountsGivenEmployerAndLoanProduct] as')
END
GO

/****** Object:  StoredProcedure [dbo].[sp_FindCustomerLoanAccountsGivenEmployerAndLoanProduct]    Script Date: 9/13/2014 8:01:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 20.06.2014
-- Description:	FindCustomerLoanAccountsGivenEmployerAndLoanProduct
-- =============================================
ALTER PROCEDURE [dbo].[sp_FindCustomerLoanAccountsGivenEmployerAndLoanProduct] 
	-- Add the parameters for the stored procedure here
	@EmployerID Varchar(100) , 
	@LoanProductID varchar(100) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT        vfin_CustomerAccounts.*
	FROM            dbo.vfin_Zones INNER JOIN
							 dbo.vfin_Stations ON dbo.vfin_Zones.Id = dbo.vfin_Stations.ZoneId INNER JOIN
							 dbo.vfin_Divisions ON dbo.vfin_Zones.DivisionId = dbo.vfin_Divisions.Id INNER JOIN
							 dbo.vfin_Employers ON dbo.vfin_Divisions.EmployerId = dbo.vfin_Employers.Id INNER JOIN
							 dbo.vfin_Customers ON dbo.vfin_Stations.Id = dbo.vfin_Customers.StationId INNER JOIN
							 dbo.vfin_CustomerAccounts ON dbo.vfin_Customers.Id = dbo.vfin_CustomerAccounts.CustomerId INNER JOIN
							 dbo.vfin_LoanProducts ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_LoanProducts.Id
	WHERE dbo.vfin_Employers.Id=@EmployerID and dbo.vfin_LoanProducts.Id=@LoanProductID

END

GO
/****** Object:  StoredProcedure [dbo].[sp_BanksRegister]    Script Date: 9/13/2014 3:21:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 13/09/2014
-- Description:	Bank Register KBA
-- =============================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_BanksRegister') BEGIN
   EXEC('CREATE PROC [dbo].[sp_BanksRegister] as')
END
GO
ALTER PROCEDURE [dbo].[sp_BanksRegister] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
			(SELECT 
				Code
			FROM [dbo].[vfin_Banks] where ID=[dbo].[vfin_BankBranches].BankId) as BankCode,
			(SELECT 
				[Description]
			FROM [dbo].[vfin_Banks] where ID=[dbo].[vfin_BankBranches].BankId) as BankName
		  ,[Code]
		  ,[Description]
		  ,[Address_AddressLine1]
		  ,[Address_AddressLine2]
		  ,[Address_Street]
		  ,[Address_PostalCode]
		  ,[Address_City]
		  ,[Address_Email]
		  ,[Address_LandLine]
		  ,[Address_MobileLine]
		  ,[CreatedDate]
	  FROM [dbo].[vfin_BankBranches]
	END






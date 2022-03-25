IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_FindCustomerByPayrollNumber') BEGIN
   EXEC('CREATE PROC [dbo].[sp_FindCustomerByPayrollNumber] as')
END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Centrino
-- Create date: 01.06.2014
-- Description:	FindCustomerAccount
-- =============================================
---sp_FindCustomerAccountByTargetProductIdAndPayrollNumber '68E8206F-3B52-CCBE-F04C-08D133526BAB','BPN/PC0233954_1'

alter PROCEDURE [dbo].[sp_FindCustomerByPayrollNumber]
	-- Add the parameters for the stored procedure here
	@pIndividual_PayrollNumber varchar(100) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @pLocalIndividual_PayrollNumber varchar(100)=@pIndividual_PayrollNumber
	SELECT *
	FROM vfin_Customers WHERE CONTAINS(Individual_PayrollNumbers,@pLocalIndividual_PayrollNumber)


	
END



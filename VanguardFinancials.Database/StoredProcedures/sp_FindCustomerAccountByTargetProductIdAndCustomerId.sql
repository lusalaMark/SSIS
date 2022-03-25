IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_FindCustomerAccountByTargetProductIdAndCustomerId') BEGIN
   EXEC('CREATE PROC [dbo].[sp_FindCustomerAccountByTargetProductIdAndCustomerId] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FindCustomerAccountByTargetProductIdAndCustomerId]    Script Date: 9/13/2014 7:54:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[sp_FindCustomerAccountByTargetProductIdAndCustomerId] 
	-- Add the parameters for the stored procedure here
	@pCustomerAccountType_TargetProductId varchar(100) = 0, 
	@pCustomerId varchar(100) = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare 	@LocalpCustomerAccountType_TargetProductId varchar(100) = @pCustomerAccountType_TargetProductId, 
				@LocalpCustomerId varchar(100) = @pCustomerId

    -- Insert statements for procedure here
	SELECT TOP 1 * FROM vfin_CustomerAccounts WHERE [CustomerId] = @LocalpCustomerId AND [CustomerAccountType_TargetProductId] =@LocalpCustomerAccountType_TargetProductId;
END



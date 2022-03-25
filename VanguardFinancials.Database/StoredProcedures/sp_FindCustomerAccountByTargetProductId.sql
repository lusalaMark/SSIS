IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_FindCustomerAccountByTargetProductId') BEGIN
   EXEC('CREATE PROC [dbo].[sp_FindCustomerAccountByTargetProductId] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FindCustomerAccountByTargetProductId]    Script Date: 9/13/2014 7:52:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[sp_FindCustomerAccountByTargetProductId] 
	-- Add the parameters for the stored procedure here
	@pCustomerAccountType_TargetProductId varchar(100) = 0 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @LocalpCustomerAccountType_TargetProductId varchar(100) =@pCustomerAccountType_TargetProductId
    -- Insert statements for procedure here
	SELECT * FROM vfin_CustomerAccounts WHERE [CustomerAccountType_TargetProductId] =@LocalpCustomerAccountType_TargetProductId;
END


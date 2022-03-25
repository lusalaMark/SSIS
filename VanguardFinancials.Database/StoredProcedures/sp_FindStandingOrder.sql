IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_FindStandingOrder') BEGIN
   EXEC('CREATE PROC [dbo].[sp_FindStandingOrder] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FindStandingOrder]    Script Date: 9/13/2014 8:42:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[sp_FindStandingOrder] 
	-- Add the parameters for the stored procedure here
	@pBenefactorCustomerAccountId varchar(100) = 0, 
	@pBeneficiaryCustomerAccountId varchar(100) = 0,
	@pTrigger int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare 	@pLocalBenefactorCustomerAccountId varchar(100) = @pBenefactorCustomerAccountId, 
				@pLocalBeneficiaryCustomerAccountId varchar(100) = @pBeneficiaryCustomerAccountId,
				@pLocalTrigger int = @pTrigger
    -- Insert statements for procedure here
	SELECT TOP 1 * FROM vfin_StandingOrders 
	WHERE [BenefactorCustomerAccountId] =@pLocalBenefactorCustomerAccountId AND 
	[BeneficiaryCustomerAccountId] = @pLocalBeneficiaryCustomerAccountId AND [Trigger] = @pLocalTrigger;
END


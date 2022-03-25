IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_FindStandingOrder') BEGIN
   EXEC('CREATE PROC [dbo].[sp_FindStandingOrder] as')
END
GO

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

    -- Insert statements for procedure here
	SELECT TOP 1 * FROM vfin_StandingOrders WHERE [BenefactorCustomerAccountId] =@pBenefactorCustomerAccountId AND [BeneficiaryCustomerAccountId] = @pBeneficiaryCustomerAccountId AND [Trigger] = @pTrigger;
END


GO

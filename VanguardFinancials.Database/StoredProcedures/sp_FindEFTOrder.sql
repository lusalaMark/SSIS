IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_FindEFTOrder') BEGIN
   EXEC('CREATE PROC [dbo].[sp_FindEFTOrder] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FindEFTOrder]    Script Date: 9/13/2014 8:39:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[sp_FindEFTOrder] 
	-- Add the parameters for the stored procedure here
	@pCustomerAccountId varchar(100) = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 1 * FROM vfin_EFTOrders WHERE [CustomerAccountId] =@pCustomerAccountId;
END


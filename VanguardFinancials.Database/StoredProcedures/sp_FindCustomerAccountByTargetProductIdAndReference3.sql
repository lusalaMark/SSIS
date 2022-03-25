IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_FindCustomerAccountByTargetProductIdAndReference3') BEGIN
   EXEC('CREATE PROC [dbo].[sp_FindCustomerAccountByTargetProductIdAndReference3] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FindCustomerAccountByTargetProductIdAndReference3]    Script Date: 9/13/2014 8:00:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Centrino
-- Create date: 01.06.2014
-- Description:	FindCustomerAccount
-- =============================================
---sp_FindCustomerAccountByTargetProductIdAndReference3 '68E8206F-3B52-CCBE-F04C-08D133526BAB','BPN/PC0233954_1'

ALTER PROCEDURE [dbo].[sp_FindCustomerAccountByTargetProductIdAndReference3] 
	-- Add the parameters for the stored procedure here
	@pCustomerAccountType_TargetProductId varchar(100) = '', 
	@pReference3 varchar(100) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare 	@pLocalCustomerAccountType_TargetProductId varchar(100) = @pCustomerAccountType_TargetProductId, 
				@pLocalReference3 varchar(100) = @pReference3
	SELECT *
	FROM vfin_CustomerAccounts 
	WHERE  CustomerId IN (SELECT Id FROM vfin_Customers WHERE CONTAINS(Reference3, @pLocalReference3))
	AND CustomerAccountType_TargetProductId =@pLocalCustomerAccountType_TargetProductId

	
END


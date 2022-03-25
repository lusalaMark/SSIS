USE [VanguardFinancialsDB_KHS]
GO

/****** Object:  StoredProcedure [dbo].[sp_DeleteCreditBatchDiscrepancies]    Script Date: 06/09/16 8:51:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Centrino
-- Create date: 03.06.2014
-- Description:	DeleteCreditBatchEntries
-- =============================================
create PROCEDURE [dbo].[sp_DeleteCreditBatchDiscrepancies] 
	-- Add the parameters for the stored procedure here
	@CreditBatchID uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DELETE 
	FROM vfin_CreditBatchDiscrepancies 
	WHERE CreditBatchId=@CreditBatchID
END


GO



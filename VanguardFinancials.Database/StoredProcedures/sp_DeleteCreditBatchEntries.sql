IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_DeleteCreditBatchEntries') BEGIN
   EXEC('CREATE PROC [dbo].[sp_DeleteCreditBatchEntries] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteCreditBatchEntries]    Script Date: 9/13/2014 4:22:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 03.06.2014
-- Description:	DeleteCreditBatchEntries
-- =============================================
ALTER PROCEDURE [dbo].[sp_DeleteCreditBatchEntries] 
	-- Add the parameters for the stored procedure here
	@CreditBatchID varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DELETE 
	FROM vfin_CreditBatchEntries 
	WHERE CreditBatchId=@CreditBatchID
END


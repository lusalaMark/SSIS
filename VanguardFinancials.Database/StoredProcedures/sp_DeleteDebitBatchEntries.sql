IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_DeleteDebitBatchEntries') BEGIN
   EXEC('CREATE PROC [dbo].[sp_DeleteDebitBatchEntries] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteDebitBatchEntries]    Script Date: 9/13/2014 4:22:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 03.06.2014
-- Description:	DeleteDebitBatchEntries
-- =============================================
ALTER PROCEDURE [dbo].[sp_DeleteDebitBatchEntries] 
	-- Add the parameters for the stored procedure here
	@DebitBatchID varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DELETE 
	FROM vfin_DebitBatchEntries 
	WHERE DebitBatchId=@DebitBatchID
END


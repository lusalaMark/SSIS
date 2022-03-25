USE [VanguardFinancialsDB_KHS]
GO

/****** Object:  StoredProcedure [dbo].[sp_DeleteJournalReversalBatchEntries]    Script Date: 06/10/16 11:53:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Centrino
-- Create date: 03.06.2014
-- Description:	DeleteCreditBatchEntries
-- =============================================
create PROCEDURE [dbo].[sp_DeleteJournalReversalBatchEntries] 
	-- Add the parameters for the stored procedure here
	@JournalReversalBatchId uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DELETE 
	FROM vfin_JournalReversalBatchEntries 
	WHERE JournalReversalBatchId=@JournalReversalBatchId
END


GO



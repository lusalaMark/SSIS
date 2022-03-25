USE [VanguardFinancialsDB_KHS]
GO

/****** Object:  StoredProcedure [dbo].[sp_DeleteLoanDisbursementBatchEntries]    Script Date: 03/10/16 1:05:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Centrino
-- Create date: 03.06.2014
-- Description:	DeleteLoanDisbursementBatchEntries
-- =============================================
create PROCEDURE [dbo].[sp_DeleteLoanDisbursementBatchEntries] 
	-- Add the parameters for the stored procedure here
	@LoanDisbursementBatchID uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DELETE 
	FROM vfin_LoanDisbursementBatchEntries 
	WHERE LoanDisbursementBatchId=@LoanDisbursementBatchID
END


GO



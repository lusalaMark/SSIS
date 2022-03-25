IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_GetLastCreditBatchEntry') BEGIN
   EXEC('CREATE PROC [dbo].[sp_GetLastCreditBatchEntry] as')
END
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 15.10.2014
-- Description:	Get last values for a credit batch
-- =============================================
alter PROCEDURE sp_GetLastCreditBatchEntry 
	-- Add the parameters for the stored procedure here
	@CustomerAccountID varchar(50), 
	@Type int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT        TOP (1) dbo.vfin_CreditBatchEntries.Balance,dbo.vfin_CreditBatchEntries.Principal, dbo.vfin_CreditBatchEntries.Interest, dbo.vfin_CreditBatchEntries.CustomerAccountId, 
                         dbo.vfin_CreditBatches.Type
	FROM            dbo.vfin_CreditBatches INNER JOIN
                         dbo.vfin_CreditBatchEntries ON dbo.vfin_CreditBatches.Id = dbo.vfin_CreditBatchEntries.CreditBatchId
	WHERE dbo.vfin_CreditBatchEntries.CustomerAccountId=@CustomerAccountId and vfin_CreditBatches.Type=@Type and vfin_CreditBatches.Status=2
	ORDER BY dbo.vfin_CreditBatches.CreatedDate DESC
END
GO

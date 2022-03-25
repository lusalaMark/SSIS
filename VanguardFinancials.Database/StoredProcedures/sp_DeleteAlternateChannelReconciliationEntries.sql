USE [VanguardFinancialsDB_IGS_NEW]
GO

/****** Object:  StoredProcedure [dbo].[sp_DeleteAlternateChannelReconciliationEntries]    Script Date: 8/4/2017 5:05:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Centrino
-- Create date: 03.06.2014
-- Description:	DeleteAlternateChannelReconciliationEntries
-- =============================================
CREATE PROCEDURE [dbo].[sp_DeleteAlternateChannelReconciliationEntries] 
	-- Add the parameters for the stored procedure here
	@AlternateChannelReconciliationPeriodId uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DELETE 
	FROM vfin_AlternateChannelReconciliationEntries 
	WHERE AlternateChannelReconciliationPeriodId = @AlternateChannelReconciliationPeriodId
END




GO




/****** Object:  StoredProcedure [dbo].[sp_DebitBatchEntriesByDebitBatchID]    Script Date: 2/23/2016 3:52:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 16.03.2015
-- Description:	Debit Batch Report
-- =============================================
create PROCEDURE [dbo].[sp_DebitBatchEntriesByDebitBatchID] 
	-- Add the parameters for the stored procedure here
	@DebitBatchID UniqueIdentifier  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT      dbo.vfin_DebitBatchEntries.Reference, dbo.vw_CustomerAccounts.FullName, dbo.vw_CustomerAccounts.Reference1, dbo.vw_CustomerAccounts.Reference2, 
				dbo.vfin_DebitBatchEntries.Multiplier
	FROM        dbo.vfin_DebitBatchEntries INNER JOIN
                         dbo.vw_CustomerAccounts ON dbo.vfin_DebitBatchEntries.CustomerAccountId = dbo.vw_CustomerAccounts.Id
	WHERE		dbo.vfin_DebitBatchEntries.DebitBatchId=@DebitBatchID
END

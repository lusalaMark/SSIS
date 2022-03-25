IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_CreditBatch') BEGIN
   EXEC('CREATE PROC [dbo].[sp_CreditBatch] as')
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

alter PROCEDURE sp_CreditBatch 
	-- Add the parameters for the stored procedure here
	@BatchID uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT        dbo.vw_CustomerAccountsWithoutProductDescription.FullAccount, dbo.vw_CustomerAccountsWithoutProductDescription.FullName, 
                         dbo.vfin_CreditBatchEntries.Principal, dbo.vfin_CreditBatchEntries.Interest, dbo.vw_CustomerAccountsWithoutProductDescription.Reference1
	FROM            dbo.vw_CustomerAccountsWithoutProductDescription RIGHT OUTER JOIN
                         dbo.vfin_CreditBatchEntries ON dbo.vw_CustomerAccountsWithoutProductDescription.Id = dbo.vfin_CreditBatchEntries.CustomerAccountId  
	where CreditBatchId=@BatchID
END
GO

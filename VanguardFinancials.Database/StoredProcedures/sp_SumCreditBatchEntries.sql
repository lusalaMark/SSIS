IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_SumCreditBatchEntries') BEGIN
   EXEC('CREATE PROC [dbo].[sp_SumCreditBatchEntries] as')
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 03.06.2014
-- Description:	SumCreditBatchEntries
-- =============================================
--select top 1 * from vfin_Customers
---[sp_SumCreditBatchEntries] 'D9907B05-7C5B-C5BA-EE8D-08D13F32F7F4'
ALTER PROCEDURE [dbo].[sp_SumCreditBatchEntries] 
	-- Add the parameters for the stored procedure here
	@Creditbatchid varchar(100) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select isnull(sum(isnull(Interest,0)+isnull(principal,0)),0) as Amount 
	from vfin_CreditBatchEntries  
	where creditbatchid=@Creditbatchid
END

GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_GetGlAccountBalance') BEGIN
   EXEC('CREATE PROC [dbo].[sp_GetGlAccountBalance] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetGlAccountBalance]    Script Date: 9/13/2014 8:43:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Centrino
-- Create date: 10.06.2014
-- Description:	GetGLAccountBalance
-- =============================================
--sp_GetGlAccountBalance '2783FA6C-CEAC-CEC5-8DE6-08D10CA97930','0777363D-0845-C660-9E58-08D1336CB025','06/10/2014'
ALTER PROCEDURE [dbo].[sp_GetGlAccountBalance] 
	-- Add the parameters for the stored procedure here
	@ChartOfAccountID varchar(100)  , 
	@EndDate DateTime,
	@TransactionDateFilter int = 1
AS
BEGIN
	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT        isnull(SUM(dbo.vfin_JournalEntries.Amount),0) AS Balance
	FROM            dbo.vfin_JournalEntries INNER JOIN
							 dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id
	WHERE			(dbo.vfin_JournalEntries.ChartOfAccountId = @ChartOfAccountID) 				
					AND 
					Case
					WHEN @TransactionDateFilter =1 then dbo.vfin_Journals.ValueDate 
					WHEN @TransactionDateFilter =2 then dbo.vfin_Journals.CreatedDate 
					END <= @EndDate 
END
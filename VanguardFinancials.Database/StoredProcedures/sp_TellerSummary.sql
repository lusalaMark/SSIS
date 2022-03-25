IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_TellerSummary') BEGIN
   EXEC('CREATE PROC [dbo].[sp_TellerSummary] as')
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
--select * from vfin_Tellers
---sp_TellerSummary '8D709FB9-3D6A-C8A5-5E82-08D13FC96221','05/17/2014'
ALTER PROCEDURE [dbo].[sp_TellerSummary] 
	-- Add the parameters for the stored procedure here
	(
		@TellerCode varchar(50),
		@TrxDate Datetime
	)
AS
	Declare @Date Varchar(10)
	Set @Date=convert(varchar(10),@TrxDate,103)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here

SELECT        dbo.vfin_Tellers.Description, dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName, dbo.vfin_Journals.PrimaryDescription, 
                         case when SUM(dbo.vfin_JournalEntries.Amount)>0 then SUM(dbo.vfin_JournalEntries.Amount)else 0 end AS Credit,
							case when SUM(dbo.vfin_JournalEntries.Amount)<=0 then SUM(dbo.vfin_JournalEntries.Amount) * -1 else 0 end AS Debit,
							 count(dbo.vfin_ChartOfAccounts.AccountCode) as Count
FROM            dbo.vfin_JournalEntries INNER JOIN
                         dbo.vfin_Tellers ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_Tellers.ChartOfAccountId INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_JournalEntries.JournalId = dbo.vfin_Journals.Id INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ContraChartOfAccountId = dbo.vfin_ChartOfAccounts.Id
Where dbo.vfin_Tellers.id=@TellerCode and convert(varchar(10),dbo.vfin_JournalEntries.CreatedDate,103)=@Date
GROUP BY dbo.vfin_Tellers.Description, dbo.vfin_Journals.PrimaryDescription, dbo.vfin_ChartOfAccounts.AccountCode, dbo.vfin_ChartOfAccounts.AccountName
END




GO

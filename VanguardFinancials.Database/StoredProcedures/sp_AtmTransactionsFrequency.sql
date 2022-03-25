IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_AtmTransactionsFrequency') BEGIN
   EXEC('CREATE PROC [dbo].[sp_AtmTransactionsFrequency] as')
END
GO
/****** Object:  StoredProcedure [dbo].[sp_AtmTransactionsFrequency]    Script Date: 9/13/2014 3:10:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
---select * from vfin_ChartOfAccounts where id='36206afb-23d0-cbc4-72d9-08d10cad4b96'
---sp_AtmTransactionsFrequency 2,'06/01/2014', '07/02/2014',0

ALTER PROCEDURE [dbo].[sp_AtmTransactionsFrequency]
	-- Add the parameters for the stored procedure here
	(
		@CardType int,
		@StartDate Datetime,
		@EndDate DateTime,
		@Frequency int
	)
AS
BEGIN
set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));


	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT        dbo.vfin_AlternateChannelLogs.AlternateChannelType as DebitCardType, dbo.vfin_Journals.PrimaryDescription, dbo.vfin_Journals.SecondaryDescription, dbo.vfin_Journals.Reference, 
                         dbo.vfin_Journals.TotalValue, dbo.vw_CustomerAccounts.FullAccount, dbo.vw_CustomerAccounts.Reference1, dbo.vw_CustomerAccounts.FullName, 
                         dbo.vfin_JournalEntries.ChartOfAccountId, dbo.vfin_JournalEntries.CreatedDate, dbo.vfin_JournalEntries.Amount, dbo.vfin_ChartOfAccounts.AccountCode, 
                         dbo.vfin_ChartOfAccounts.AccountName
into #Frequency FROM            dbo.vfin_AlternateChannelLogs INNER JOIN
                         dbo.vfin_Journals ON dbo.vfin_AlternateChannelLogs.Id = dbo.vfin_Journals.AlternateChannelLogId INNER JOIN
                         dbo.vfin_JournalEntries ON dbo.vfin_Journals.Id = dbo.vfin_JournalEntries.JournalId INNER JOIN
                         dbo.vw_CustomerAccounts ON dbo.vfin_JournalEntries.CustomerAccountId = dbo.vw_CustomerAccounts.Id INNER JOIN
                         dbo.vfin_ChartOfAccounts ON dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_ChartOfAccounts.Id
WHERE  dbo.vfin_JournalEntries.CreatedDate between @StartDate and @EndDate and vfin_JournalEntries.ChartOfAccountId=

	case @CardType
	WHEN 1 THEN  '7F2F04D2-BDFC-C8BA-2130-08D10CAE7E33'
	WHEN 2 THEN '36206AFB-23D0-CBC4-72D9-08D10CAD4B96'
	end
  and amount>200
END

select * from #Frequency where FullAccount in (select FullAccount from #Frequency group by FullAccount having count(FullAccount)>@Frequency) order by reference1,createddate


IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='sp_SuspenceAccountSummaries') BEGIN
   EXEC('CREATE PROC [dbo].[sp_SuspenceAccountSummaries] as')
END
GOGO
/****** Object:  StoredProcedure [dbo].[sp_SuspenceAccountSummaries]    Script Date: 7/2/2015 9:18:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
---[sp_SuspenceAccountSummaries] '01/13/2015','01/13/2015','6DE6F767-EAD4-C887-BAB0-08D1ACF05C4C'
ALTER PROCEDURE [dbo].[sp_SuspenceAccountSummaries] 
	-- Add the parameters for the stored procedure here
	@StartDate DateTime,
	@EndDate DateTime,
	@ChartofAccountID uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;
	Declare @OpeningBalance Numeric(18,2)

	set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
	set @OpeningBalance =(select sum(dbo.vfin_JournalEntries.amount) from dbo.vfin_Journals INNER JOIN
							 dbo.vfin_JournalEntries ON dbo.vfin_Journals.Id = dbo.vfin_JournalEntries.JournalId where ChartOfAccountId=@ChartofAccountID and ValueDate< @StartDate);
	With CTESuspense (Row,PrimaryDescription,SecondaryDescription,Debit,Credit)
	as
	(
		Select 2,'Balance B/F','Previous Balance',Case When @OpeningBalance<0 then @OpeningBalance *-1 else 0 end as debit,Case When @OpeningBalance>=0 then @OpeningBalance  else 0 end as Credit
		union
		SELECT     1,   dbo.vfin_Journals.PrimaryDescription, dbo.vfin_Journals.SecondaryDescription, case when SUM(dbo.vfin_JournalEntries.Amount) <0 then SUM(dbo.vfin_JournalEntries.Amount)*-1 else 0 end as Debit,
		case when SUM(dbo.vfin_JournalEntries.Amount) >0 then SUM(dbo.vfin_JournalEntries.Amount) else 0 end as Credit
		FROM            dbo.vfin_Journals INNER JOIN
								 dbo.vfin_JournalEntries ON dbo.vfin_Journals.Id = dbo.vfin_JournalEntries.JournalId
		WHERE        dbo.vfin_Journals.CreatedDate between @StartDate and @EndDate AND (dbo.vfin_JournalEntries.ChartOfAccountId = @ChartofAccountID)
		GROUP BY dbo.vfin_Journals.PrimaryDescription, dbo.vfin_Journals.SecondaryDescription
	)
	Select ROW_NUMBER() OVER(ORDER BY row DESC) AS Row1, * into #tempCTSuspense from CTESuspense

	select *,SUM(credit-Debit) OVER(ORDER BY row1 
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal from #tempCTSuspense
END
---select * from vfin_CreditTypes